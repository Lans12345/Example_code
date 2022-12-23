import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_serve_new/screens/map/map_tab.dart';
import 'package:the_serve_new/screens/map/station_tab.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final box = GetStorage();

  int _currentIndex = 0;

  final tabs = [MapTab(), StationTab()];

  final cntrlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextRegular(
            text: box.read('service'), fontSize: 18, color: Colors.white),
        centerTitle: true,
      ),
      body: SafeArea(child: tabs[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.shifting,
        iconSize: 25,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              label: 'Maps'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.drive_eta_rounded,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              label: 'Table'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
