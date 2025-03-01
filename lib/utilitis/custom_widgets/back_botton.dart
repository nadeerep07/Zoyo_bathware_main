import 'package:flutter/material.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

Widget backButton(BuildContext context) {
  return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back,
        color: AppColors.buttonColor,
      ));
}
