import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';

//timeslot class definition
class TimeSlotModel {
  int id;
  int employeeID;
  DateTime startTime;
  DateTime endTime;
  String currentDay;

  TimeSlotModel(
      {@required this.id,
      @required this.employeeID,
      @required this.startTime,
      @required this.endTime,
      @required this.currentDay});
}

//timeslot provider
class TimeSlots with ChangeNotifier {
  List<TimeSlotModel> _timeSlotList = [];

  //returns timeslot list
  List<TimeSlotModel> get items {
    return [..._timeSlotList]; // ... is the spread operator
  }

  //sorts list based on day
  List<TimeSlotModel> slotsByDay(String temp) {
    return _timeSlotList.where((element) {
      return (element.currentDay == temp);
    }).toList();
  }

  //sorts list
  List<TimeSlotModel> sortedTimeSlots(int userID, String day) {
    List<TimeSlotModel> userTimeSlots = _timeSlotList
        .where((element) =>
            (element.employeeID == userID && element.currentDay == day))
        .toList();

    userTimeSlots.sort((a, b) => a.startTime.compareTo(b.startTime));

    return userTimeSlots;
  }

  //counts time slots
  double countSlots(int userID, String day) {
    List<TimeSlotModel> userTimeSlots = _timeSlotList
        .where((element) =>
            (element.employeeID == userID && element.currentDay == day))
        .toList();
    double temp;
    if (userTimeSlots.length == 0) {
      temp = 1;
    } else {
      temp = userTimeSlots.length.toDouble();
    }
    return temp;
  }

  //gets timeslots from the database
  Future<void> getTimeSlots(String token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "token $token",
    };
    const url = 'http://35.233.225.216:8000/timeslot/';
    try {
      final response = await http.get(url, headers: headers);
      final loadedData = json.decode(response.body) as List<dynamic>;
      final List<TimeSlotModel> tempList = [];

      for (int i = 0; i < loadedData.length; i++) {
        var temp = TimeSlotModel(
          id: loadedData[i]['id'],
          employeeID: loadedData[i]['employeeID'],
          startTime: DateTime.parse("${loadedData[i]['startTime']}"),
          endTime: DateTime.parse("${loadedData[i]['endTime']}"),
          currentDay: loadedData[i]['day'],
        );
        tempList.add(temp);
      }

      _timeSlotList = tempList;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  //creates a timeslot in the database
  Future<void> setTimeSlot(TimeSlotModel slot, String token) async {
    var headers = {
      'Authorization': "token $token",
      'Content-Type': 'application/json'
    };

    const url = 'http://35.233.225.216:8000/timeslot/';
    return http
        .post(
      url,
      headers: headers,
      body: json.encode({
        'employeeID': slot.employeeID,
        'startTime':
            "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(slot.startTime)}Z",
        'endTime': "${DateFormat('yyyy-MM-ddTHH:mm:ss').format(slot.endTime)}Z",
        'day': slot.currentDay,
      }),
    )
        .then((response) {
      //print(json.decode(response.body));
      final newSlot = TimeSlotModel(
        id: json.decode(response.body)['id'],
        employeeID: slot.employeeID,
        startTime: slot.startTime,
        endTime: slot.endTime,
        currentDay: slot.currentDay,
      );
      _timeSlotList.add(newSlot);
      notifyListeners();
    }).catchError((onError) {
      throw onError;
    });
    //print(json.decode(response.body));
  }

  //deletes a time slot in the database
  Future<void> deleteTimeSlot(int id, String token) async {
    var headers = {
      'Authorization': "token $token",
      'Content-Type': 'application/json'
    };

    final index = _timeSlotList.indexWhere((item) => item.id == id);

    try {
      final url = 'http://35.233.225.216:8000/timeslot/$id/';
      await http.delete(url, headers: headers);

      _timeSlotList.removeAt(index);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
