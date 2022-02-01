import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../providers/schedules.dart';
import 'package:date_util/date_util.dart';
import './schedules.dart';
import './employees.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//shift class definition
class ShiftModel {
  int shiftID;
  int scheduleID;
  int employeeID;
  DateTime startTime;
  DateTime endTime;
  DateTime startLunch;
  DateTime endLunch;
  String position;
  bool release;
  bool confirmed;

  ShiftModel({
    @required this.shiftID,
    @required this.scheduleID,
    @required this.employeeID,
    @required this.startTime,
    @required this.endTime,
    @required this.startLunch,
    @required this.endLunch,
    @required this.position,
    @required this.release,
    @required this.confirmed,
  });
}

//shift provider
class Shifts with ChangeNotifier {
  List<ShiftModel> _shiftList = [];

  int _currentUser;

  int setCurrentUser(int id) {
    _currentUser = id;
    print(_currentUser);
  }

  int get currentUser {
    return _currentUser;
  }

  //checks if current day is in the list of schedules
  bool isInList(
      List<ShiftModel> currentUserSchedule, DateTime date, int index) {
    bool isIn = false;
    int tempDay = int.parse(DateFormat.d().format(date));
    int tempMonth = int.parse(DateFormat.M().format(date));

    for (int i = index; i < currentUserSchedule.length; i++) {
      print('isinList: $i');
      int curDay =
          int.parse(DateFormat.d().format(currentUserSchedule[i].startTime));
      int curMonth =
          int.parse(DateFormat.M().format(currentUserSchedule[i].startTime));
      if (tempDay == curDay && tempMonth == curMonth) {
        isIn = true;
      }
    }
    return isIn;
  }

  //changes status of time card submission
  bool timeCardSubmitted(List<ShiftModel> userShifts) {
    for (int i = 0; i < userShifts.length; i++) {
      if (userShifts[i].confirmed == true) {
        return true;
      }
    }
    return false;
  }

  //checks if shift is submitted
  bool isSubmitted(ShiftModel temp) {
    if (temp.confirmed == true) {
      return true;
    } else {
      return false;
    }
  }

  //this function calculates timecard hours
  TimecardCalculations timeCalculations(
      var shift, int employeeID, List<TimeCard> userTimeCard) {
    double totalReg = 0;
    double tempHolder = 0;
    double totalOT = 0;
    double totalDT = 0;
    double lunchTime = 0;

    for (var item in userTimeCard) {
      if (item.shift.employeeID != 0) {
        tempHolder =
            shift.hoursWorked(item.shift.startTime, item.shift.endTime);
        lunchTime +=
            shift.hoursWorked(item.shift.startLunch, item.shift.endLunch);
        if (tempHolder > 12) {
          totalDT += tempHolder - 12;
          totalOT += 4;
          totalReg += 8;
          tempHolder = 0;
        } else if (tempHolder > 8) {
          totalOT += tempHolder - 8;
          totalReg += 8;
          tempHolder = 0;
        } else {
          totalReg += tempHolder;
          tempHolder = 0;
        }
      }
    }
    if (totalReg > 80) {
      double temp = totalReg - 80;
      totalReg = 80;
      totalOT += temp;
    }
    return TimecardCalculations(
        employeeID: employeeID,
        regTime: totalReg,
        overTime: totalOT,
        doubleTime: totalDT,
        lunchTime: lunchTime);
  }

  //this function calculates timecard hours
  TimecardCalculations timeCalculationsAdmin(
      var shift, int employeeID, List<TimeCard> userTimeCard) {
    double totalReg = 0;
    double tempHolder = 0;
    double totalOT = 0;
    double totalDT = 0;
    double lunchTime = 0;

    for (var item in userTimeCard) {
      tempHolder = shift.hoursWorked(item.shift.startTime, item.shift.endTime);
      lunchTime +=
          shift.hoursWorked(item.shift.startLunch, item.shift.endLunch);
      if (tempHolder > 12) {
        totalDT += tempHolder - 12;
        totalOT += 4;
        totalReg += 8;
        tempHolder = 0;
      } else if (tempHolder > 8) {
        totalOT += tempHolder - 8;
        totalReg += 8;
        tempHolder = 0;
      } else {
        totalReg += tempHolder;
        tempHolder = 0;
      }
    }
    if (totalReg > 80) {
      double temp = totalReg - 80;
      totalReg = 80;
      totalOT += temp;
    }
    return TimecardCalculations(
        employeeID: employeeID,
        regTime: totalReg,
        overTime: totalOT,
        doubleTime: totalDT,
        lunchTime: lunchTime);
  }

