import 'package:ScheduleApp/providers/schedules.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedules.dart';
import '../providers/shifts.dart';
import '../providers/auth.dart';
import 'package:intl/intl.dart';

//counts total hours in a shift
double countAllHours(shift, List<TimeCard> userTimeCard) {
  double totalHours = 0;

  for (var item in userTimeCard) {
    if (item.shift.employeeID != 0) {
      totalHours += shift.hoursWorked(item.shift.startTime, item.shift.endTime);
    }
  }
  return totalHours;
}

//gives admin a view on how many hours were worked, not implemented
class HourViewerAdmin extends StatelessWidget {
  List<TimeCard> userTimeCard;

  HourViewerAdmin(this.userTimeCard);

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    var shift = Provider.of<Shifts>(context);
    TimecardCalculations timeCalulations =
        shift.timeCalculations(shift, auth.user, userTimeCard);
    final deviceSize = MediaQuery.of(context).size;

    //formatting and styling
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15.00, right: 15.00),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        width: deviceSize.width,
        height: 150,
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 25),
                child: Text(
                    "Total ${countAllHours(shift, userTimeCard).toString()} hr",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 25),
                child: RaisedButton(
                  color: Colors.teal[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Colors.teal[500],
                    ),
                  ),
                  onPressed: () {
                    shift.toggleSubmitTimeCard(userTimeCard, auth.token);
                  },
                  child: Text(
                    "Return",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          //Text(countAllHours(shift, userTimeCard).toString())
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(children: <Widget>[
                  Text(
                    "${timeCalulations.regTime}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Reg"),
                ]),
                Text(" "),
                Column(children: <Widget>[
                  Text(
                    "${timeCalulations.overTime}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("OT1"),
                ]),
                Text(" "),
                Column(children: <Widget>[
                  Text(
                    "${timeCalulations.doubleTime}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("OT2"),
                ]),
                Text(" "),
                Column(children: <Widget>[
                  Text(
                    "${timeCalulations.lunchTime}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Lunch"),
                ])
              ],
            ),
          ),
          Spacer(),
        ]),
      ),
    );
  }
}
