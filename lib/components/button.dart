import 'package:flutter/material.dart';

import '../const/colors.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
  });

  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      // Button Widget with icon for Undo and Restart Game button.
      return Container(
        decoration: BoxDecoration(
          color: scoreColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: IconButton(
          color: textColorWhite,
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 24.0,
          ),
        ),
      );
    }

    // Button Widget with text for New Game and Try Again button.
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(16.0)),
          backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
        ),
        child: Text(
          text!,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: textColorWhite),
        ));
  }
}
