
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/model/pedometer_model.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/net/authentication.dart';


/// send data to database
sendToServer(PedometerData pedometerData) async {

  // /// construct updated data
  // PedometerData pedometerData = PedometerData(
  //   water: water,
  //   steps: steps,
  //   calories: _calories,
  //   previousDayNo: _previousDayNo,
  //   previousSteps: _previousSteps,
  // );

  /// store it to fire store
  await FireStoreUtils.firestore
      .collection(Constants.USERS)
      .doc(MyAppState.currentUser.userID)
      .collection(Constants.PEDOMETER_INFO)
      .add(pedometerData.toJson());
}