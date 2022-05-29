import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pizza_order/ingredient.dart';

import 'controller/pizza_controller.dart';

const _pizzaCartSize = 48.0;
final PizzaController pizzaController = Get.put(PizzaController());

class PizzaOrderDetail extends StatelessWidget {
  const PizzaOrderDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Orleans Pizza',
          style: TextStyle(color: Colors.brown, fontSize: 24),
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
                    flex: 3,
                    child: _PizzaDetails(),
                  ),
                  Expanded(flex: 2, child: _PizzaIngradients()),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 25,
              height: 50,
              width: _pizzaCartSize,
              left: MediaQuery.of(context).size.width / 2 - _pizzaCartSize / 2,
              child: _PizzaCartButton(
                onTap: () {},
              ))
        ],
      ),
    );
  }
}

class _PizzaDetails extends StatelessWidget {
  const _PizzaDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: DragTarget<Ingredient>(onAccept: ((ingredient) {
                log("accept");
                pizzaController.listIngredients.add(ingredient);
                pizzaController.total.value++;
                pizzaController.buildIngredientAnimation();
                pizzaController.animationController.forward(from: 0.0);
                pizzaController.facused.value = false;
              }), onWillAccept: (ingredient) {
                pizzaController.facused.value = true;
                log("on will accept");
                for (Ingredient i in pizzaController.listIngredients) {
                  if (i.Compare(ingredient!)) {
                    return false;
                  }
                }

                log("---------${pizzaController.total.value}----");
                return true;
              }, onLeave: (ingredient) {
                log("leave");
                pizzaController.facused.value = false;
              }, builder: (context, list, rejectedData) {
                return LayoutBuilder(builder: (context, constrains) {
                  pizzaController.pizzaConstraints = constrains;
                  print("$constrains ------------------------");
                  return Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: pizzaController.facused.value
                          ? constrains.maxHeight
                          : constrains.maxHeight - 10,
                      child: Stack(
                        children: [
                          Image.asset('assets/pizza_order/dish.png'),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:
                                Image.asset('assets/pizza_order/pizza-1.png'),
                          )
                        ],
                      ),
                    ),
                  );
                });
              }),
            ),
            const SizedBox(
              height: 5,
            ),
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                        position: animation.drive(Tween<Offset>(
                            begin: const Offset(0.0, 0.0),
                            end: Offset(0.0, animation.value))),
                        child: child),
                  );
                },
                child: Obx(
                  () => Text(
                    key: UniqueKey(),
                    "\$${pizzaController.total.value}",
                    style: const TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                )),
          ],
        ),
        AnimatedBuilder(
            animation: pizzaController.animationController,
            builder: (context, _) {
              return pizzaController.buildIngredientAnimationWidget();
            })
      ],
    );
  }
}

class _PizzaCartButton extends StatelessWidget {
  const _PizzaCartButton({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap;
        pizzaController.animationControllerCart.forward(from: 0.0);
        pizzaController.animationControllerCart.reverse();
        print("------------------------------------------------------tap");
      },
      child: AnimatedBuilder(
        animation: pizzaController.animationControllerCart,
        builder: (context, child) {
          return Transform.scale(
            scale: 2 - pizzaController.animationControllerCart.value,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.orange.withOpacity(0.5),
                        Colors.orange,
                      ]),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 4.0),
                      spreadRadius: 4.0,
                    )
                  ]),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 35,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.orange.withOpacity(0.5),
                    Colors.orange,
                  ]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 4.0),
                  spreadRadius: 4.0,
                )
              ]),
          child: const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }
}

class _PizzaIngradients extends StatelessWidget {
  const _PizzaIngradients({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          final ingredient = ingredients[index];
          return _PizzaIngredientItem(
            ingredient: ingredient,
          );
        });
  }
}

class _PizzaIngredientItem extends StatelessWidget {
  const _PizzaIngredientItem({
    Key? key,
    required this.ingredient,
  }) : super(key: key);
  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Container(
        height: 45,
        width: 45,
        decoration: const BoxDecoration(
            color: Color(0xFFF5EED3), shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(
            ingredient.image,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
    return Center(
        child: Draggable(
            feedback: DecoratedBox(
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 5)
                ]),
                child: child),
            data: ingredient,
            child: child));
  }
}
