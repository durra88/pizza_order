enum PizzaSizeValue { s, m, l }

class PizzaSizeState {
  PizzaSizeState(this.value) : factor = getFactoryBySize(value);
  final PizzaSizeValue value;
  final double factor;

  static double getFactoryBySize(PizzaSizeValue value) {
    switch (value) {
      case PizzaSizeValue.s:
        return 0.8;
      case PizzaSizeValue.m:
        return 1.00;
      case PizzaSizeValue.l:
        return 1.2;
    }
  }
}
