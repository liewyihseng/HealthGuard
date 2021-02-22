import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/model/pedometer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:HealthGuard/constants.dart' as Constants;

class PedometerService{

  var pedometerRef = FirebaseFirestore.instance
      .collection(Constants.USERS)
      .doc(MyAppState.currentUser.userID)
      .collection(Constants.PEDOMETER_INFO);

  sendToServer(PedometerData data, [String docID]) async {
    if (docID == null){
      await pedometerRef.add(data.toJson());
    } else {
      await pedometerRef.doc(docID).set(data.toJson());
    }
  }



}