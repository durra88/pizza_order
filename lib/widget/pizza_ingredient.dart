import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/pizza_controller.dart';
import '../ingredient.dart';
import 'pizza_ingredient_item.dart';

class PizzaIngradients extends StatelessWidget {
  const PizzaIngradients({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PizzaController pizzaController = Get.put(PizzaController());

    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          final ingredient = ingredients[index];
          return Obx(() => PizzaIngredientItem(
                ingredient: ingredient,
                exist: pizzaController.containsIngredient(ingredient),
                onTap: () {
                  pizzaController.removeIngredient(ingredient);

                  pizzaController.refreshDeletedIngredient();
                  //log("************after  ${pizzaController.isRemoved.value}");
                },
              ));
        });
  }
}
