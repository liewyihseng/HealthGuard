
import 'package:flutter/material.dart';
import 'package:HealthGuard/view/add_bloodpressure_screen.dart';
import 'package:HealthGuard/widgets/bloodpressure_chart.dart';
import 'package:HealthGuard/constants.dart' as Constants;

class BloodPressureScreen extends StatelessWidget {
  static const String id = "Bloodpressure_screen";
  var sys;
  var dia;
  var pul;
  BloodPressureScreen({@required this.sys, @required this.dia, @required this.pul});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Blood Pressure Diary',
          style: TextStyle(
            color: Colors.white,
            fontFamily: Constants.FONTSTYLE,
            fontWeight: Constants.APPBAR_TEXT_WEIGHT,),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Constants.APPBAR_COLOUR,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.BUTTON_COLOUR,
        child: Icon(
          Icons.add,
          color: Colors.white,),
        splashColor: Colors.blue,
        shape: CircleBorder(
          side: BorderSide(color: Colors.blue),
        ),
        onPressed: () async {
          var navigationResult = await Navigator.push(context,
              new MaterialPageRoute(builder: (context) => AddBloodpressureScreen()));
        },
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => ChartsDemo()));
                    },
                    child: Text('Graph'),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Systolic')),
                        DataColumn(label: Text('Diastolic')),
                        DataColumn(label: Text('Pulse')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('$sys')),
                          DataCell(Text('$dia')),
                          DataCell(Text('$pul')),
                        ])
                      ],
                    )),
              ],
            ))
      ]),
    );
  }
}
