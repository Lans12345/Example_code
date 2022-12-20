import 'package:flutter/material.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

class ServiceContainer extends StatelessWidget {
  late String label;
  late Color color;
  late IconData icon;

  late VoidCallback onTap;

  ServiceContainer(
      {required this.label,
      required this.color,
      required this.icon,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: 170,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 42,
            ),
            const SizedBox(height: 10),
            TextBold(text: label, fontSize: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
