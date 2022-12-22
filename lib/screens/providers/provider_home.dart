import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_serve_new/auth/providers/provider_login.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

class ProviderHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.post_add_rounded),
              text: 'Products',
            ),
            Tab(
              icon: Icon(Icons.feedback),
              text: 'Feedbacks',
            ),
          ]),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () async {
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
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                    fontFamily: 'QRegular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            FlatButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProviderLogin()));
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
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
          backgroundColor: Colors.blue,
          title: TextRegular(text: 'Home', fontSize: 18, color: Colors.white),
          centerTitle: true,
        ),
        body: TabBarView(children: [
          Scaffold(
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add), onPressed: () {}),
            body: ListView.builder(itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ListTile(
                  tileColor: Colors.white,
                  title: TextBold(
                      text: 'Product Name', fontSize: 14, color: Colors.black),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  leading: const CircleAvatar(
                    minRadius: 25,
                    maxRadius: 25,
                    backgroundColor: Colors.grey,
                  ),
                ),
              );
            }),
          ),
          ListView.builder(itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: ListTile(
                tileColor: Colors.white,
                title: TextRegular(
                    text: 'Content here', fontSize: 12, color: Colors.black),
                subtitle: TextRegular(
                    text: 'Name here', fontSize: 10, color: Colors.grey),
              ),
            );
          }))
        ]),
      ),
    );
  }
}
