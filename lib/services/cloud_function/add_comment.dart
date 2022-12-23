import 'package:cloud_firestore/cloud_firestore.dart';

Future addComment(String name, String message, String userId) async {
  final docUser = FirebaseFirestore.instance.collection('Comments').doc();

  final json = {
    'name': name,
    'comment': message,
    'id': docUser.id,
    'uid': userId
  };

  await docUser.set(json);
}
