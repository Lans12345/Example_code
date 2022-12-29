import 'package:flutter/material.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(top: 0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              accountEmail:
                  TextRegular(text: '', fontSize: 0, color: Colors.white),
              accountName: TextBold(
                text: 'John Doe',
                fontSize: 18,
                color: Colors.white,
              ),
              currentAccountPicture: const Padding(
                padding: EdgeInsets.all(5.0),
                child: CircleAvatar(
                  minRadius: 50,
                  maxRadius: 50,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
              ),
            ),
            ListTile(
              title: TextBold(
                text: 'Chat Room',
                fontSize: 12,
                color: Colors.black,
              ),
              onTap: () {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) => ChatRoom()));
              },
            ),
            // ),
            // ListTile(
            //   trailing: IconButton(
            //     onPressed: () {
            //       Navigator.of(context).pushReplacement(MaterialPageRoute(
            //           builder: (context) => AddProductPage()));
            //     },
            //     icon: const Icon(Icons.add),
            //   ),
            //   title: TextBold(
            //     text: 'Products',
            //     fontSize: 12,
            //     color: Colors.black,
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(
            //         MaterialPageRoute(builder: (context) => CrewHome()));
            //   },
            // ),
            // ListTile(
            //   title: TextBold(
            //     text: 'Logbook',
            //     fontSize: 12,
            //     color: Colors.black,
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(
            //         MaterialPageRoute(builder: (context) => LogbookPage()));
            //   },
            // ),
            // ListTile(
            //   title: TextBold(
            //     text: 'Inventory',
            //     fontSize: 12,
            //     color: Colors.black,
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(
            //         MaterialPageRoute(builder: (context) => InventoryPage()));
            //   },
            // ),
            // ListTile(
            //   title: TextBold(
            //     text: 'Sales History',
            //     fontSize: 12,
            //     color: Colors.black,
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(MaterialPageRoute(
            //         builder: (context) => SalesHistoryPage()));
            //   },
            // ),
            // ListTile(
            //   title: TextBold(
            //     text: 'Waste Reports',
            //     fontSize: 12,
            //     color: Colors.black,
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(
            //         MaterialPageRoute(builder: (context) => WasteReportPage()));
            //   },
            // ),
            // ListTile(
            //   title: TextBold(
            //     text: 'Expenses',
            //     fontSize: 12,
            //     color: Colors.black,
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(
            //         MaterialPageRoute(builder: (context) => ExensesPage()));
            //   },
            // ),
            ListTile(
              title: TextBold(
                text: 'Logout',
                fontSize: 12,
                color: Colors.black,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                            'Logout Confirmation',
                            style: TextStyle(
                                fontFamily: 'QBold',
                                fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                            'Are you sure you want to Logout?',
                            style: TextStyle(fontFamily: 'QRegular'),
                          ),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                    fontFamily: 'QRegular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                // Navigator.of(context).pushReplacement(
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const LogInPage()));
                              },
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                    fontFamily: 'QRegular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
