import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pizza_order/ingredient.dart';
import 'package:pizza_order/widget/pizza_ingredient.dart';

import '../controller/pizza_controller.dart';
import '../widget/pizza_cart_button.dart';
import '../widget/pizza_size_button.dart';

const _pizzaCartSize = 48.0;
final PizzaController pizzaController = Get.put(PizzaController());

class PizzaOrderDetail extends StatelessWidget {
  const PizzaOrderDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'New Order Pizza',
            style: TextStyle(color: Colors.brown, fontSize: 24),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_shopping_cart_outlined,
                  color: Colors.brown))
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 50,
            left: 10,
            right: 10,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: const [
                  Expanded(
                    flex: 4,
                    child: _PizzaDetails(),
                  ),
                  Expanded(flex: 2, child: PizzaIngradients()),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 25,
              height: 50,
              width: _pizzaCartSize,
              left: MediaQuery.of(context).size.width / 2 - _pizzaCartSize / 2,
              child: PizzaCartButton(
                //?---------------------------------------------------------------------------------------------------------------
                onTap: () {
                  startPizzaBoxAnimationx();
                  print("tapped");
                },
              ))
        ],
      ),
    );
  }
}

//!---------------------------------------------------------------------------------------Pizza Image
class _PizzaDetails extends StatelessWidget {
  const _PizzaDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: DragTarget<Ingredient>(onAccept: ((ingredient) {
          //   log("accept");
          pizzaController.addIngredient(ingredient);
          pizzaController.buildIngredientAnimation();
          pizzaController.animationController.forward(from: 0.0);
          pizzaController.facused.value = false;
        }), onWillAccept: (ingredient) {
          pizzaController.facused.value = true;

          return true;
        }, onLeave: (ingredient) {
          // log("leave");
          pizzaController.facused.value = false;
        }, builder: (context, list, rejectedData) {
          return LayoutBuilder(builder: (context, constrains) {
            pizzaController.pizzaConstraints = constrains;
            //print("$constrains ------------------------");
            return 
              // Future.microtask(() =>
              //     startPizzaBoxAnimation(pizzaController.imagePizza.value));

            AnimatedOpacity(
                duration: const Duration(milliseconds: 60),
                opacity: pizzaController.imagePizza != null ? 0.0 : 1,
                child: RepaintBoundary(
                  key: pizzaController.keyPizza,
                  child: RotationTransition(
                    turns: CurvedAnimation(
                        parent: pizzaController.animationControllerRotation,
                        curve: Curves.elasticInOut),
                    child: Stack(
                      children: [
                        Center(
                          child: Obx(
                            () => AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              height: pizzaController.facused.value
                                  ? constrains.maxHeight *
                                      pizzaController.getFactoryBySize(
                                          pizzaController.pizzaSizeState.value)
                                  : constrains.maxHeight *
                                          pizzaController.getFactoryBySize(
                                              pizzaController
                                                  .pizzaSizeState.value) -
                                      10,
                              child: Stack(
                                children: [
                                  DecoratedBox(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 15.0,
                                                color: Colors.black26,
                                                offset: Offset(0.0, 3.0),
                                                spreadRadius: 5.0)
                                          ]),
                                      child: Image.asset(
                                          'assets/pizza_order/dish.png')),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset(
                                        'assets/pizza_order/pizza-1.png'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                            animation: pizzaController.animationController,
                            builder: (context, _) {
                              //!  pizzaController. animationController.reverse(from: 1.0);
                              return Obx(() {
                                return pizzaController
                                    .buildIngredientAnimationWidget();
                              });
                            })
                      ],
                    ),
                  ),
                ),
              );
            });
          })
       ),
        const SizedBox(
          height: 5,
        ),
        //!---------------------------------------------------------------------------------------Pizza  Price

        Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              // animation.addListener(() {
              //   log("*******${animation.value}*******");
              // });

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(0.0, 0.0),
                        end: Offset(0.0, animation.value),
                      ),
                    ),
                    child: child),
              );
            },
            child: Text(
              "\$${pizzaController.total.value}",
              key: UniqueKey(),
              style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PizzaSizeButton(
                onTap: () {
                  pizzaController.pizzaSizeState.value = 's';
                  pizzaController.animationControllerRotation
                      .forward(from: 0.0);
                },
                text: "S",
                selected:
                    pizzaController.pizzaSizeState.value == 's' ? true : false,
              ),
              PizzaSizeButton(
                onTap: () {
                  pizzaController.pizzaSizeState.value = 'm';
                  pizzaController.animationControllerRotation
                      .forward(from: 0.0);
                },
                text: "M",
                selected:
                    pizzaController.pizzaSizeState.value == 'm' ? true : false,
              ),
              PizzaSizeButton(
                onTap: () {
                  pizzaController.pizzaSizeState.value = 'l';
                  pizzaController.animationControllerRotation
                      .forward(from: 0.0);
                },
                text: "L",
                selected:
                    pizzaController.pizzaSizeState.value == 'l' ? true : false,
              )
            ],
          ),
        )
      ],
    );
  }
}

//!-------------------------------------------------------------
// void addPizzaToCard() {
//   //find position and size of widget
//   RenderRepaintBoundary? boundary = pizzaController.keyPizza.currentContext!
//       .findRenderObject() as RenderRepaintBoundary?;
//   final position = boundary!.localToGlobal(Offset.zero);
//   final size = boundary.size;
//   transformToImage(boundary);
// }

