import 'package:flutter/material.dart';
import 'package:HealthGuard/widgets/round_progress_bar.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Pedometer extends StatefulWidget {
  @override
  _PedometerState createState() => _PedometerState();
}

class _PedometerState extends State<Pedometer> {
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
                    innerWidget: (percentage) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_fire_department),
                          Text(((percentage * 10).ceil() / 10).toString()),
                        ],
                      );
                    }
                  ),
                  RoundProgressBar(
                      size: 100,
                      color: Colors.blue[300],
                      innerWidget: (percentage) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.opacity),
                            Text(((percentage * 10).ceil() / 10).toString()),
                          ],
                        );
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
