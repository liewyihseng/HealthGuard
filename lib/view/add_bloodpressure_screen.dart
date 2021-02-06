
import 'package:flutter/material.dart';
import 'package:HealthGuard/view/bloodpressure_screen.dart';
import 'package:HealthGuard/widgets/bloodpressure_chart.dart';

class AddBloodpressureScreen extends StatelessWidget {
  var _sys;
  var _dia;
  var _pul;
  final sysCon = new TextEditingController();
  final diaCon = new TextEditingController();
  final pulCon = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
              }),
          title: Text('Blood Pressure Diary'),
        ),
        body: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: sysCon,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Systolic Reading '),
                    onChanged: (sys) {
                      _sys = sys;
                    },
                  ),
                  TextField(
                    controller: diaCon,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Diastolic Reading '),
                    onChanged: (dia) {
                      _dia = dia;
                    },
                  ),
                  TextField(
                    controller: pulCon,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Pulse Reading '),
                    onChanged: (pul) {
                      _pul = pul;
                    },
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => BloodPressureScreen(
                                  sys: _sys, dia: _dia, pul: _pul)));
                    },
                    child: Text('Submit'),
                  ),
                  Text('$_sys, $_dia, $_pul'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
