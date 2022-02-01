import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/employees.dart';
import '../providers/shifts.dart';

//this widget is a form to create a shift
class ShiftForm extends StatefulWidget {
  static const routeName = '/shift-form';
  @override
  _ShiftFormState createState() => _ShiftFormState();
}

class _ShiftFormState extends State<ShiftForm> {
  final _form = GlobalKey<FormState>();
  DateTime pickedDate;
  TimeOfDay pickedTime;
  DateTime _selectedDate;
  TimeOfDay _selectedStartTime;
  TimeOfDay _selectedEndTime;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  int _currentSelectedEmployee;

  bool initForm = false;

  String _currentSelectedValue;

  DateTime temp = DateTime.now();

  ShiftModel _shift = ShiftModel(
    shiftID: 0,
    scheduleID: 6,
    employeeID: null,
    startTime: null,
    endTime: null,
    startLunch: null,
    endLunch: null,
    position: '',
    release: false,
    confirmed: false,
  );

  //this function prompts the user with a date picker widget
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _dateController.value =
            TextEditingValue(text: _selectedDate.toString());
      });
    });
  }

  //this function prompts the user with a date picker widget
  void _presentStartTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        _selectedStartTime = pickedTime;
        _startTimeController.value = TextEditingValue(
            text: _selectedStartTime.format(context).toString());
      });
    });
  }

  //this function prompts the user with a date picker widget
  void _presentEndTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        _selectedEndTime = pickedTime;

        _endTimeController.value =
            TextEditingValue(text: _selectedEndTime.format(context).toString());
      });
    });
  }

  var _positions = [
    "Shift Lead",
    "Cook",
    "Residential Aid",
    "Activities Coordinator",
    "Licensed Vocational Nurses",
  ];

  //this function saves and validates the form
  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();

    _shift = ShiftModel(
        scheduleID: _shift.scheduleID,
        shiftID: _shift.shiftID,
        employeeID: _shift.employeeID,
        startTime: correctDateTime(_selectedStartTime, _selectedDate),
        endTime: correctDateTime(_selectedEndTime, _selectedDate),
        startLunch: correctDate(_selectedDate),
        endLunch: correctDate(_selectedDate),
        position: _shift.position,
        release: _shift.release,
        confirmed: _shift.confirmed);

    var auth = Provider.of<Auth>(context);

    print("isinit: $initForm");
    if (initForm == true) {
      Provider.of<Shifts>(context)
          .updateShift(_shift, _shift.shiftID, auth.token);
    } else {
      Provider.of<Shifts>(context).setShift(_shift, auth.token);
    }
    print(_shift.shiftID);
    print(_shift.scheduleID);

    print(_shift.employeeID);
    print(_shift.startTime);
    print(_shift.endTime);
    print(_shift.startLunch);
    print(_shift.endLunch);
    print(_shift.position);
    print(_shift.release);
    print(_shift.confirmed);

    Navigator.of(context).pop();
  }

  //this function formats the date to a format needed for the database
  DateTime correctDateTime(TimeOfDay day, DateTime date) {
    return DateTime(date.year, date.month, date.day, day.hour, day.minute);
  }

  //this function formats the date to a format needed for the database
  DateTime correctDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    ShiftModel args = ModalRoute.of(context).settings.arguments;

    List<EmployeeAccount> employeeList =
        Provider.of<Employees>(context, listen: false).items;

    //this if statement init the form
    if (initForm == false) {
      print("initing");
      if (args != null) {
        print("setting");
        setState(() {
          _shift.shiftID = args.shiftID;
          _shift.scheduleID = args.scheduleID;
          _shift.employeeID = args.employeeID;
          _shift.startTime = args.startTime;
          _shift.endTime = args.endTime;
          _shift.startLunch = args.startLunch;
          _shift.endLunch = args.endLunch;
          _shift.endTime = args.endTime;
          _shift.position = args.position;
          _shift.release = args.release;
          _shift.confirmed = args.confirmed;
          initForm = true;

          _dateController.value =
              TextEditingValue(text: args.startTime.toString());
          _startTimeController.value =
              TextEditingValue(text: args.startTime.toString());
          _endTimeController.value =
              TextEditingValue(text: args.endTime.toString());
          _currentSelectedEmployee = args.employeeID;
          _currentSelectedValue = args.position;
        });
      }
    }

    //formatting and styling
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Shift"),
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
          child: ListView(
            children: <Widget>[
              FormField<int>(builder: (FormFieldState<int> employee) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter employees name',
                    icon: Icon(Icons.import_contacts, color: Colors.teal),
                  ),
                  isEmpty: _currentSelectedValue == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _currentSelectedEmployee,
                      isDense: true,
                      onChanged: (int newEmployee) {
                        setState(() {
                          _currentSelectedEmployee = newEmployee;
                          employee.didChange(newEmployee);
                        });
                      },
                      items: employeeList.map((EmployeeAccount value) {
                        return DropdownMenuItem<int>(
                          value: value.employeeID,
                          child: Text("${value.firstName} ${value.lastName}"),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }, onSaved: (value) {
                _shift.employeeID = _currentSelectedEmployee;
              }),
              TextFormField(
                onTap: () {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _presentDatePicker();
                  // Show Date Picker Here
                },
                controller: _dateController,

                //initialValue: args.username,
                decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Enter Date',
                  icon: Icon(Icons.import_contacts, color: Colors.teal),
                ),
                validator: (_dateController) {
                  if (_dateController.isEmpty) {
                    return "Date is required.";
                  }
                  return null;
                },
              ),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Position',
                      hintText: 'Enter employees name',
                      icon: Icon(Icons.import_contacts, color: Colors.teal),
                    ),
                    isEmpty: _currentSelectedValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currentSelectedValue,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _currentSelectedValue = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: _positions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              TextFormField(
                onTap: () {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _presentStartTimePicker();
                  // Show Date Picker Here
                },
                controller: _startTimeController,

                //initialValue: args.username,
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  hintText: 'Enter start time',
                  icon: Icon(Icons.import_contacts, color: Colors.teal),
                ),
                validator: (_startTimeController) {
                  if (_startTimeController.isEmpty) {
                    return "Start time required.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _shift = ShiftModel(
                    scheduleID: _shift.scheduleID,
                    shiftID: _shift.shiftID,
                    employeeID: _shift.employeeID,
                    startTime: _shift.startTime,
                    endTime: _shift.endTime,
                    startLunch: _shift.startLunch,
                    endLunch: _shift.endLunch,
                    position: _currentSelectedValue,
                    release: _shift.release,
                    confirmed: _shift.confirmed,
                  );
                },
              ),
              TextFormField(
                onTap: () {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _presentEndTimePicker();
                  // Show Date Picker Here
                },
                controller: _endTimeController,

                //initialValue: args.username,
                decoration: InputDecoration(
                  labelText: 'End Time',
                  hintText: 'Enter end time',
                  icon: Icon(Icons.import_contacts, color: Colors.teal),
                ),
                validator: (_endTimeController) {
                  if (_endTimeController.isEmpty) {
                    return "End time required.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _shift = ShiftModel(
                      scheduleID: _shift.scheduleID,
                      shiftID: _shift.shiftID,
                      employeeID: _shift.employeeID,
                      startTime: _shift.startTime,
                      endTime: _shift.endTime,
                      startLunch: _shift.startLunch,
                      endLunch: _shift.endLunch,
                      position: _currentSelectedValue,
                      release: _shift.release,
                      confirmed: _shift.confirmed);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
