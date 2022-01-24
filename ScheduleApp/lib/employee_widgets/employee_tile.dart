import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/single_employee_screen.dart';
import '../providers/employees.dart';
import './employee_form.dart';

class EmployeeTile extends StatelessWidget {
  final EmployeeAccount employeeAccount;
  EmployeeTile(this.employeeAccount);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15.0,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: <Widget>[
              Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 8, bottom: 8, right: 25),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[500],
                    child: Text(
                      "${employeeAccount.firstName[0]}${employeeAccount.lastName[0]}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]),
              Expanded(
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    Text(
                      "Name: ${employeeAccount.firstName} ${employeeAccount.lastName}",
                      style: TextStyle(fontSize: 18),
                    )
                  ]),
                  Row(
                    children: <Widget>[
                      Text("UserID: ${employeeAccount.employeeID}",
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ]),
              ),
              Column(children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        SingleEmployeeScreen.routeName,
                        arguments: employeeAccount);
                  },
                  child: Text("View"),
                  color: Colors.grey[400],
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}
