import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

class Loading extends StatelessWidget{
  const Loading();

  @override
  Widget build(BuildContext context){
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Constants.CIRCULAR_PROGRESS_INDICATOR),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}