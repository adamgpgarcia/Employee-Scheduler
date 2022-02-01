import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shifts.dart';
import '../providers/schedules.dart';
import '../providers/auth.dart';
import 'package:intl/intl.dart';
import '../admin_timecard/employee_timecards.dart';

//this widget lists all the timecards that have been submitted to the admin user
class TimecardList extends StatelessWidget {
  static const routeName = '/timecard-list';

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    var shiftP = Provider.of<Shifts>(context, listen: false);
    Provider.of<Schedules>(context).getSchedule(auth.token);
    List<ScheduleModel> schedule = Provider.of<Schedules>(context).items;

    //formatting and styling
    return Scaffold(
      appBar: AppBar(
        title: Text("Timecard Record"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 500,
            child: ListView.builder(
                itemCount: schedule.length,
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
                    child: Container(
                        height: 85,
                        color: Colors.grey[400],
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 12.0, bottom: 10),
                                  child: Text(
                                      "${DateFormat.yMMMd().format(schedule[i].startPeriod)} - ${DateFormat.yMMMd().format(schedule[i].endPeriod)}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, bottom: 12.0),
                                  child: Text(
                                      "Schedule ID: ${schedule[i].scheduleID.toString()}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: RaisedButton(
                                      color: Colors.teal[900],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                          color: Colors.teal[500],
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            EmployeeTimecards.routeName,
                                            arguments: schedule[i]); //
                                      },
                                      child: Text(
                                        "View",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ])
                          ],
                        )),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
