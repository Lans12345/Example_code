import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

class StationPage extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextRegular(
            text: box.read('service'), fontSize: 18, color: Colors.white),
        centerTitle: true,
      ),
    );
  }
}
