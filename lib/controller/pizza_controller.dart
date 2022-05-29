import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pizza_order/ingredient.dart';

class PizzaController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController animationControllerCart;
  late Animation cartAnimation;
  List<Animation> animationList = <Animation>[];
  final listIngredients = <Ingredient>[];
  RxBool facused = false.obs;
  RxDouble total = 15.0.obs;
  late BoxConstraints pizzaConstraints;
  @override
  void onInit() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    animationControllerCart = AnimationController(
        lowerBound: 1.0,
        upperBound: 1.5,
        vsync: this,
        duration: const Duration(milliseconds: 150),
        reverseDuration: const Duration(milliseconds: 400));

    cartAnimation =CurvedAnimation(parent: animationControllerCart, curve:  Curves.easeOut) ;

    super.onInit();
  }

  Widget buildIngredientAnimationWidget() {
    List<Widget> element = [];
    if (animationList.isNotEmpty) {
      for (int i = 0; i < listIngredients.length; i++) {
        Ingredient ingredient = listIngredients[i];
        final ingredientWidget = Image.asset(
          ingredient.image,
          height: 40,
        );
        for (int j = 0; j < ingredient.positions.length; j++) {
          final animation = animationList[j];
          final position = ingredient.positions[j];
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

  @override
  void onClose() {
    animationController.dispose();
    animationControllerCart.dispose();
    super.onClose();
  }
}
