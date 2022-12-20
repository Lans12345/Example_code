import 'package:flutter/material.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  final String text;

  const ButtonWidget({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 30,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      minWidth: 100,
      color: Colors.blue,
      onPressed: onPressed,
      child: TextBold(text: text, fontSize: 14, color: Colors.white),
    );
  }
}
