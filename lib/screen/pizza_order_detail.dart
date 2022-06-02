import 'dart:developer';

import 'package:flutter/material.dart';
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
                onTap: () {},
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
            log("accept");
            pizzaController.addIngredient(ingredient);
            pizzaController.buildIngredientAnimation();
            pizzaController.animationController.forward(from: 0.0);
            pizzaController.facused.value = false;
          }), onWillAccept: (ingredient) {
            pizzaController.facused.value = true;

            return true;
          }, onLeave: (ingredient) {
            log("leave");
            pizzaController.facused.value = false;
          }, builder: (context, list, rejectedData) {
            return LayoutBuilder(builder: (context, constrains) {
              pizzaController.pizzaConstraints = constrains;
              //print("$constrains ------------------------");
              return RotationTransition(
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
                            
                         return   pizzaController.buildIngredientAnimationWidget();
                          });
                        })
                  ],
                ),
              );
            });
          }),
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
