import 'package:ScheduleApp/providers/employees.dart';
import 'package:ScheduleApp/providers/shifts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

//schedule class definition
class ScheduleModel {
  int scheduleID;
  int companyID;
  DateTime startPeriod;
  DateTime endPeriod;
  DateTime timecardDue;

  ScheduleModel({
    @required this.scheduleID,
    @required this.companyID,
    @required this.startPeriod,
    @required this.endPeriod,
    @required this.timecardDue,
  });
}

//timecard class definition
class TimeCard {
  DateTime day;
  ShiftModel shift;

  TimeCard({
    @required this.day,
    @required this.shift,
  });
}

//timecard record class definiton
class TimecardRecord {
  int scheduleID;
  bool submitted;
  EmployeeAccount user;
  List<ShiftModel> shiftList;

  TimecardRecord({
    @required this.scheduleID,
    @required this.submitted,
    @required this.user,
    @required this.shiftList,
  });
}

//timecard calculations class definition
class TimecardCalculations {
  int employeeID;
  double regTime;
  double overTime;
  double doubleTime;
  double lunchTime;

  TimecardCalculations({
    @required this.employeeID,
    @required this.regTime,
    @required this.overTime,
    @required this.doubleTime,
    @required this.lunchTime,
  });
}

//schedule provider
class Schedules with ChangeNotifier {
  List<ScheduleModel> _scheduleList = [];

  //returns list of schedules
  List<ScheduleModel> get items {
    return [..._scheduleList]; // ... is the spread operator
  }

  //returns schedule by id
  ScheduleModel getScheduleByID(int id) {
    for (var item in _scheduleList) {
      if (item.scheduleID == id) {
        return item;
      }
    }
    return null;
  }

  //gets the list of schedules from the database
  Future<void> getSchedule(String token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "token $token",
    };
    const url = 'http://35.233.225.216:8000/schedule/';
    try {
      final response = await http.get(url, headers: headers);
      final loadedData = json.decode(response.body) as List<dynamic>;
      final List<ScheduleModel> scheduleList = [];

      for (int i = 0; i < loadedData.length; i++) {
        var temp = ScheduleModel(
          scheduleID: loadedData[i]['scheduleID'],
          companyID: loadedData[i]['companyID'],
          startPeriod: DateTime.parse("${loadedData[i]['startPeriod']}"),
          endPeriod: DateTime.parse("${loadedData[i]['endPeriod']}"),
          timecardDue: DateTime.parse("${loadedData[i]['timecardDue']}"),
        );
        scheduleList.add(temp);
      }

      _scheduleList = scheduleList;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  //updates a schedule in the database
  Future<void> updateSchedule(
      ScheduleModel schedule, int id, String token) async {
    var headers = {
      'Authorization': "token $token",
      'Content-Type': 'application/json'
    };

    final scheduleIndex =
        _scheduleList.indexWhere((item) => item.scheduleID == id);

    try {
      final url = 'http://35.233.225.216:8000/schedule/$id/';
      await http.put(url,
          headers: headers,
          body: json.encode({
            'scheduleID': schedule.scheduleID,
            'companyID': schedule.companyID,
            'startPeriod':
                "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(schedule.startPeriod)}Z",
            'endPeriod':
                "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(schedule.endPeriod)}Z",
            'timecardDue':
                "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(schedule.timecardDue)}Z",
          }));

      _scheduleList[scheduleIndex] = schedule;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  //deletes a schedule from the database
  Future<void> deleteSchedule(
      ScheduleModel schedule, int id, String token) async {
    var headers = {
      'Authorization': "token $token",
      'Content-Type': 'application/json'
    };

    final scheduleIndex =
        _scheduleList.indexWhere((item) => item.scheduleID == id);

    try {
      final url = 'http://35.233.225.216:8000/schedule/$id/';
      await http.delete(url, headers: headers);

      _scheduleList.removeAt(scheduleIndex);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  //checks if dates are on the same day
  bool sameDay(DateTime first, DateTime second) {
    if ((int.parse(DateFormat.d().format(first)) ==
            int.parse(DateFormat.d().format(second))) &&
        (int.parse(DateFormat.M().format(first)) ==
            int.parse(DateFormat.M().format(second)))) {
      return true;
    }
    return false;
  }

  //returns current schedule based on date
  ScheduleModel getCurrentSchedule() {
    DateTime now = DateTime.now();
    ScheduleModel temp;
    for (var schedule in _scheduleList) {
      if (schedule.startPeriod.isBefore(now) &&
          schedule.endPeriod.isAfter(now)) {
        temp = schedule;
      }
    }
    return temp;
  }

  //creates timecard
  List<TimeCard> createTimeCard(
      var shift, List<DateTime> schedule, int userID) {
    List<TimeCard> tempTimeCard = [];
    for (int i = 0; i < schedule.length; i++) {
      ShiftModel temp = shift.getShiftOnDay(schedule[i], userID);
      tempTimeCard.add(TimeCard(day: schedule[i], shift: temp));
    }
    return tempTimeCard;
  }

  //gets dates for each day in the schedule
  List<DateTime> getScheduleDays(DateTime start, DateTime end) {
    List<DateTime> scheduleDays = [];
    Duration difference = end.difference(start);
    int days = (difference.inDays);

    for (int i = 0; i <= days; i++) {
      DateTime newDate = start.add(Duration(days: i));
      scheduleDays.add(newDate);
    }
    return scheduleDays;
  }

  //gets the duedate of timecard from current schedule
  DateTime getDueDate(int scheduleID) {
    for (var item in _scheduleList) {
      if (item.scheduleID == scheduleID) {
        return item.timecardDue;
      }
    }
  }

  //creates schedule in the database
  Future<void> setSchedule(ScheduleModel schedule, String token) async {
    var headers = {
      'Authorization': "token $token",
      'Content-Type': 'application/json'
    };

    const url = 'http://35.233.225.216:8000/schedule/';
    return http
        .post(
      url,
      headers: headers,
      body: json.encode({
        'scheduleID': schedule.scheduleID,
        'companyID': schedule.companyID,
        'startPeriod':
            "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(schedule.startPeriod)}Z",
        'endPeriod':
            "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(schedule.endPeriod)}Z",
        'timecardDue':
            "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(schedule.timecardDue)}Z",
      }),
    )
        .then((response) {
      //print(json.decode(response.body));
      final newSchedule = ScheduleModel(
        scheduleID: json.decode(response.body)['scheduleID'],
        companyID: schedule.companyID,
        startPeriod: schedule.startPeriod,
        endPeriod: schedule.endPeriod,
        timecardDue: schedule.timecardDue,
      );
      _scheduleList.add(newSchedule);
      notifyListeners();
    }).catchError((onError) {
      throw onError;
    });
  }
}
