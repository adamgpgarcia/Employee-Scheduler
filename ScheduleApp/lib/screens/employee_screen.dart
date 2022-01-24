import 'package:ScheduleApp/employee_widgets/employee_tile.dart';
import 'package:ScheduleApp/providers/auth.dart';
import 'package:flutter/material.dart';
import '../providers/employees.dart';
import 'package:provider/provider.dart';
import '../employee_widgets/employee_form.dart';

class EmployeeScreen extends StatefulWidget {
  static const routeName = '/employee';

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    var token = Provider.of<Auth>(context, listen: false).token;
    var employee = Provider.of<Employees>(context);
    var employeeList = Provider.of<Employees>(context).items;
    var employeeCount = employee.employeeCount;
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Record"),
      ),
      body: Column(children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Container(
                  height: 50,
                  child: Text("Employees count: $employeeCount",
                      style: TextStyle(fontSize: 20))),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(EmployeeForm.routeName);
                  },
                  child: Text("New Employee")),
            ),
          ],
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            child: ListView.builder(
              itemCount: employeeCount,
              itemBuilder: (ctx, i) {
                return EmployeeTile(employeeList[i]);
              },
            ),
          ),
        )
      ]),
    );
  }
}
