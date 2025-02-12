import 'package:flutter/material.dart';

class ScreenSize {
  late final double width;
  late final double height;

  void initializeScreenSize(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }
}
