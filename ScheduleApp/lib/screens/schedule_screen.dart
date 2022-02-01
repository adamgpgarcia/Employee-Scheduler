import '../schedule_widgets/schedule_card.dart';
import '../schedule_widgets/filter_buttons.dart';
import 'package:flutter/material.dart';
import '../providers/shifts.dart';
import '../providers/charts.dart';
import 'package:ScheduleApp/providers/shifts.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/schedules.dart';
import 'package:intl/intl.dart';
import 'package:date_util/date_util.dart';

//import './chart.dart';

//this widget shows a weekly glance at the current schedule with all the shifts per day for an employee to view
class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime today = DateTime.now();

  int start;
  int daysleft;

  //Variables for current week/increment/ decrement
  bool initStartDays = false;
  List<int> listOfDates;
  int direction = 0;
  int currentSunday;

  int currentSaturday;
  int curMonth = int.parse(DateFormat.M().format(DateTime.now()));
  int curYear = int.parse(DateFormat.y().format(DateTime.now()));

  //Increases the week range
  void increaseWeek() {
    List<int> currentWeek = [];
    int daysMonth = DateUtil().daysInMonth(curMonth, curYear);

    //checks if your increasing from an transition week
    if (currentSunday > currentSaturday) {
      //Creates new week from transition week
      for (int i = currentSaturday + 1; i < currentSaturday + 8; i++) {
        currentWeek.add(i);
      }

      //checks direction of the users input to correctly decrement into months
      if (direction == 0) {
        if (curMonth == 12) {
          curMonth = 1;
          curYear += 1;
        } else {
          curMonth += 1;
        }
        direction = 1;
      } else if (direction == 1) {
        if (curMonth == 12) {
          curMonth = 1;
          curYear += 1;
        } else {
          curMonth += 1;
        }
      } else if (direction == 2) {
        direction = 1;
      }
    }

    //checks if the last day of the month is Saturday
    else if (currentSaturday == daysMonth) {
      //Creates week starting on the first of the next month
      for (int i = 1; i < 8; i++) {
        currentWeek.add(i);
      }
      currentSaturday = currentWeek[6];
      currentSunday = currentWeek[0];

      //checks if increase goes into the next year
      if (curMonth == 12) {
        curMonth = 1;
        curYear += 1;
      } else {
        curMonth += 1;
      }
      direction = 1;
    }
    //checks if week increase is in month bounds
    else if ((currentSaturday + 7) <= daysMonth) {
      for (int i = currentSaturday + 1; i < currentSaturday + 8; i++) {
        currentWeek.add(i);
      }
      direction = 1;
    }
    //checks if week increase is out of month bounds
    else if ((currentSaturday + 7) > daysMonth) {
      for (int i = currentSaturday + 1; i <= daysMonth; i++) {
        currentWeek.add(i);
      }
      int temp = 7 - (currentWeek.length);

      for (int i = 1; i <= temp; i++) {
        currentWeek.add(i);
      }
      direction = 1;
    }
    setCurrentWeek(currentWeek);
  }

  //Decrease the week range
  void decreaseWeek() {
    int daysMonthPast;
    List<int> currentWeek = [];

    //checks if your decrementing into a previous year
    if (curMonth == 1) {
      daysMonthPast = DateUtil().daysInMonth(12, curYear - 1);
    } else {
      daysMonthPast = DateUtil().daysInMonth(curMonth - 1, curYear);
    }

    //checks if your decrementing from an transition week
    if (currentSunday > currentSaturday) {
      //Creates new week from transition week
      for (int i = currentSunday - 7; i < currentSunday; i++) {
        currentWeek.add(i);
      }

      //checks direction of the users input to correctly decrement into months
      if (direction == 0) {
        if (curMonth == 1) {
          curMonth = 12;
          curYear -= 1;
        } else {
          curMonth -= 1;
        }
        direction = 2;
      } else if (direction == 1) {
        direction = 2;
      } else if (direction == 2) {
        if (curMonth == 1) {
          curMonth = 12;
          curYear -= 1;
        } else {
          curMonth -= 1;
        }
      }
    }
    //checks if the first the month lands on Sunday
    else if (currentSunday == 1) {
      int temp = daysMonthPast - 6;

      //creates week previous
      for (int i = temp; i <= daysMonthPast; i++) {
        currentWeek.add(i);
      }

      //bounds checking if year needs to be changed
      if (curMonth == 1) {
        curMonth = 12;
        curYear -= 1;
      } else {
        curMonth -= 1;
      }
      direction = 2;
    }

    //checks if current week will remain in month after decrementing
    else if ((currentSunday - 7) >= 1) {
      for (int i = currentSunday - 7; i <= currentSunday - 1; i++) {
        currentWeek.add(i);
      }
      direction = 2;
    }

    //checks if decrementing week goes into previous month
    else if ((currentSunday - 7) < 1) {
      int temp = daysMonthPast - (6 - (currentSunday - 1));
      for (int i = temp; i <= daysMonthPast; i++) {
        currentWeek.add(i);
      }
      int tempRange = 7 - currentWeek.length;
      for (int i = 1; i <= tempRange; i++) {
        currentWeek.add(i);
      }
      direction = 2;
    }
    setCurrentWeek(currentWeek);
  }

  //sets inital sun, sat, listOfDates
  void setStartDays(currentWeekList) {
    setState(() {
      initStartDays = true;
      listOfDates = currentWeekList;
      currentSunday = currentWeekList[0];
      currentSaturday = currentWeekList[6];
    });
  }

  //sets week values from increase and decrease week
  void setCurrentWeek(dayList) {
    setState(() {
      listOfDates = dayList;
    });
    currentSaturday = listOfDates[6];
    currentSunday = listOfDates[0];
  }

  //Create Chart Objects
  List<ChartModel> getCharts(day1, date1, working1) {
    List<ChartModel> newObjects = [];

    for (int i = 0; i < working1.length; i++) {
      newObjects
          .add(ChartModel(day: day1[i], date: date1[i], working: working1[i]));
    }
    return newObjects;
  }

  //List of bool values of days you work (working)
  List<bool> daysWorking(dateWeek, currentUser, currentSchedule) {
    List<bool> working = List.filled(7, false);
    List<ShiftModel> shifts = yourShifts(currentUser, currentSchedule);

    for (int i = 0; i < dateWeek.length; i++) {
      for (int j = 0; j < shifts.length; j++) {
        if (dateWeek[i] ==
                int.parse(DateFormat.d().format(shifts[j].startTime)) &&
            curMonth == int.parse(DateFormat.M().format(shifts[j].startTime))) {
          working[i] = true;
        }
      }
    }
    return working;
  }

