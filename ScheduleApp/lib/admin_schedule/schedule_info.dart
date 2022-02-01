import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedules.dart';
import '../providers/shifts.dart';
import '../admin_schedule/shifts_list.dart';
import 'package:intl/intl.dart';

//widget for a button to gain more info for a particular schedule
class ScheduleInfo extends StatelessWidget {
  static const routeName = '/schedule-info';

  @override
  Widget build(BuildContext context) {
    //passes start and end of scheduling period as modal route args
    ScheduleModel args = ModalRoute.of(context).settings.arguments;

    //provider var that can be dot referenced to gain access to their functions
    var shift = Provider.of<Shifts>(context, listen: false);
    var schedule = Provider.of<Schedules>(context, listen: false);
    //creates a list of all the days that are in this scheduling period
    List<DateTime> scheduleDays =
        schedule.getScheduleDays(args.startPeriod, args.endPeriod);

    //formatting and styling
    return Scaffold(
      appBar: AppBar(title: Text("Schedule Info")),
      body: ListView.builder(
        itemCount: scheduleDays.length,
        itemBuilder: (ctx, i) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            child: Container(
                height: 85,
                color: Colors.grey[400],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("${DateFormat.yMMMd().format(scheduleDays[i])}",
                              style: TextStyle(fontSize: 20)),
                          Text(
                              "Shifts on day: ${shift.countShiftsOnDay(scheduleDays[i])}"),
                        ],
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: RaisedButton(
                              color: Colors.teal[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Colors.teal[500],
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    ShiftsList.routeName,
                                    arguments: scheduleDays[i]);
                              },
                              child: Text(
                                "View Day",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ])
                  ],
                )),
          );
        },
      ),
    );
  }
}
