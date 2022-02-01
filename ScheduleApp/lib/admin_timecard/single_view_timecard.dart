import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shifts.dart';
import '../providers/schedules.dart';
import '../timecard_widgets/hour_viewer_admin.dart';
import '../providers/auth.dart';
import 'package:intl/intl.dart';

//this is the full timecard view that shows days you worked/off with start and stop times, regular time and overtime are calculated accordingly.
class SingleViewTimecards extends StatelessWidget {
  static const routeName = '/single-view-timecards';
  @override
  Widget build(BuildContext context) {
    //args contains the timecard of the user
    TimecardRecord args = ModalRoute.of(context).settings.arguments;
    var shift = Provider.of<Shifts>(context, listen: false);
    var auth = Provider.of<Auth>(context, listen: false);
    var schedule = Provider.of<Schedules>(context, listen: false);

    ScheduleModel currentSchedule = schedule.getScheduleByID(args.scheduleID);

    //this function checks if the employee works that day
    bool isWorking(TimeCard temp) {
      if (temp.shift.employeeID == 0) {
        return false;
      } else {
        return true;
      }
    }

    List<DateTime> scheduleDays = schedule.getScheduleDays(
        currentSchedule.startPeriod, currentSchedule.endPeriod);

    List<TimeCard> userTimeCard = schedule.createTimeCard(shift, scheduleDays,
        args.user.employeeID); // schedule == shift provider

    //formatting and styling
    return Scaffold(
      appBar: AppBar(
          title:
              Text("Timecard: ${args.user.firstName} ${args.user.lastName}")),
      body: Container(
        width: double.infinity,
        height: 900,
        child: Column(
          children: <Widget>[
            HourViewerAdmin(userTimeCard),
            //Text(userTimeCard[i].day.toString()),

            Container(
              height: 435,
              child: ListView.builder(
                  itemCount: userTimeCard.length,
                  itemBuilder: (ctx, i) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 1),
                      child: Container(
                          height: 150,
                          color: Colors.grey[400],
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15.0, left: 15),
                                child: Row(children: [
                                  Text(
                                    "Date: ${DateFormat.MMMd().format(userTimeCard[i].day)}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ]),
                              ),
                              isWorking(userTimeCard[i])
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10.0),
                                                  child: Text(
                                                      "Start Shift: ${userTimeCard[i].shift.startTime.hour.toString()}:${userTimeCard[i].shift.startTime.minute.toString()}"),
                                                ),
                                                Text(
                                                    "Start Lunch: ${userTimeCard[i].shift.startLunch.hour.toString()}:${userTimeCard[i].shift.startLunch.minute.toString()}"),
                                              ]),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10.0),
                                                  child: Text(
                                                      "End Shift: ${userTimeCard[i].shift.endTime.hour.toString()}:${userTimeCard[i].shift.endTime.minute.toString()}"),
                                                ),
                                                Text(
                                                    "End Lunch: ${userTimeCard[i].shift.endLunch.hour.toString()}:${userTimeCard[i].shift.endLunch.minute.toString()}"),
                                              ]),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                          "Regular: ${shift.timeCalculationsSingle(shift, args.user.employeeID, userTimeCard[i]).regTime}"),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                          "OT: ${shift.timeCalculationsSingle(shift, args.user.employeeID, userTimeCard[i]).overTime}"),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text("OT2:"),
                                                      Text(
                                                          "${shift.timeCalculationsSingle(shift, args.user.employeeID, userTimeCard[i]).doubleTime}"),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                          "Lunch: ${shift.timeCalculationsSingle(shift, args.user.employeeID, userTimeCard[i]).lunchTime}"),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                        ])
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: Center(
                                          child: Text("OFF",
                                              style: TextStyle(fontSize: 20))),
                                    ),
                              isWorking(userTimeCard[i])
                                  ? Row(children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 24.0),
                                            child: Text(
                                                "Position: ${userTimeCard[i].shift.position}"),
                                          ),
                                        ],
                                      ),
                                    ])
                                  : Container(),
                            ],
                          )),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
