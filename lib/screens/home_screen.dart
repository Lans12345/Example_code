import 'package:flutter/material.dart';
import 'package:the_serve_new/widgets/service_container.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
                    label: 'Laundry Shops',
                    color: Colors.pinkAccent[700]!,
                    icon: Icons.local_laundry_service),
                ServiceContainer(
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
                    label: 'Barber Shop\n      Salons',
                    color: Colors.red[700]!,
                    icon: Icons.cut_rounded),
                ServiceContainer(
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
                    label: 'Gasoline Stations',
                    color: Colors.orange[700]!,
                    icon: Icons.local_gas_station_rounded),
                ServiceContainer(
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
