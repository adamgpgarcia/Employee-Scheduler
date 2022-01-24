import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedules.dart';
import '../providers/shifts.dart';
import '../admin_schedule/shifts_list.dart';
import 'package:intl/intl.dart';

class ScheduleInfo extends StatelessWidget {
  static const routeName = '/schedule-info';

  @override
  Widget build(BuildContext context) {
    ScheduleModel args = ModalRoute.of(context).settings.arguments;
    var shift = Provider.of<Shifts>(context, listen: false);
    var schedule = Provider.of<Schedules>(context, listen: false);
    List<DateTime> scheduleDays =
        schedule.getScheduleDays(args.startPeriod, args.endPeriod);

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
