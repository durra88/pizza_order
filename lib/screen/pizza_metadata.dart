import 'dart:typed_data';
import 'package:flutter/material.dart';

class PizzaMetadata {
  PizzaMetadata(this.imageBytes, this.position, this.size);
  late final Uint8List imageBytes;
  late final Offset position;
  late final Size size;
}
