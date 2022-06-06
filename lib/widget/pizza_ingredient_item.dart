import 'package:flutter/material.dart';

import '../ingredient.dart';

class PizzaIngredientItem extends StatelessWidget {
  const PizzaIngredientItem(
      {Key? key,
      required this.ingredient,
      required this.exist,
      required this.onTap})
      : super(key: key);
  final Ingredient ingredient;
  final bool exist;
  final VoidCallback onTap;

  Widget _buildchild({bool withImage = true}) {
    return GestureDetector(
      onTap: exist ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                color: const Color(0xFFF5EED3),
                shape: BoxShape.circle,
                border: exist ? Border.all(color: Colors.red, width: 2) : null),
            child: withImage
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      ingredient.image!,
                      fit: BoxFit.contain,
                    ),
                  )
                : SizedBox.fromSize()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: exist
          ? _buildchild()
          : Draggable(
              feedback: DecoratedBox(
                  decoration:
                      const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(0.0, 5.0),
                        spreadRadius: 5)
                  ]),
                  child: _buildchild()),
              data: ingredient,
              childWhenDragging: _buildchild(withImage: false),
              child: _buildchild()),
    );
  }
}
