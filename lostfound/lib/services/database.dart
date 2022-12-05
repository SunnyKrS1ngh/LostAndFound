import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  //collection reference
  final CollectionReference objCollect =
      FirebaseFirestore.instance.collection('objects');
  Future updateData(String phone, String roll, String name, String pass,
      String confPass, String email) async {
    return await objCollect.doc(uid).set({
      'phone': phone,
      'roll': roll,
      'name': name,
      'pass': pass,
      'confPass': confPass,
      'email': email,
    });
  }
}
