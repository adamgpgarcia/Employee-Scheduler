import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shifts.dart';
import '../providers/schedules.dart';
import '../providers/employees.dart';
import '../admin_timecard/single_view_timecard.dart';
import '../admin_timecard/timecard_stats.dart';

//this widget shows an overview of the current time periods timecard and its submission status.
class EmployeeTimecards extends StatelessWidget {
  static const routeName = '/employee-timecards';
  @override
  Widget build(BuildContext context) {
    //args contains a schedule object
    ScheduleModel args = ModalRoute.of(context).settings.arguments;
    var shift = Provider.of<Shifts>(context, listen: false);
    List<EmployeeAccount> listEmployees =
        Provider.of<Employees>(context, listen: false).items;

    List<TimecardRecord> timecardRecords =
        shift.getRecords(args.scheduleID, listEmployees);

    //formatting and styling s
    return Scaffold(
      appBar: AppBar(title: Text("Schedule: ${args.scheduleID}")),
      body: Column(
        children: <Widget>[
          TimecardStats(args, timecardRecords),
          Container(
            width: double.infinity,
            height: 460,
            child: ListView.builder(
                itemCount: timecardRecords.length,
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 2.0, left: 15.0, right: 15),
                    child: Container(
                        height: 75,
                        color: Colors.grey[400],
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "Name: ${timecardRecords[i].user.firstName.toString()} ${timecardRecords[i].user.lastName.toString()}",
                                      style: TextStyle(fontSize: 18)),
                                  timecardRecords[i].submitted
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6.0),
                                          child: Text("Submitted: Yes"),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6.0),
                                          child: Text("Submitted: No"),
                                        ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Column(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(13.0),
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
                                        SingleViewTimecards.routeName,
                                        arguments: timecardRecords[i]);
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
