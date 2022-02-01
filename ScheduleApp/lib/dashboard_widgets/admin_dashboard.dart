import '../providers/employees.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../admin_timecard/timecard_list.dart';
import '../screens/employee_screen.dart';

import '../screens/schedule_list.dart';

//this widget promts the admin with buttons that redirct to timecards, scheduling, and employees pages
class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var employee = Provider.of<Employees>(context);

    var auth = Provider.of<Auth>(context, listen: false);
    return Container(
      height: 420,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(2, 3))
                ]),
            width: 350,
            height: 100,
            child: RaisedButton(
              color: Colors.grey[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.teal[500])),
              onPressed: () {
                Navigator.of(context).pushNamed(TimecardList.routeName);
              },
              child: Text(
                "Timecards",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(2, 3))
                ]),
            width: 350,
            height: 100,
            child: RaisedButton(
              color: Colors.grey[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.teal[500])),
              onPressed: () {
                Navigator.of(context).pushNamed(ScheduleList.routeName);
              },
              child: Text(
                "Schedule",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(2, 3))
                ]),
            width: 350,
            height: 100,
            child: RaisedButton(
              color: Colors.grey[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.teal[500])),
              onPressed: () {
                Navigator.of(context).pushNamed(EmployeeScreen.routeName);
              },
              child: Text(
                "Employees",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
