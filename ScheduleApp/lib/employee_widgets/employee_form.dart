import 'package:ScheduleApp/providers/employees.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/auth.dart';
import '../providers/employees.dart';
import 'package:email_validator/email_validator.dart';

//this widget is a form to add new employees to the database
class EmployeeForm extends StatefulWidget {
  static const routeName = '/employee-form';

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _form = GlobalKey<FormState>();
  var _isInit = true;

  String password;
  int currentID;

  var _editiedEmployee = {
    'employeeID': '',
    'dbID': '',
    'username': '',
    'firstName': '',
    'lastName': '',
    'employeeType': '',
    'email': '',
    'phone': '',
    'hourlyWage': '',
    'scheduledHours': '',
    'isStaff': '',
    'isSupervisor': '',
    'isAdmin': '',
  };

  var _initValues = {
    'employeeID': '',
    'dbID': '',
    'username': '',
    'firstName': '',
    'lastName': '',
    'employeeType': '',
    'email': '',
    'phone': '',
    'hourlyWage': '',
    'scheduledHours': '',
    'isStaff': '',
    'isSupervisor': '',
    'isAdmin': '',
  };
  EmployeeAccount initEmployee;

  //this function stores the user input from the form
  @override
  void didChangeDependencies() {
    if (_isInit) {
      initEmployee = ModalRoute.of(context).settings.arguments;

      if (initEmployee != null) {
        _initValues = {
          'employeeID': initEmployee.employeeID.toString(),
          'dbID': initEmployee.dbID.toString(),
          'username': initEmployee.username,
          'firstName': initEmployee.firstName,
          'lastName': initEmployee.lastName,
          'employeeType': initEmployee.employeeType.toString(),
          'email': initEmployee.email,
          'phone': initEmployee.phone,
          'hourlyWage': initEmployee.hourlyWage.toString(),
          'scheduledHours': initEmployee.scheduledHours.toString(),
          'isStaff': initEmployee.isStaff.toString(),
          'isSupervisor': initEmployee.isSupervisor.toString(),
          'isAdmin': initEmployee.isAdmin.toString(),
        };
        _editiedEmployee = _initValues;

        print(_initValues['employeeID']);
        print(_editiedEmployee['employeeID']);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //this function saves and validates the form
  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    bool isBool(var temp) {
      if (temp == "true" || temp == "True") {
        return true;
      } else {
        return false;
      }
    }

    var auth = Provider.of<Auth>(context, listen: false);

    if (isNull(ModalRoute.of(context).settings.arguments)) {
      EmployeeAccount tempAccount = EmployeeAccount(
        dbID: null, //  int.parse(_editiedEmployee['dbID']),
        username: _editiedEmployee['username'],
        employeeID: int.parse(_editiedEmployee['employeeID']),
        firstName: _editiedEmployee['firstName'],
        lastName: _editiedEmployee['lastName'],
        employeeType: int.parse(_editiedEmployee['employeeType']),
        email: _editiedEmployee['email'],
        phone: _editiedEmployee['phone'],
        hourlyWage: double.parse(_editiedEmployee['hourlyWage']),
        scheduledHours: int.parse(_editiedEmployee['scheduledHours']),
        isStaff: isBool(_editiedEmployee['isStaff']),
        isSupervisor: isBool(_editiedEmployee['isSupervisor']),
        isAdmin: false, //isBool(_editiedEmployee['isAdmin']),
      );

      Provider.of<Employees>(context, listen: false)
          .createEmployee(auth.token, password, tempAccount);
    } else {
      EmployeeAccount tempAccount = EmployeeAccount(
        dbID: int.parse(_editiedEmployee['dbID']),
        username: _editiedEmployee['username'],
        employeeID: int.parse(_editiedEmployee['employeeID']),
        firstName: _editiedEmployee['firstName'],
        lastName: _editiedEmployee['lastName'],
        employeeType: int.parse(_editiedEmployee['employeeType']),
        email: _editiedEmployee['email'],
        phone: _editiedEmployee['phone'],
        hourlyWage: double.parse(_editiedEmployee['hourlyWage']),
        scheduledHours: int.parse(_editiedEmployee['scheduledHours']),
        isStaff: isBool(_editiedEmployee['isStaff']),
        isSupervisor: isBool(_editiedEmployee['isSupervisor']),
        isAdmin: false,
      );

      Provider.of<Employees>(context, listen: false)
          .updateEmployees(auth.token, tempAccount.dbID, tempAccount);
    }

    Navigator.of(context).pop();
  }

  //this function checks if null
  bool isNull(var variable) {
    if (variable != null) {
      return false;
    } else {
      return true;
    }
  }

  //formatting and styling
  @override
  Widget build(BuildContext context) {
    EmployeeAccount args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: !isNull(initEmployee)
            ? Text("Editing: ${args.firstName} ${args.lastName}")
            : Text("New Employee Form "),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Container(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                TextFormField(
                  enabled: isNull(initEmployee) ? true : false,
                  initialValue: _editiedEmployee['username'],
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Username is required.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editiedEmployee = {
                      'employeeID': _editiedEmployee['employeeID'],
                      'dbID': _editiedEmployee['dbID'],
                      'username': value,
                      'firstName': _editiedEmployee['firstName'],
                      'lastName': _editiedEmployee['lastName'],
                      'employeeType': _editiedEmployee['employeeType'],
                      'email': _editiedEmployee['email'],
                      'phone': _editiedEmployee['phone'],
                      'hourlyWage': _editiedEmployee['hourlyWage'],
                      'scheduledHours': _editiedEmployee['scheduledHours'],
                      'isStaff': _editiedEmployee['isStaff'],
                      'isSupervisor': _editiedEmployee['isSupervisor'],
                      'isAdmin': _editiedEmployee['isAdmin'],
                    };
                  },
                ),
                isNull(ModalRoute.of(context).settings.arguments)
                    ? TextFormField(
                        enabled: isNull(initEmployee) ? true : false,
                        //initialValue: _editiedEmployee[''],
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Password is required.";
                          }
                          if (value.length < 8) {
                            return "Password is to short.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      )
                    : Container(),
                TextFormField(
                  enabled: isNull(initEmployee) ? true : false,
                  initialValue: _editiedEmployee['employeeID'],
                  decoration: InputDecoration(labelText: 'EmployeeID'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "EmployeeID is required.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editiedEmployee = {
                      'employeeID': value,
                      'dbID': _editiedEmployee['dbID'],
                      'username': _editiedEmployee['username'],
                      'firstName': _editiedEmployee['firstName'],
                      'lastName': _editiedEmployee['lastName'],
                      'employeeType': _editiedEmployee['employeeType'],
                      'email': _editiedEmployee['email'],
                      'phone': _editiedEmployee['phone'],
                      'hourlyWage': _editiedEmployee['hourlyWage'],
                      'scheduledHours': _editiedEmployee['scheduledHours'],
                      'isStaff': _editiedEmployee['isStaff'],
                      'isSupervisor': _editiedEmployee['isSupervisor'],
                      'isAdmin': _editiedEmployee['isAdmin'],
                    };
                  },
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: TextFormField(
                          initialValue: _editiedEmployee['firstName'],
                          decoration: InputDecoration(labelText: 'First Name'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "First name is required.";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editiedEmployee = {
                              'employeeID': _editiedEmployee['employeeID'],
                              'dbID': _editiedEmployee['dbID'],
                              'username': _editiedEmployee['username'],
                              'firstName': value,
                              'lastName': _editiedEmployee['lastName'],
                              'employeeType': _editiedEmployee['employeeType'],
                              'email': _editiedEmployee['email'],
                              'phone': _editiedEmployee['phone'],
                              'hourlyWage': _editiedEmployee['hourlyWage'],
                              'scheduledHours':
                                  _editiedEmployee['scheduledHours'],
                              'isStaff': _editiedEmployee['isStaff'],
                              'isSupervisor': _editiedEmployee['isSupervisor'],
                              'isAdmin': _editiedEmployee['isAdmin'],
                            };
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: TextFormField(
                          initialValue: _editiedEmployee['lastName'],
                          decoration: InputDecoration(labelText: 'Last Name'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Last name is required.";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editiedEmployee = {
                              'employeeID': _editiedEmployee['employeeID'],
                              'dbID': _editiedEmployee['dbID'],
                              'username': _editiedEmployee['username'],
                              'firstName': _editiedEmployee['firstName'],
                              'lastName': value,
                              'employeeType': _editiedEmployee['employeeType'],
                              'email': _editiedEmployee['email'],
                              'phone': _editiedEmployee['phone'],
                              'hourlyWage': _editiedEmployee['hourlyWage'],
                              'scheduledHours':
                                  _editiedEmployee['scheduledHours'],
                              'isStaff': _editiedEmployee['isStaff'],
                              'isSupervisor': _editiedEmployee['isSupervisor'],
                              'isAdmin': _editiedEmployee['isAdmin'],
                            };
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: TextFormField(
                          initialValue: _editiedEmployee['isStaff'],
                          decoration:
                              InputDecoration(labelText: 'Staff Status'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "True or False required.";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editiedEmployee = {
                              'employeeID': _editiedEmployee['employeeID'],
                              'dbID': _editiedEmployee['dbID'],
                              'username': _editiedEmployee['username'],
                              'firstName': _editiedEmployee['firstName'],
                              'lastName': _editiedEmployee['lastName'],
                              'employeeType': _editiedEmployee['employeeType'],
                              'email': _editiedEmployee['email'],
                              'phone': _editiedEmployee['phone'],
                              'hourlyWage': _editiedEmployee['hourlyWage'],
                              'scheduledHours':
                                  _editiedEmployee['scheduledHours'],
                              'isStaff': value,
                              'isSupervisor': _editiedEmployee['isSupervisor'],
                              'isAdmin': _editiedEmployee['isAdmin'],
                            };
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: TextFormField(
                          initialValue: _editiedEmployee['isSupervisor'],
                          decoration:
                              InputDecoration(labelText: 'Supervisor Status'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "True or False required.";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editiedEmployee = {
                              'employeeID': _editiedEmployee['employeeID'],
                              'dbID': _editiedEmployee['dbID'],
                              'username': _editiedEmployee['username'],
                              'firstName': _editiedEmployee['firstName'],
                              'lastName': _editiedEmployee['lastName'],
                              'employeeType': _editiedEmployee['employeeType'],
                              'email': _editiedEmployee['email'],
                              'phone': _editiedEmployee['phone'],
                              'hourlyWage': _editiedEmployee['hourlyWage'],
                              'scheduledHours':
                                  _editiedEmployee['scheduledHours'],
                              'isStaff': _editiedEmployee['isStaff'],
                              'isSupervisor': value,
                              'isAdmin': _editiedEmployee['isAdmin'],
                            };
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  initialValue: _editiedEmployee['email'],
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    bool isValid = EmailValidator.validate(value);
                    if (value.isEmpty) {
                      return "True or False required.";
                    } else if (!isValid) {
                      return "Email is invalid";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editiedEmployee = {
                      'employeeID': _editiedEmployee['employeeID'],
                      'dbID': _editiedEmployee['dbID'],
                      'username': _editiedEmployee['username'],
                      'firstName': _editiedEmployee['firstName'],
                      'lastName': _editiedEmployee['lastName'],
                      'employeeType': _editiedEmployee['employeeType'],
                      'email': value,
                      'phone': _editiedEmployee['phone'],
                      'hourlyWage': _editiedEmployee['hourlyWage'],
                      'scheduledHours': _editiedEmployee['scheduledHours'],
                      'isStaff': _editiedEmployee['isStaff'],
                      'isSupervisor': _editiedEmployee['isSupervisor'],
                      'isAdmin': _editiedEmployee['isAdmin'],
                    };
                  },
                ),
                TextFormField(
                  initialValue: _editiedEmployee['employeeType'],
                  decoration: InputDecoration(labelText: 'Employee Type'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "True or False required.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editiedEmployee = {
                      'employeeID': _editiedEmployee['employeeID'],
                      'dbID': _editiedEmployee['dbID'],
                      'username': _editiedEmployee['username'],
                      'firstName': _editiedEmployee['firstName'],
                      'lastName': _editiedEmployee['lastName'],
                      'employeeType': value,
                      'email': _editiedEmployee['email'],
                      'phone': _editiedEmployee['phone'],
                      'hourlyWage': _editiedEmployee['hourlyWage'],
                      'scheduledHours': _editiedEmployee['scheduledHours'],
                      'isStaff': _editiedEmployee['isStaff'],
                      'isSupervisor': _editiedEmployee['isSupervisor'],
                      'isAdmin': _editiedEmployee['isAdmin'],
                    };
                  },
                ),
                TextFormField(
                  initialValue: _editiedEmployee['scheduledHours'],
                  decoration: InputDecoration(labelText: 'Scheduled Hours'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "True or False required.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editiedEmployee = {
                      'employeeID': _editiedEmployee['employeeID'],
                      'dbID': _editiedEmployee['dbID'],
                      'username': _editiedEmployee['username'],
                      'firstName': _editiedEmployee['firstName'],
                      'lastName': _editiedEmployee['lastName'],
                      'employeeType': _editiedEmployee['employeeType'],
                      'email': _editiedEmployee['email'],
                      'phone': _editiedEmployee['phone'],
                      'hourlyWage': _editiedEmployee['hourlyWage'],
                      'scheduledHours': value,
                      'isStaff': _editiedEmployee['isStaff'],
                      'isSupervisor': _editiedEmployee['isSupervisor'],
                      'isAdmin': _editiedEmployee['isAdmin'],
                    };
                  },
                ),
                TextFormField(
                  initialValue: _editiedEmployee['phone'],
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "True or False required.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editiedEmployee = {
                      'employeeID': _editiedEmployee['employeeID'],
                      'dbID': _editiedEmployee['dbID'],
                      'username': _editiedEmployee['username'],
                      'firstName': _editiedEmployee['firstName'],
                      'lastName': _editiedEmployee['lastName'],
                      'employeeType': _editiedEmployee['employeeType'],
                      'email': _editiedEmployee['email'],
                      'phone': value,
                      'hourlyWage': _editiedEmployee['hourlyWage'],
                      'scheduledHours': _editiedEmployee['scheduledHours'],
                      'isStaff': _editiedEmployee['isStaff'],
                      'isSupervisor': _editiedEmployee['isSupervisor'],
                      'isAdmin': _editiedEmployee['isAdmin'],
                    };
                  },
                ),
                TextFormField(
                  initialValue: _editiedEmployee['hourlyWage'],
                  decoration: InputDecoration(labelText: 'Hourly Wage'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "True or False required.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editiedEmployee = {
                      'employeeID': _editiedEmployee['employeeID'],
                      'dbID': _editiedEmployee['dbID'],
                      'username': _editiedEmployee['username'],
                      'firstName': _editiedEmployee['firstName'],
                      'lastName': _editiedEmployee['lastName'],
                      'employeeType': _editiedEmployee['employeeType'],
                      'email': _editiedEmployee['email'],
                      'phone': _editiedEmployee['phone'],
                      'hourlyWage': value,
                      'scheduledHours': _editiedEmployee['scheduledHours'],
                      'isStaff': _editiedEmployee['isStaff'],
                      'isSupervisor': _editiedEmployee['isSupervisor'],
                      'isAdmin': _editiedEmployee['isAdmin'],
                    };
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
