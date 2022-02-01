import '../dashboard_widgets/user_dashboard.dart';
import '../dashboard_widgets/admin_dashboard.dart';
import 'package:flutter/material.dart';
import '../providers/employees.dart';
import '../providers/timeslot.dart';
import '../providers/auth.dart';
import '../providers/shifts.dart';
import 'package:provider/provider.dart';

//employee dashboard screen which shows a loading indicator
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isInIt = true;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context, listen: false);
    Provider.of<TimeSlots>(context, listen: false).getTimeSlots(auth.token);

    print(isInIt);
    if (isInIt) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Employees>(context, listen: false)
          .getEmployees(auth.token)
          .then((_) {
        setState(() {
          isLoading = false;
          isInIt = false;
        });
      });
    }

    var employee = Provider.of<Employees>(context, listen: false);

    Provider.of<Shifts>(context, listen: false).getShifts(auth.token);

    //formatting and style
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 125,
                  color: Colors.teal[900],
                  child: Text(
                    "Hello ${employee.getName(auth.user)}",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: employee.isAdmin(auth.user)
                      ? AdminDashboard()
                      : UserDashboard(),
                ),
              ],
            ),
    );
  }
}