  //this function calculates timecard hours
  TimecardCalculations timeCalculationsSingle(
      var shift, int employeeID, TimeCard item) {
    double totalReg = 0;
    double tempHolder = 0;
    double totalOT = 0;
    double totalDT = 0;
    double lunchTime = 0;

    tempHolder = shift.hoursWorked(item.shift.startTime, item.shift.endTime);
    lunchTime += shift.hoursWorked(item.shift.startLunch, item.shift.endLunch);
    if (tempHolder > 12) {
      totalDT += tempHolder - 12;
      totalOT += 4;
      totalReg += 8;
      tempHolder = 0;
    } else if (tempHolder > 8) {
      totalOT += tempHolder - 8;
      totalReg += 8;
      tempHolder = 0;
    } else {
      totalReg += tempHolder;
      tempHolder = 0;
    }

    return TimecardCalculations(
        employeeID: employeeID,
        regTime: totalReg,
        overTime: totalOT,
        doubleTime: totalDT,
        lunchTime: lunchTime);
  }

  //not sure, but it compiles a list of shifts based on user id and adds a timecardrecord object to the end of the list
  List<TimecardRecord> getRecords(
      int scheduleID, List<EmployeeAccount> employees) {
    List<TimecardRecord> master = [];
    List<ShiftModel> temp = [];

    for (var employee in employees) {
      for (var shift in _shiftList) {
        if (employee.employeeID == shift.employeeID) {
          temp.add(shift);
        }
      }
      master.add(TimecardRecord(
          scheduleID: scheduleID,
          submitted: timeCardSubmitted(temp),
          user: employee,
          shiftList: temp));
      temp.clear();
    }
    return master;
  }

  //returns number of shifts on schedule
  int countShiftsOnSchedule(int day) {
    List tempShifts = [];
    tempShifts =
        _shiftList.where((element) => (element.scheduleID == day)).toList();

    if (tempShifts == null) {
      return 0;
    } else {
      return tempShifts.length;
    }
  }

  //returns number of shifts on day
  int countShiftsOnDay(DateTime day) {
    var formattedDay = DateFormat.yMMMd().format(day);
    List<ShiftModel> tempShifts = [];
    tempShifts = _shiftList
        .where((element) =>
            (DateFormat.yMMMd().format(element.startTime) == formattedDay ||
                DateFormat.yMMMd().format(element.endTime) == formattedDay))
        .toList();

    if (tempShifts == null) {
      return 0;
    } else {
      return tempShifts.length;
    }
  }

  //returns number of shifts on day repeat of function above
  int shiftOnDay(DateTime day) {
    var formattedDay = DateFormat.yMMMd().format(day);
    List<ShiftModel> tempShifts = [];
    tempShifts = _shiftList
        .where((element) =>
            (DateFormat.yMMMd().format(element.startTime) == formattedDay ||
                DateFormat.yMMMd().format(element.endTime) == formattedDay))
        .toList();

    if (tempShifts == null) {
      return 0;
    } else {
      return tempShifts.length;
    }
  }

  //returns a shift if your working today
  ShiftModel shiftToday(DateTime day, int userID) {
    ShiftModel dummy;
    List<ShiftModel> temp;
    String formattedDay = DateFormat.yMMMd().format(day).toString();
    for (int i = 0; i < _shiftList.length; i++) {
      if (_shiftList[i].employeeID == userID &&
          (DateFormat.yMMMd().format(_shiftList[i].startTime) == formattedDay ||
              DateFormat.yMMMd().format(_shiftList[i].endTime) ==
                  formattedDay)) {
        return _shiftList[i];
      }
    }
    return dummy;
  }

