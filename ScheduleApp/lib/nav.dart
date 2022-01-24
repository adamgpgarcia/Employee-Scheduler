import 'package:flutter/material.dart';
//import './providers/schedules.dart';
import './screens/account_screen.dart';
import './screens/dashboard_screen.dart';
//import 'package:intl/intl.dart';
//import 'package:date_util/date_util.dart';
import './screens/schedule_screen.dart';
import './screens/messaging_screen.dart';
import './screens/timecard_screen.dart';
import './screens/timecard_overview_screen.dart';
//import 'package:provider/provider.dart';

class Nav extends StatefulWidget {
  final int userID;

  Nav(this.userID);

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 2;

  // void _deleteTransaction(String id){
  //     setState(() {
  //       _userTransactions.removeWhere((tx) {
  //         return tx.id == id;
  //       });
  //     });
  // }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      TimeCardScreen(),
      ScheduleScreen(),
      DashboardScreen(),
      MessagingScreen(), //employeeList,currentUser, _addNewMessage),
      AccountScreen(),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment_turned_in,
            ),
            title: Text(
              'Timecard',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.schedule,
            ),
            title: Text(
              'Schedule',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard_rounded,
            ),
            title: Text(
              'Dashboard',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_rounded,
            ),
            title: Text(
              'WorkChat',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            title: Text(
              'Account',
            ),
          ),
        ],
        unselectedItemColor: Colors.teal[900],
        selectedItemColor: Colors.teal[500],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}
