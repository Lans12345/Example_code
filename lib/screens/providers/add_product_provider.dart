import 'package:flutter/material.dart';
import 'package:the_serve_new/screens/providers/provider_home.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

class AddProduct extends StatelessWidget {
  final productNameController = TextEditingController();
  final productDescController = TextEditingController();

  final productPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:
            TextRegular(text: 'Add Product', fontSize: 18, color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            TextRegular(
                text: 'Product Image', fontSize: 12, color: Colors.grey),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 150,
              width: 150,
              color: Colors.grey,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: productNameController,
                decoration: const InputDecoration(
                  hintText: 'Product Name',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: productDescController,
                decoration: const InputDecoration(
                  hintText: 'Product Decription',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextFormField(
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.sentences,
                controller: productPriceController,
                decoration: const InputDecoration(
                    hintText: 'Product Price', suffixText: '00.php'),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            MaterialButton(
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minWidth: 250,
              color: Colors.blue,
              onPressed: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => AlertDialog(
                          content: const Text(
                            'Product Posted Succesfully!',
                            style: TextStyle(fontFamily: 'QRegular'),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () async {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => ProviderHome()));
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
              child: TextBold(
                  text: 'Add Product', fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
