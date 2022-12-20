import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_serve_new/screens/map/map_screen.dart';
import 'package:the_serve_new/widgets/service_container.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextRegular(
            text: 'Service Providers', fontSize: 18, color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ServiceContainer(
                    onTap: () {
                      box.write('service', 'Laundry Shops');
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MapScreen()));
                    },
                    label: 'Laundry Shops',
                    color: Colors.pinkAccent[700]!,
                    icon: Icons.local_laundry_service),
                ServiceContainer(
                    onTap: () {
                      box.write('service', 'Water Refilling Stations');
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MapScreen()));
                    },
                    label: 'Water Refilling\n      Stations',
                    color: Colors.blue[700]!,
                    icon: Icons.water_damage_rounded),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ServiceContainer(
                    onTap: () {
                      box.write('service', 'Barber Shops and Salons');
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MapScreen()));
                    },
                    label: 'Barber Shop\n      Salons',
                    color: Colors.red[700]!,
                    icon: Icons.cut_rounded),
                ServiceContainer(
                    onTap: () {
                      box.write('service', 'Auto-Repair Shops');
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MapScreen()));
                    },
                    label: 'Auto-Repair\n      Shops',
                    color: Colors.green[700]!,
                    icon: Icons.home_repair_service),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ServiceContainer(
                    onTap: () {
                      box.write('service', 'Gasoline Stations');
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MapScreen()));
                    },
                    label: 'Gasoline Stations',
                    color: Colors.orange[700]!,
                    icon: Icons.local_gas_station_rounded),
                ServiceContainer(
                    onTap: () {
                      box.write('service', 'Print, Xerox, Laminate Services');
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MapScreen()));
                    },
                    label: 'Print, Xerox,\nLaminate\nServices',
                    color: Colors.yellow[700]!,
                    icon: Icons.print),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
