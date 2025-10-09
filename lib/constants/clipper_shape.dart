import 'package:flutter/material.dart';

class RoundedCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 25; // Adjust for corner roundness
    Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
