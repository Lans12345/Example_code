import 'package:cloud_firestore/cloud_firestore.dart';

Future addProduct(
    String name, String desc, String price, String imageURL) async {
  final docUser = FirebaseFirestore.instance.collection('Products').doc();

  final json = {
    'name': name,
    'id': docUser.id,
    'price': price,
    'desc': desc,
    'imageURL': imageURL
  };

  await docUser.set(json);
}
