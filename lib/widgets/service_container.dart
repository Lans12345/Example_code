import 'package:flutter/material.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

class ServiceContainer extends StatelessWidget {
  late String label;
  late Color color;
  late IconData icon;

  ServiceContainer(
      {required this.label, required this.color, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 150,
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
    );
  }
}
