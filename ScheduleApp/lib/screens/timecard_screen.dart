import '../providers/schedules.dart';
import '../providers/shifts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/auth.dart';
import 'package:intl/intl.dart';
import '../timecard_widgets/hour_viewer.dart';
import '../timecard_widgets/timecard_card_off.dart';
import '../timecard_widgets/timecard_card_working.dart';

//this widget shows a detailed breakdown of current timecard and allows the user to submit timecard
class TimeCardScreen extends StatefulWidget {
  static const routeName = '/timecard-screen';

  @override
  _TimeCardScreenState createState() => _TimeCardScreenState();
}

//ShiftModel getShiftOnDay(DateTime day, int userID)

class _TimeCardScreenState extends State<TimeCardScreen> {
  var isInIt = true;

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context, listen: false);

    if (isInIt) {
      setState(() {
        isLoading = true;
      });
      print("before");
      Provider.of<Schedules>(context).getSchedule(auth.token).then((_) {
        setState(() {
          print("yes");
          isLoading = false;
          isInIt = false;
        });
      });
    }

    var schedule = Provider.of<Shifts>(context, listen: false);
    var schedules = Provider.of<Schedules>(context, listen: false);
    String startPeriod;
    DateTime offsetEndPeriod;
    String endPeriod;
    String timecardDue;
    Duration difference;
    int timePeriod;
    //List<TimecardModel> timecardObjects = []; This functionality was not added

    List<ShiftModel> userShifts =
        Provider.of<Shifts>(context).getUserShifts(auth.user);
    ScheduleModel currentSchedule =
        Provider.of<Schedules>(context, listen: false).getCurrentSchedule();

    List<DateTime> scheduleDays = schedules.getScheduleDays(
        currentSchedule.startPeriod, currentSchedule.endPeriod);

    List<TimeCard> userTimeCard = schedules.createTimeCard(
        schedule, scheduleDays, auth.user); // schedule == shift provider

    //checks if employee is working
    bool areYouWorking(userTimeCard) {
      if (userTimeCard.shift.employeeID == 0) {
        return false;
      }
      return true;
    }

    //checks if timecard is submitted
    bool timeCardSubmitted() {
      for (int i = 0; i < userShifts.length; i++) {
        if (userShifts[i].confirmed == true) {
          return true;
        }
      }
      return false;
    }

    //formatting and styling
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
              "${DateFormat.MMMd().format(currentSchedule.startPeriod)} - ${DateFormat.MMMd().format(currentSchedule.endPeriod)}"),
          actions: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 14),
              child: timeCardSubmitted()
                  ? RaisedButton(
                      color: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.teal[900])),
                      onPressed: () {},
                      child: Text(
                        "Submited",
                        style: TextStyle(color: Colors.teal[900]),
                      ))
                  : RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.teal[900])),
                      onPressed: () {
                        return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('All correct?'),
                            content: Text(
                                'Submission is final'), //${employees.getName(currentChats[i].chatID)}
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                              FlatButton(
                                child: Text('Submit'),
                                onPressed: () {
                                  schedule.toggleSubmitTimeCard(
                                      userTimeCard, auth.token);
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.teal[900]),
                      )),
            ),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.teal[900],
                child: Column(
                  children: <Widget>[
                    HourViewer(currentSchedule.timecardDue, userTimeCard),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: ListView.builder(
                          itemBuilder: (ctx, index) {
                            return areYouWorking(userTimeCard[index])
                                ? TimeCardWorking(userTimeCard[index])
                                : TimeCardOff(userTimeCard[index]);
                          },
                          itemCount: userTimeCard.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