//!----------------------------------------------------------------------------------------------------
class PizzaMetadata {
  PizzaMetadata(this.imageBytes, this.position, this.size);
  late final Uint8List? imageBytes;
  late final Offset? position;
  late final Size? size;
} //!--------------------------------------------------------------------------------------------------------

var imagePizza;
//?------------------------------------------------------------------------------
void transformToImage(RenderRepaintBoundary boundary) async {
  final position = boundary.localToGlobal(Offset.zero);
  final size = boundary.size;
  //obtain the image of the windows as win screenshot
  final image = await boundary.toImage();
  //transfer the image into  byteData to work in image.memory
  ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
  imagePizza = PizzaMetadata(byteData!.buffer.asUint8List(), position, size);
  pizzaController.imagePizza.value =
      PizzaMetadata(byteData.buffer.asUint8List(), position, size);
}

//!-------------------------------
void reset() {
  pizzaController.pizzaAnimationBox.value = false;
  // pizzaController.imagePizza.value = null;
  pizzaController.listIngredients.clear();
  pizzaController.totalValue.value;
  pizzaController.cardIconAnimation.value++;
}

void startPizzaBoxAnimationx() {
  pizzaController.pizzaAnimationBox.value = true;
}

//?-----------------------------------------------------------------------------
late OverlayEntry? overlayEntry;
void startPizzaBoxAnimation(PizzaMetadata metadata) {
  print("overlay");
  overlayEntry = OverlayEntry(builder: (BuildContext context) {
    Overlay.of(context)!.insert(overlayEntry!);

    return PizzaOrderAnimation(
      metadata: metadata,
      onComplete: () {
        overlayEntry!.remove();
        overlayEntry = null as OverlayEntry;
        reset();
      },
    );
  });
}

//!-----------------------------------------------------------
class PizzaOrderAnimation extends StatelessWidget {
  const PizzaOrderAnimation(
      {Key? key, required this.metadata, required this.onComplete})
      : super(key: key);

  final PizzaMetadata metadata;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final moveToX = pizzaController.boxExitToCartAnimation.value > 0
        ? metadata.position!.dx +
            metadata.size!.width /
                2 *
                pizzaController.boxExitToCartAnimation.value
        : 0.0;
    final moveToY = pizzaController.boxExitToCartAnimation.value > 0
        ? -metadata.position!.dx +
            metadata.size!.height /
                1.5 *
                pizzaController.boxExitToCartAnimation.value
        : 0.0;
    return Positioned(
      top: metadata.position!.dy,
      left: metadata.position!.dx,
      width: metadata.size!.width,
      height: metadata.size!.height,
      child: GestureDetector(
        onTap: onComplete,
        child: Obx(
          () => Opacity(
            opacity: 1 - pizzaController.boxExitToCartAnimation.value,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..translate(moveToX, moveToY)
                ..rotateZ(pizzaController.boxExitToCartAnimation.value)
                ..scale(pizzaController.boxExitScaleAnimation.value),
              child: Transform.scale(
                alignment: Alignment.center,
                scale: 1 - pizzaController.boxExitToCartAnimation.value,
                child: Stack(
                  children: [
                    buildBox(),
                    Opacity(
                      opacity: pizzaController.pizzaOpacityAnimation.value,
                      child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..scale(pizzaController.pizzaScaleAnimation.value)
                            ..translate(
                                0.0,
                                20 *
                                    (pizzaController
                                        .pizzaOpacityAnimation.value)),
                          child: Image.memory(metadata.imageBytes!)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBox() {
    return LayoutBuilder(builder: (context, constrains) {
      final boxHeight = constrains.maxHeight / 2.0;
      final boxWidth = constrains.maxWidth / 2.0;
      const minAngle = -45.0;
      const maxAngle = -125.0;
      var boxClosingValue = lerpDouble(
          minAngle, maxAngle, 1 - pizzaController.pizzaOpacityAnimation.value);
      return Transform.scale(
        scale: pizzaController.boxEnterScaleAnimation.value,
        child: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: pizzaController.boxEnterScaleAnimation.value,
                child: Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.003)
                      ..rotateX(minAngle
                          //degreesToRads(boxClosingValue)
                          ),
                    child: Image.asset(
                      'assets/pizza_order/box_inside.png',
                      height: boxHeight,
                      width: boxWidth,
                    )),
              ),
            ),
            Center(
              child: Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.003)
                    ..rotateX(maxAngle
                        //degreesToRads(minAngle)
                        ),
                  child: Image.asset(
                    'assets/pizza_order/box_inside.png',
                    height: boxHeight,
                    width: boxWidth,
                  )),
            ),
            if (boxClosingValue! >= -90)
              Center(
                child: Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.003)
                      ..rotateX(maxAngle
                          //degreesToRads(boxClosingValue)
                          ),
                    child: Image.asset(
                      'assets/pizza_order/box_front.png',
                      height: boxHeight,
                      width: boxWidth,
                    )),
              )
          ],
        ),
      );
    });
  }
}

numdegreeToRads(num deg) {
  return (deg * pi) / 180.0;
}
