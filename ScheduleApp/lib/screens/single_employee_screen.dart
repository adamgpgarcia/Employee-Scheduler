import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/auth.dart';
import '../providers/employees.dart';
import '../employee_widgets/employee_form.dart';

class SingleEmployeeScreen extends StatefulWidget {

  static const routeName = '/single-employee';


  @override
  _SingleEmployeeScreenState createState() => _SingleEmployeeScreenState();
}

class _SingleEmployeeScreenState extends State<SingleEmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    final EmployeeAccount args = ModalRoute.of(context).settings.arguments;
    var employee = Provider.of<Employees>(context);
    var auth = Provider.of<Auth>(context,listen:false);
    
    return Scaffold(
        appBar: AppBar(title: Text('Employee: ${args.firstName} ${args.lastName}')),
        body: 
        Center(
          child: Container(width: 300, height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Text("First Name: ${args.firstName}", style: TextStyle(fontSize: 18)),
              Text("Last Name: ${args.lastName}", style: TextStyle(fontSize: 18)),
              Text("Username: ${args.username}", style: TextStyle(fontSize: 18)),
              Text("Hourly wage: ${args.hourlyWage}", style: TextStyle(fontSize: 18)),
              Text("Phone: ${args.phone}", style: TextStyle(fontSize: 18)),
              Text("Email: ${args.email}", style: TextStyle(fontSize: 18)),
              Text("Employee Type: ${args.employeeType}", style: TextStyle(fontSize: 18)),
              Text("Scheduled Hours: ${args.scheduledHours}", style: TextStyle(fontSize: 18)),
              Text("Staff: ${args.isStaff}", style: TextStyle(fontSize: 18)),
              Text("Supervisor: ${args.isSupervisor}", style: TextStyle(fontSize: 18)),
              Text("Admin: ${args.isAdmin}", style: TextStyle(fontSize: 18)),
              // Text("Status: ${args.isStaff}"),
              // Text("Supervisor: ${args.isSupervisor}"),
              // Text("Admin: ${args.isAdmin}"),
              // Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 150,
                    child: RaisedButton(
                      onPressed: () {
                        return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Are you sure?'),
                                    content: Text(
                                        'Deleting ${args.firstName} ${args.lastName} user profile is permanent.'),  //${employees.getName(currentChats[i].chatID)}
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Confirm'),
                                        onPressed: () {
                                          employee.deleteEmployee(args.dbID, auth.token);
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                      },
                      child: Text("Delete"),
                      color: Colors.red[500],
                    ),
                  ),

                  Container(
                    width: 150,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(EmployeeForm.routeName,
                                        arguments: args);
                      },
                      child: Text("Edit"),
                      color: Colors.blue[500],
                    ),
                  ),
                ],
              )

      
      
      ],
      ),
          ),
        ),
    );
  }
}