  //forsending only current users schedules to timecards
  List<ShiftModel> get releasedSchedule {
    return _shiftList.where((tx) {
      return tx.release == true;
    }).toList();
  }

  //returns a list of shifts
  List<ShiftModel> get items {
    return [..._shiftList]; // ... is the spread operator
  }

  //returns a list of shifts which match a user id
  List<ShiftModel> getUserShifts(int userID) {
    return _shiftList.where((tx) {
      return tx.employeeID == userID;
    }).toList();
  }

  //returns shifts on a day
  List<ShiftModel> getShiftsOnDay(DateTime day) {
    var formattedDay = DateFormat.yMMMd().format(day);
    List<ShiftModel> tempShifts = [];
    tempShifts = _shiftList
        .where((element) =>
            (DateFormat.yMMMd().format(element.startTime) == formattedDay ||
                DateFormat.yMMMd().format(element.endTime) == formattedDay))
        .toList();

    return tempShifts;
  }

  //returns shift on a day with user id
  ShiftModel getShiftOnDay(DateTime day, int userID) {
    List<ShiftModel> userShiftList = [];
    userShiftList = _shiftList.where((tx) => tx.employeeID == userID).toList();
    var formattedDay = DateFormat.yMMMd().format(day);
    ShiftModel tempShifts = ShiftModel(
      shiftID: 0,
      scheduleID: null,
      employeeID: 0,
      startTime: null,
      endTime: null,
      startLunch: null,
      endLunch: null,
      position: null,
      release: false,
      confirmed: false,
    );

    for (int i = 0; i < userShiftList.length; i++) {
      if (DateFormat.yMMMd().format(userShiftList[i].startTime) ==
              formattedDay ||
          DateFormat.yMMMd().format(userShiftList[i].endTime) == formattedDay) {
        tempShifts = userShiftList[i];
      }
    }
    return tempShifts;
  }

  //creates a list shifts that land on current week
  List<ShiftModel> weeksSchedules(
      currentUserSchedule, listOfDates, curMonth, filter) {
    if (filter == 0) {
      List<ShiftModel> masterSchedule = _shiftList;
      List<ShiftModel> weeksSchedules = [];
      List<int> currentDates = listOfDates;

      for (int i = 0; i < currentDates.length; i++) {
        for (int j = 0; j < masterSchedule.length; j++) {
          if (currentDates[i] ==
                  int.parse(
                      DateFormat.d().format(masterSchedule[j].startTime)) &&
              curMonth ==
                  int.parse(
                      DateFormat.M().format(masterSchedule[j].startTime))) {
            weeksSchedules.add(masterSchedule[j]);
          }
        }
      }
      return weeksSchedules;
    } else if (filter == 1) {
      List<ShiftModel> masterSchedule = currentUserSchedule;
      List<ShiftModel> weeksSchedules = [];
      List<int> currentDates = listOfDates;

      for (int i = 0; i < currentDates.length; i++) {
        for (int j = 0; j < masterSchedule.length; j++) {
          if (currentDates[i] ==
                  int.parse(
                      DateFormat.d().format(masterSchedule[j].startTime)) &&
              curMonth ==
                  int.parse(
                      DateFormat.M().format(masterSchedule[j].startTime))) {
            weeksSchedules.add(masterSchedule[j]);
          }
        }
      }
      return weeksSchedules;
    } else {
      List<ShiftModel> masterSchedule = releasedSchedule;
      List<ShiftModel> weeksSchedules = [];
      List<int> currentDates = listOfDates;

      for (int i = 0; i < currentDates.length; i++) {
        for (int j = 0; j < masterSchedule.length; j++) {
          if (currentDates[i] ==
                  int.parse(
                      DateFormat.d().format(masterSchedule[j].startTime)) &&
              curMonth ==
                  int.parse(
                      DateFormat.M().format(masterSchedule[j].startTime))) {
            weeksSchedules.add(masterSchedule[j]);
          }
        }
      }
      return weeksSchedules;
    }
  }

