import 'package:ScheduleApp/account_widgets/availibility_screen.dart';
import '../providers/employees.dart';
import 'package:flutter/material.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

bool toggleDropdown = false;

//user account screen where user can logout of app
class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    var employee = Provider.of<Employees>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Account Settings"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.grey[700],
            width: double.infinity,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Availability',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AvailibilityScreen.routeName);
                  },
                )
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text("Logined as: ${employee.getName(auth.user)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.amber,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.teal[500])),
              onPressed: () {
                auth.logout();
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
