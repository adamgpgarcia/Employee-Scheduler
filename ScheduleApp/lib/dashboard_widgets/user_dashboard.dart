import 'package:provider/provider.dart';
import '../providers/shifts.dart';
import '../providers/auth.dart';
import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isNull(var temp) {
      if (temp == null) {
        return true;
      } else {
        return false;
      }
    }

    var auth = Provider.of<Auth>(context, listen: false);
    var shift = Provider.of<Shifts>(context, listen: false);

    ShiftModel shiftToday = shift.shiftToday(DateTime.now(), auth.user);

    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey[400],
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: Offset(2, 3))
              ]),
          width: 350,
          height: 150,
          child: isNull(shiftToday)
              ? Center(
                  child: Text(
                  "Off Today",
                  style: TextStyle(fontSize: 20),
                ))
              : Center(
                  child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 15),
                      child: Text(
                        "Scheduled Today",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "Position: ${shiftToday.position}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Time: ${shiftToday.startTime.hour.toString()}:${shiftToday.startTime.minute.toString()} - ${shiftToday.endTime.hour.toString()}:${shiftToday.endTime.minute.toString()}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )),
        ),
      ),
    ]);
  }
}
