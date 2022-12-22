import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addProduct(
    String name, String desc, String price, String imageURL) async {
  final docUser = FirebaseFirestore.instance.collection('Products').doc();

  final json = {
    'name': name,
    'id': docUser.id,
    'price': price,
    'desc': desc,
    'imageURL': imageURL,
    'uid': FirebaseAuth.instance.currentUser!.uid
  };

  await docUser.set(json);
}
