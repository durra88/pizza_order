
import 'package:flutter/material.dart';

import '../screen/pizza_order_detail.dart';

class PizzaCartButton extends StatelessWidget {
  const PizzaCartButton({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onTap;
          pizzaController.cartSize.value = 35.01;
          pizzaController.animateButton();
          // pizzaController.animationControllerCart.addListener(() {
          //   log("@@@@@@${pizzaController.animationControllerCart}@@@");
          // });
        },
        child: AnimatedBuilder(
          animation: pizzaController.animationControllerCart,
          builder: (context, child) {
            return Transform.scale(
                scale: 1 - pizzaController.animationControllerCart.value,
                child: child);
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
            child: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: pizzaController.cartSize.value,
            ),
          ),
        ));
  }
}
