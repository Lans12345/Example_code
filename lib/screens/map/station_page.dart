import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_serve_new/widgets/button_widget.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

class StationPage extends StatelessWidget {
  final box = GetStorage();

  final commentController = TextEditingController();

  showToast() {
    Fluttertoast.showToast(
        msg: "Comment sent succesfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              text: 'Station',
            ),
            Tab(
              text: 'Products',
            ),
          ]),
          backgroundColor: Colors.blue,
          title: TextRegular(
              text: box.read('service'), fontSize: 18, color: Colors.white),
          centerTitle: true,
        ),
        body: TabBarView(children: [
          SingleChildScrollView(
            child: StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 200,
                        width: 300,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextBold(
                          text: 'Station Name',
                          fontSize: 18,
                          color: Colors.black),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: TextFormField(
                          maxLines: 5,
                          controller: commentController,
                          decoration: const InputDecoration(
                            hintText: ' Leave a comment',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ButtonWidget(
                          onPressed: () {
                            showToast();
                            commentController.clear();
                          },
                          text: 'Send'),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 3,
                                ),
                              ),
                              height: 40,
                              width: 75,
                              child: Center(
                                  child: TextBold(
                                      text: 'MESSAGE',
                                      fontSize: 14,
                                      color: Colors.black)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 3,
                                ),
                              ),
                              height: 40,
                              width: 75,
                              child: Center(
                                  child: TextBold(
                                      text: 'CALL',
                                      fontSize: 14,
                                      color: Colors.black)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 3,
                                ),
                              ),
                              height: 40,
                              width: 75,
                              child: Center(
                                  child: TextBold(
                                      text: 'URL',
                                      fontSize: 14,
                                      color: Colors.black)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 3,
                                ),
                              ),
                              height: 40,
                              width: 75,
                              child: Center(
                                  child: TextBold(
                                      text: 'EMAIL',
                                      fontSize: 14,
                                      color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: ListTile(
                        title: TextBold(
                            text: 'Product Name',
                            fontSize: 14,
                            color: Colors.black),
                        trailing: TextBold(
                            text: 'Price', fontSize: 12, color: Colors.grey),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          minRadius: 20,
                          maxRadius: 20,
                        ),
                        tileColor: Colors.white,
                      ),
                    );
                  })),
                );
              })
        ]),
      ),
    );
  }
}