//////////////////////////////////////

// Filter buttons
  int filter = 1;

  void setFilter(int temp) {
    setState(() {
      filter = temp;
    });
  }

//gets only the schedules for the desired employee  (working)
  List<ShiftModel> yourShifts(currentUser, currentSchedule) {
    return currentSchedule.where((tx) {
      return tx.employeeID == currentUser;
    }).toList();
  }

//Schedules for current week period  (looks okay)

  @override
  Widget build(BuildContext context) {
    var schedule = Provider.of<Shifts>(context);
    var auth = Provider.of<Auth>(context);

    DateTime headerMY = new DateTime.utc(
        curYear, curMonth, int.parse(DateFormat.d().format(DateTime.now())));
    List<int> currentWeekList =
        Provider.of<Shifts>(context, listen: false).currentWeekList;

    if (initStartDays == false) {
      setStartDays(currentWeekList);
    }
    //int currentUser = Provider.of<Schedules>(context, listen: false).currentUser;
    List<ShiftModel> currentSchedule = Provider.of<Shifts>(context).items;

    List<bool> workingDays =
        daysWorking(listOfDates, auth.user, currentSchedule);
    List<String> weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    List<ChartModel> newObjects = getCharts(weekdays, listOfDates, workingDays);
    List<ShiftModel> userShifts =
        Provider.of<Shifts>(context, listen: false).getUserShifts(auth.user);

    List<ShiftModel> weekSchedule =
        schedule.weeksSchedules(userShifts, listOfDates, curMonth, filter);

    //formatting and styling
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text('${DateFormat.yMMMM().format(headerMY)}'),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.teal[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 40,
                  color: Colors.teal[900],
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        decreaseWeek();
                      });
                    },
                  ),
                ),
                FilterButtons(filter, setFilter),
                Container(
                  height: 40,
                  color: Colors.teal[900],
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        increaseWeek();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.teal[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: newObjects.map((ctx) {
                return Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        //ctx.day,
                        'cat', // fix this after running program
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    if (ctx.date ==
                            int.parse(DateFormat.d().format(DateTime.now())) &&
                        curMonth ==
                            int.parse(
                                DateFormat.M().format(DateTime.now()))) //if()
                      Container(
                        width: 50,
                        height: 50,
                        padding: EdgeInsets.all(5),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 25,
                          child: Text(ctx.date.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    if (ctx.date !=
                            int.parse(DateFormat.d().format(DateTime.now())) ||
                        curMonth !=
                            int.parse(DateFormat.M().format(DateTime.now())))
                      Container(
                        width: 50,
                        height: 50,
                        padding: EdgeInsets.all(5),
                        child: CircleAvatar(
                          backgroundColor: Colors.teal[900],
                          radius: 25,
                          child: Text(ctx.date.toString()),
                        ),
                      ),
                    if (ctx.working == true)
                      Container(
                        height: 2,
                        width: 35,
                        color: Colors.white,
                      ),
                    Container(
                      height: 5,
                      color: Colors.teal[900],
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Container(
              //height: 420,
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return ScheduleCard(weekSchedule, index, auth.user);
                },
                itemCount: weekSchedule.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
