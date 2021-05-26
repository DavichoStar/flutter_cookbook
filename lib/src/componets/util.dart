import 'package:flutter/material.dart';

void showSnacbar(BuildContext context, String title, Color backColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
      ),
      backgroundColor: backColor,
    ),
  );
}