  //gets shifts from database
  Future<void> getShifts(String token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "token $token",
    };
    const url = 'http://35.233.225.216:8000/shift/';
    try {
      final response = await http.get(url, headers: headers);
      final loadedData = json.decode(response.body) as List<dynamic>;
      final List<ShiftModel> shiftList = [];

      for (int i = 0; i < loadedData.length; i++) {
        var temp = ShiftModel(
          shiftID: loadedData[i]['shiftID'],
          scheduleID: loadedData[i]['scheduleID'],
          employeeID: loadedData[i]['employeeID'],
          startTime: DateTime.parse("${loadedData[i]['startTime']}"),
          endTime: DateTime.parse("${loadedData[i]['endTime']}"),
          startLunch: DateTime.parse("${loadedData[i]['startLunch']}"),
          endLunch: DateTime.parse("${loadedData[i]['endLunch']}"),
          position: loadedData[i]['position'],
          release: loadedData[i]['release'],
          confirmed: loadedData[i]['confirmed'],
        );
        shiftList.add(temp);
      }

      _shiftList = shiftList;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  //deletes shifts from database
  Future<void> deleteShift(ShiftModel shift, int id, String token) async {
    var headers = {
      'Authorization': "token $token",
      'Content-Type': 'application/json'
    };

    final shiftIndex = _shiftList.indexWhere((item) => item.shiftID == id);

    try {
      final url = 'http://35.233.225.216:8000/shift/$id/';
      await http.delete(url, headers: headers);

      _shiftList.removeAt(shiftIndex);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  //submits timecard
  void toggleSubmitTimeCard(List<TimeCard> userTimeCard, String token) {
    for (var items in userTimeCard) {
      if (items.shift.employeeID != 0) {
        items.shift.confirmed = !items.shift.confirmed;
        updateShift(items.shift, items.shift.shiftID, token);
      }
    }
  }

  //updates shift from database
  Future<void> updateShift(ShiftModel shift, int id, String token) async {
    var headers = {
      'Authorization': "token $token",
      'Content-Type': 'application/json'
    };

    final shiftIndex = _shiftList.indexWhere((item) => item.shiftID == id);

    try {
      final url = 'http://35.233.225.216:8000/shift/$id/';
      await http.put(url,
          headers: headers,
          body: json.encode({
            'scheduleID': shift.scheduleID,
            'employeeID': shift.employeeID,
            'startTime':
                "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(shift.startTime)}Z",
            'endTime':
                "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(shift.endTime)}Z",
            'startLunch':
                "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(shift.startLunch)}Z",
            'endLunch':
                "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(shift.endLunch)}Z",
            'position': shift.position,
            'release': shift.release,
            'confirmed': shift.confirmed,
          }));

      _shiftList[shiftIndex] = shift;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  //creates a shift in the database
  Future<void> setShift(ShiftModel shift, String token) async {
    var headers = {
      'Authorization': "token $token",
      'Content-Type': 'application/json'
    };

    const url = 'http://35.233.225.216:8000/shift/';
    return http
        .post(
      url,
      headers: headers,
      body: json.encode({
        'shiftID': shift.shiftID,
        'scheduleID': shift.scheduleID,
        'employeeID': shift.employeeID,
        'startTime':
            "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(shift.startTime)}Z",
        'endTime':
            "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(shift.endTime)}Z",
        'startLunch':
            "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(shift.startLunch)}Z",
        'endLunch':
            "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(shift.endLunch)}Z",
        'position': shift.position,
        'release': shift.release,
        'confirmed': shift.confirmed,
      }),
    )
        .then((response) {
      print(json.decode(response.body));
      final newShift = ShiftModel(
        shiftID: json.decode(response.body)['shiftID'],
        scheduleID: shift.scheduleID,
        employeeID: shift.employeeID,
        startTime: shift.startTime,
        endTime: shift.endTime,
        startLunch: shift.startLunch,
        endLunch: shift.endLunch,
        position: shift.position,
        release: shift.release,
        confirmed: shift.confirmed,
      );
      _shiftList.add(newShift);
      //_items.insert(0, newProduct); //insert at the begining of the list
      notifyListeners();
    }).catchError((onError) {
      throw onError;
    });
  }

  //this function creates a list of the dates for the week
  List<int> get currentWeekList {
    //Variables and values needed for week function
    List<int> currentWeek = [];
    int curMonth = int.parse(DateFormat.M().format(DateTime.now()));
    int curYear = int.parse(DateFormat.y().format(DateTime.now()));
    int dayNumber = int.parse(DateFormat.d().format(DateTime.now()));
    int daysMonth = DateUtil().daysInMonth(curMonth, curYear);
    int daysPrevMonth = DateUtil().daysInMonth(curMonth - 1, curYear);
    String dayAbr = DateFormat.E().format(DateTime.now());
    final List weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    int index;

    //compairs abbr of week days to find out what day they are on to find the starting sunday of that week
    for (int j = 0; j < 7; j++) {
      if (weekdays[j] == dayAbr) {
        index = j;
      }
    }

    //checks if week goes into last month
    if (dayNumber - index < 1) {
      int daysIntoLastMonth = index - dayNumber;
      int startDayLastMonth = daysPrevMonth - daysIntoLastMonth;
      for (int i = startDayLastMonth; i <= daysPrevMonth; i++) {
        currentWeek.add(i);
      }
      for (int i = 1; currentWeek.length < 7; i++) {
        currentWeek.add(i);
      }
    }
    //checks if week sits in the middle of the month
    else if ((dayNumber - index) >= 1 && (dayNumber - index + 6) <= daysMonth) {
      int tempSunday = dayNumber - index;
      int tempLastDay = dayNumber - index + 6;

      for (int i = tempSunday; i <= tempLastDay; i++) {
        currentWeek.add(i);
      }
    }
    //checks if week passes end of current month
    else if ((dayNumber - index + 6) > daysMonth) {
      int tempSunday = dayNumber - index;

      for (int i = tempSunday; i <= daysMonth; i++) {
        currentWeek.add(i);
      }
      for (int i = 1; currentWeek.length < 7; i++) {
        currentWeek.add(i);
      }
    }
    return currentWeek;
  }

  //formats time
  int formattedHour(DateTime startTime, DateTime endTime) {
    return hoursWorked(startTime, endTime).toInt();
  }

  //formats minutes
  int formattedMinute(startTime, endTime) {
    double minute = hoursWorked(startTime, endTime);
    int formattedHour = hoursWorked(startTime, endTime).toInt();
    int formattedMinute = ((minute - formattedHour) * 100).toInt();
    if (formattedMinute == 50) {
      formattedMinute = 30;
    } else if (formattedMinute == 75) {
      formattedMinute = 45;
    } else if (formattedMinute == 25) {
      formattedMinute = 15;
    }
    return formattedMinute;
  }

  //rounds up by 15 min if needed
  double hoursWorked(startTime, endTime) {
    // double totalHours;

    Duration difference = (endTime).difference(startTime);

    int timePeriod = difference.inMinutes;

    double wholeHour = ((timePeriod / 60).floor()).toDouble();

    int minutes = timePeriod - ((60 * wholeHour).toInt());
    double payHour;

    if (minutes > 0 && minutes <= 15) {
      payHour = wholeHour.toDouble() + .25;
    } else if (minutes > 15 && minutes <= 30) {
      payHour = wholeHour.toDouble() + .50;
    } else if (minutes > 15 && minutes <= 45) {
      payHour = wholeHour.toDouble() + .75;
    } else if (minutes > 45) {
      payHour = wholeHour.toDouble() + 1.0;
    } else {
      payHour = wholeHour;
    }

    return payHour;
  }
}
