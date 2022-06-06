import 'package:flutter/widgets.dart';

class Ingredient {
  final String ?image;
  final String? image_unit;
  final List<Offset> ?positions;
  const Ingredient(
    this.image,
    this.image_unit,
    this.positions,
  );
  
  bool Compare(Ingredient ingredient) => ingredient.image == image;
}

const ingredients = <Ingredient>[
  Ingredient('assets/pizza_order/chili.png',
      'assets/pizza_order/chili_unit.png', <Offset>[
    Offset(0.2, 0.2),
    Offset(0.6, 0.2),
    Offset(0.4, 0.25),
    Offset(0.5, 0.3),
    Offset(0.4, 0.65),
  ]),
  Ingredient('assets/pizza_order/mushroom.png',
      'assets/pizza_order/mushroom_unit.png', <Offset>[
    Offset(0.2, 0.35),
    Offset(0.65, 0.35),
    Offset(0.3, 0.23),
    Offset(0.5, 0.2),
    Offset(0.3, 0.5),
  ]),
  // Ingredient('assets/pizza_order/garlic.png',
  //     'assets/pizza_order/garlic.png', <Offset>[
  //   Offset(0.2, 0.35),
  //   Offset(0.65, 0.35),
  //   Offset(0.3, 0.23),
  //   Offset(0.5, 0.2),
  //   Offset(0.3, 0.5),
  // ]),
  Ingredient('assets/pizza_order/olive.png',
      'assets/pizza_order/olive_unit.png', <Offset>[
    Offset(0.25, 0.5),
    Offset(0.65, 0.6),
    Offset(0.2, 0.3),
    Offset(0.4, 0.2),
    Offset(0.2, 0.6),
  ]),
  Ingredient(
      'assets/pizza_order/onion.png', 'assets/pizza_order/onion.png', <Offset>[
    Offset(0.2, 0.65),
    Offset(0.65, 0.3),
    Offset(0.25, 0.25),
    Offset(0.45, 0.35),
    Offset(0.4, 0.65),
  ]),
  Ingredient(
      'assets/pizza_order/pea.png', 'assets/pizza_order/pea.png', <Offset>[
    Offset(0.2, 0.35),
    Offset(0.65, 0.35),
    Offset(0.3, 0.23),
    Offset(0.5, 0.2),
    Offset(0.3, 0.5),
  ]),
  Ingredient('assets/pizza_order/pickle.png',
      'assets/pizza_order/pickle_unit.png', <Offset>[
    Offset(0.2, 0.65),
    Offset(0.65, 0.3),
    Offset(0.3, 0.2),
    Offset(0.5, 0.25),
    Offset(0.3, 0.35),
  ]),
  Ingredient('assets/pizza_order/potato.png',
      'assets/pizza_order/potato_unit.png', <Offset>[
    Offset(0.2, 0.65),
    Offset(0.65, 0.3),
    Offset(0.25, 0.25),
    Offset(0.45, 0.35),
    Offset(0.4, 0.65),
  ]),
];
