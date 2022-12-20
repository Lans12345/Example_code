import 'package:flutter/material.dart';
import 'package:the_serve_new/screens/map/station_page.dart';

import '../../widgets/text_widget.dart';

class StationTab extends StatelessWidget {
  final cntrlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black),
            ),
            width: double.infinity,
            height: 50,
            child: TextFormField(
              controller: cntrlr,
              decoration: const InputDecoration(
                hintText: 'Search a station',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: SizedBox(
            child: ListView.builder(itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => StationPage()));
                      },
                      leading: Container(
                        color: Colors.black,
                        height: 80,
                        width: 100,
                      ),
                      title: TextBold(
                          text: 'Station Name',
                          fontSize: 14,
                          color: Colors.black),
                      trailing: TextRegular(
                          text: '100km', fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
              );
            })),
          ),
        )
      ],
    );
  }
}
