import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:HealthGuard/constants.dart' as Constants;


class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getUserByFirstName(String firstName) async {
    return FirebaseFirestore.instance
        .collection(Constants.USERS)
        .where("userType", isEqualTo: "Doctor")
        .where("firstName", isEqualTo: firstName)
        .snapshots();
  }

}
