import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pizza_order/ingredient.dart';

import '../screen/pizza_order_detail.dart';

class PizzaController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController animationControllerCart;
  late AnimationController animationControllerRotation;
  late AnimationController animationControllerPizza;
  late Animation<double> pizzaScaleAnimation;
  late Animation<double> pizzaOpacityAnimation;
  late Animation<double> boxEnterScaleAnimation;
  late Animation<double> boxExitScaleAnimation;
  late Animation<double> boxExitToCartAnimation;

  var isRemoved = 0.obs;
  var cartSize = 35.0.obs;
  var pizzaAnimationBox = false.obs;
  final keyPizza = GlobalKey();
  late var imagePizza = PizzaMetadata(null, null, null).obs;
  var cardIconAnimation = 0.obs;
  var initialTotal = 15.0;
  var totalValue = 15.0.obs;
  var totalCart = 0;
  late BuildContext context;

  List<Animation> animationList = <Animation>[].obs;
  var listIngredients = <Ingredient>[].obs;
  //var deletedIngredients = <Ingredient>[].obs;
  var deletedIngredients = <Ingredient>[
    const Ingredient('', '', <Offset>[
      Offset(0.0, 0.0),
    ])
  ].obs;
  RxBool facused = false.obs;
  RxDouble total = 15.0.obs;
  late BoxConstraints pizzaConstraints;
  //final pizzaSize = PizzaSizeState(PizzaSizeState.m);
  //!size pizza
  var pizzaSizeState = "m".obs;
  RxDouble factor = 0.0.obs;
  getFactoryBySize(pizzaSizeValue) {
    switch (pizzaSizeValue) {
      case "s":
        return 0.8;
      case "m":
        return 1.00;
      case "l":
        return 1.2;
    }
    return 1.0;
  }

  @override
  void onInit() {
    //!text
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    //!Rotation
    animationControllerRotation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    //!cart
    animationControllerCart = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        vsync: this,
        duration: const Duration(milliseconds: 150),
        reverseDuration: const Duration(milliseconds: 400));
    //!pizza
    animationControllerPizza = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500));
    pizzaScaleAnimation = Tween(begin: 1.0, end: 0.5).animate(CurvedAnimation(
        parent: animationControllerPizza, curve: const Interval(0.0, 0.2)));
    pizzaOpacityAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500));
    pizzaOpacityAnimation = CurvedAnimation(
        parent: animationControllerPizza, curve: const Interval(0.2, 0.4));

    boxEnterScaleAnimation = CurvedAnimation(
        parent: animationControllerPizza, curve: const Interval(0.0, 0.2));

    boxExitScaleAnimation = Tween(begin: 1.0, end: 1.3).animate(CurvedAnimation(
        parent: animationControllerPizza, curve: const Interval(0.5, 0.7)));

    boxExitToCartAnimation = CurvedAnimation(
        parent: animationControllerPizza, curve: const Interval(0.8, 1.0));
    animationControllerPizza.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //widget.onComplete();
      }
      animationControllerPizza.forward();
    });
    addPizzaToCard();
    //!box
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    //   final controler = PizzaOrderDetail.of(context);
    //   controler.pizzaBoxAnimation.addListener(() {
    //     if (controler.pizzaBoxAnimation.value) {
    //       addPizzaToCard();
    //     }
    //   });
    // });
    super.onInit();
  }

//?------------------------------------------------------------------------------

  void addPizzaToCard() {
    //find position and size of widget
    RenderRepaintBoundary? boundary = pizzaController.keyPizza.currentContext!
        .findRenderObject() as RenderRepaintBoundary?;
    final position = boundary!.localToGlobal(Offset.zero);
    final size = boundary.size;
    transformToImage(boundary);
  }

//!add gredient
  void addIngredient(Ingredient ingredient) {
    listIngredients.add(ingredient);
    total.value++;
  }

  //! if  it is contain gradient
  bool containsIngredient(Ingredient ingredient) {
    for (Ingredient i in listIngredients) {
      if (i.Compare(ingredient)) {
        return true;
      }
    }
    return false;
  }

  //!remouve ingredient
  Future<void> removeIngredient(Ingredient ingredient) async {
    listIngredients.remove(ingredient);

    total.value--;

    deletedIngredients.add(ingredient);

    //refreshDeletedIngredient();
  }

  void refreshDeletedIngredient() {
    deletedIngredients.value = [];
  }

//!pizzaboxanimation

  Widget buildIngredientAnimationWidget() {
    List<Widget> element = [];

    if (animationList.isNotEmpty) {
      for (int i = 0; i < listIngredients.length; i++) {
        Ingredient ingredient = listIngredients[i];
        final ingredientWidget = Image.asset(
          ingredient.image_unit!,
          height: 40,
        );
        for (int j = 0; j < ingredient.positions!.length; j++) {
          final animation = animationList[j];
          final position = ingredient.positions![j];
          final positionX = position.dx;
          final positionY = position.dy;

          if (i == listIngredients.length - 1) {
            double fromX = 0.0;
            double fromY = 0.0;
            if (j < 1) {
              fromX = -pizzaConstraints.maxWidth * (1 - animation.value);
            } else if (j < 2) {
              fromX = pizzaConstraints.maxWidth * (1 - animation.value);
            } else if (j < 4) {
              fromY = -pizzaConstraints.maxHeight * (1 - animation.value);
            } else {
              fromY = pizzaConstraints.maxHeight * (1 - animation.value);
            }
            final opacity = animation.value;
            if (animation.value > 0) {
              element.add(
                Opacity(
                  opacity: opacity,
                  child: Transform(
                      transform: Matrix4.identity()
                        ..translate(
                            fromX + pizzaConstraints.maxWidth * positionY,
                            fromY + pizzaConstraints.minHeight * positionX),
                      child: ingredientWidget),
                ),
              );
            }
          } else {
            element.add(
              Transform(
                  transform: Matrix4.identity()
                    ..translate(pizzaConstraints.maxWidth * positionY,
                        pizzaConstraints.minHeight * positionX),
                  child: ingredientWidget),
            );
          }
        }
      }

      return Stack(
        children: element,
      );
    } else {
      return SizedBox.fromSize();
    }
  }

//!animate items
  void buildIngredientAnimation() {
    animationList.clear();
    animationList.add(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.decelerate)));
    animationList.add(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.decelerate)));
    animationList.add(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 0.7, curve: Curves.decelerate)));

    animationList.add(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.1, 0.7, curve: Curves.decelerate)));
    animationList.add(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.decelerate)));
  }

//!animate button
  Future<void> animateButton() async {
    animationControllerCart.forward(from: 0.0);
    animationControllerCart.reverse(from: 0.8);
    animationControllerCart.addListener(() {
      //   log("@@@@@@cc${animationControllerCart.forward}@@@");
    });

    // log("@@@@@@hi it me @@@");
  }

  @override
  void onClose() {
    animationController.dispose();
    animationControllerCart.dispose();
    animationControllerRotation.dispose();
    animationControllerPizza.dispose();
    super.onClose();
  }
}
