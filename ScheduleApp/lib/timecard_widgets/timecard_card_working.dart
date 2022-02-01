import 'package:ScheduleApp/forms/timecard_form.dart';
import 'package:ScheduleApp/providers/schedules.dart';
import 'package:provider/provider.dart';
import '../providers/shifts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

//shows how many hours you worked and at what time
class TimeCardWorking extends StatelessWidget {
  final TimeCard userTimeCard;

  TimeCardWorking(this.userTimeCard);

  @override
  Widget build(BuildContext context) {
    var shift = Provider.of<Shifts>(context);
    double minute = shift.hoursWorked(
        userTimeCard.shift.startTime, userTimeCard.shift.endTime);
    int formattedHour = shift
        .hoursWorked(userTimeCard.shift.startTime, userTimeCard.shift.endTime)
        .toInt();
    int formattedMinute = ((minute - formattedHour) * 100).toInt();
    if (formattedMinute == 50) {
      formattedMinute = 30;
    } else if (formattedMinute == 75) {
      formattedMinute = 45;
    } else if (formattedMinute == 25) {
      formattedMinute = 15;
    }

    //formatting and styling
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          height: 50,
          child: Row(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 20, bottom: 12),
                        child: Text(
                            "${DateFormat.MMM().format(userTimeCard.day)} ${DateFormat.Md().format(userTimeCard.day)}",
                            style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("${formattedHour}h ${formattedMinute}m",
                      style: TextStyle(fontSize: 20)),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 13.0, left: 10),
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pushNamed(TimecardForm.routeName,
                          arguments: userTimeCard);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(height: 2, color: Colors.white),
      ],
    );
  }
}
