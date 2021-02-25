import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getUserByFirstName(String firstName) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("firstName", isEqualTo: firstName)
        .where("userType", isEqualTo: "Doctor")
        .snapshots();
  }
}
