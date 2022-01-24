import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedules.dart';
import '../providers/shifts.dart';
import '../providers/auth.dart';
import '../forms/create_schedule.dart';
import '../admin_schedule/schedule_info.dart';
import 'package:intl/intl.dart';

class ScheduleList extends StatelessWidget {
  static const routeName = '/schedule-list';
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);

    var shiftP = Provider.of<Shifts>(context, listen: false);

    Provider.of<Schedules>(context).getSchedule(auth.token);

    List<ScheduleModel> schedule = Provider.of<Schedules>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedules'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 9.0, top: 8),
                  child: RaisedButton(
                    color: Colors.teal[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.teal[500])),
                    onPressed: () {
                      Navigator.of(context).pushNamed(ScheduleForm.routeName);
                    },
                    child: Text(
                      "New Schedule",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 540,
            child: ListView.builder(
                itemCount: schedule.length,
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 125,
                        color: Colors.grey[400],
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "${DateFormat.yMMMd().format(schedule[i].startPeriod)} - ${DateFormat.yMMMd().format(schedule[i].endPeriod)}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ]),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(children: <Widget>[
                                    Text(
                                        "Schedule ID: ${schedule[i].scheduleID.toString()}"),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          "Total Shifts: ${shiftP.countShiftsOnSchedule(schedule[i].scheduleID)} "),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.teal[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                      color: Colors.teal[500],
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        ScheduleForm.routeName,
                                        arguments: schedule[i]);
                                  },
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                RaisedButton(
                                  color: Colors.teal[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                      color: Colors.teal[500],
                                    ),
                                  ),
                                  onPressed: () {
                                    return showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Are you sure?'),
                                        content: Text(
                                            'Deleting this schedule will delete all associated shifts.'), //${employees.getName(currentChats[i].chatID)}
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Confirm'),
                                            onPressed: () {
                                              Provider.of<Schedules>(context)
                                                  .deleteSchedule(
                                                      schedule[i],
                                                      schedule[i].scheduleID,
                                                      auth.token);
                                              Navigator.of(context).pop(true);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                RaisedButton(
                                  color: Colors.teal[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                      color: Colors.teal[500],
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        ScheduleInfo.routeName,
                                        arguments: schedule[i]);
                                  },
                                  child: Text(
                                    "View",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
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
