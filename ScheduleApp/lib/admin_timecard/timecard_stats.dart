import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shifts.dart';
import '../providers/schedules.dart';
import 'package:intl/intl.dart';

//this widget shows stats on timecards for the current period to the admin user, not implemented
class TimecardStats extends StatelessWidget {
  final List<TimecardRecord> timecardRecords;
  final ScheduleModel currentSchedule;

  TimecardStats(this.currentSchedule, this.timecardRecords);

  int totalSubmitted = 0;
  int totalOutstanding = 0;
  double totalRegular = 0;
  double totalOT = 0;
  double totalOT2 = 0;
  int lunchViolatios = 0;

  //this function counts the submitted and outstanding timecards
  void submittedCheck(List<TimecardRecord> list) {
    for (var item in list) {
      if (item.submitted == true) {
        totalSubmitted += 1;
      } else {
        totalOutstanding += 1;
      }
    }
  }

  //this function adds up total reg, over, and double time from all employees that have submitted their time cards
  void totalTimes(var shift, List<TimecardRecord> timecardRecords) {
    List<TimeCard> temp = [];
    TimecardCalculations tempCalculations;

    for (int i = 0; i < timecardRecords.length; i++) {
      print(i);
      for (int j = 0; j < timecardRecords[i].shiftList.length; i++) {
        temp.add(TimeCard(
            day: timecardRecords[i].shiftList[j].startTime,
            shift: timecardRecords[i].shiftList[j]));
      }
      // for(int k = 0; k < temp.length; k++){
      tempCalculations = shift.timeCalculationsAdmin(
          shift, timecardRecords[i].user.employeeID, temp);
      //print(tempCalculations.regTime);
      //print(tempCalculations.overTime);
      //print(tempCalculations.doubleTime);

      totalRegular += tempCalculations.regTime;
      totalOT += tempCalculations.overTime;
      totalOT2 += tempCalculations.doubleTime;
      // }
      temp = [];
      tempCalculations = null;
    }
  }

  //formatting and styling
  @override
  Widget build(BuildContext context) {
    var schedule = Provider.of<Schedules>(context, listen: false);
    var shift = Provider.of<Shifts>(context, listen: false);

    submittedCheck(timecardRecords);

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        width: 380,
        height: 125,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        "${DateFormat.yMMMd().format(currentSchedule.startPeriod)} - ${DateFormat.yMMMd().format(currentSchedule.endPeriod)}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Timecard Due: ${DateFormat.yMMMd().format(schedule.getDueDate(currentSchedule.scheduleID))}"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Submitted Timecards: $totalSubmitted"),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Outstanding Timecards: $totalOutstanding"),
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
