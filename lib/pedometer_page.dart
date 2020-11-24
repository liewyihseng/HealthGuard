import 'package:HealthGuard/widgets/round_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

/// pedometer screen page
class PedometerPage extends StatefulWidget {
  static const String id = "PedometerPage";
  @override
  _PedometerPageState createState() => _PedometerPageState();
}

class _PedometerPageState extends State<PedometerPage> {
  double _stepGoal = 10000;

  //pedometer var
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  String _steps = "0";
  String _status = "Unknown";

  //pedometer services
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = '';
    });
    print("pedestrian status error");
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = "0";
    });
    print("pedometer error");
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pedometer"),
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(10),
              elevation: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundProgressBar(
                    size: 100,
                    color: Colors.orangeAccent,
                    max: 100,
                    value: 50,
                    innerWidget: (percentage) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_fire_department),
                          Text(((percentage * 10).ceil() / 10).toString()),
                        ],
                      );
                    },
                  ),
                  RoundProgressBar(
                      max: 100,
                      size: 100,
                      value: 50,
                      color: Colors.blue[300],
                      innerWidget: (percentage) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.opacity),
                            Text(((percentage * 10).ceil() / 10).toString()),
                          ],
                        );
                      }),
                ],
              ),
            ),
            Center(
              child: RoundProgressBar(
                  value: 50,
                  max: _stepGoal,
                  size: 300,
                  color: Colors.lightGreenAccent,
                  innerWidget: (percentage) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_run,
                          size: 50,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("$_steps / ${_stepGoal.toInt()} steps"),
                        Text(percentage.toString())
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
