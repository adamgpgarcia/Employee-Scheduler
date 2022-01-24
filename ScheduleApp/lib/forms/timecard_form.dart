import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/employees.dart';
import '../providers/schedules.dart';
import '../providers/shifts.dart';

class TimecardForm extends StatefulWidget {
  static const routeName = '/timecard-form';
  @override
  _TimecardFormState createState() => _TimecardFormState();
}

class _TimecardFormState extends State<TimecardForm> {
  final _form = GlobalKey<FormState>();
  DateTime pickedDate;
  TimeOfDay pickedTime;

  DateTime _currentDate;
  TimeOfDay _selectedStartTime;
  TimeOfDay _selectedEndTime;
  TimeOfDay _selectedEndLunch;
  TimeOfDay _selectedStartLunch;

  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _startLunchController = TextEditingController();
  TextEditingController _endLunchController = TextEditingController();

  bool initForm = false;

  String _currentSelectedValue;

  DateTime temp = DateTime.now();

  ShiftModel _shift = ShiftModel(
    shiftID: 0,
    scheduleID: null,
    employeeID: null,
    startTime: null,
    endTime: null,
    startLunch: null,
    endLunch: null,
    position: '',
    release: false,
    confirmed: false,
  );

  void _presentStartTimePicker() {
    showTimePicker(
        context: context,
        initialTime: _selectedStartTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        }).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        _selectedStartTime = pickedTime;
        _startTimeController.value = TextEditingValue(
            text:
                "${_selectedStartTime.hour.toString()}:${_selectedStartTime.minute.toString()}");
      });
    });
  }

  void _presentStartLunchPicker() {
    showTimePicker(
        context: context,
        initialTime: _selectedStartLunch,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        }).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        _selectedStartLunch = pickedTime;
        _startLunchController.value = TextEditingValue(
            text:
                "${_selectedStartLunch.hour.toString()}:${_selectedStartLunch.minute.toString()}");
      });
    });
  }

  void _presentEndLunchPicker() {
    showTimePicker(
        context: context,
        initialTime: _selectedEndLunch,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        }).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        _selectedEndLunch = pickedTime;
        _endLunchController.value = TextEditingValue(
            text:
                "${_selectedEndLunch.hour.toString()}:${_selectedEndLunch.minute.toString()}");
      });
    });
  }

  void _presentEndTimePicker() {
    showTimePicker(
        context: context,
        initialTime: _selectedEndTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        }).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        _selectedEndTime = pickedTime;

        _endTimeController.value = TextEditingValue(
            text:
                "${_selectedEndTime.hour.toString()}:${_selectedEndTime.minute.toString()}");
      });
    });
  }

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
        startTime: correctDateTime(_selectedStartTime, _currentDate),
        endTime: correctDateTime(_selectedEndTime, _currentDate),
        startLunch: correctDateTime(_selectedStartLunch, _currentDate),
        endLunch: correctDateTime(_selectedEndLunch, _currentDate),
        position: _shift.position,
        release: _shift.release,
        confirmed: _shift.confirmed);

    var auth = Provider.of<Auth>(context);

    Provider.of<Shifts>(context)
        .updateShift(_shift, _shift.shiftID, auth.token);

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

  DateTime correctDateTime(TimeOfDay day, DateTime date) {
    return DateTime(date.year, date.month, date.day, day.hour, day.minute);
  }

  @override
  Widget build(BuildContext context) {
    TimeCard args = ModalRoute.of(context).settings.arguments;

    if (initForm == false) {
      setState(() {
        _shift.shiftID = args.shift.shiftID;
        _shift.scheduleID = args.shift.scheduleID;
        _shift.employeeID = args.shift.employeeID;
        _shift.startTime = args.shift.startTime;
        _shift.endTime = args.shift.endTime;
        _shift.startLunch = args.shift.startLunch;
        _shift.endLunch = args.shift.endLunch;
        _shift.endTime = args.shift.endTime;
        _shift.position = args.shift.position;
        _shift.release = args.shift.release;
        _shift.confirmed = args.shift.confirmed;
        initForm = true;
        print(args.shift.confirmed);

        _startTimeController.value = TextEditingValue(
            text:
                "${TimeOfDay.fromDateTime(args.shift.startTime).hour.toString()}:${TimeOfDay.fromDateTime(args.shift.startTime).minute.toString()}");
        _endTimeController.value = TextEditingValue(
            text:
                "${TimeOfDay.fromDateTime(args.shift.endTime).hour.toString()}:${TimeOfDay.fromDateTime(args.shift.endTime).minute.toString()}");
        _startLunchController.value = TextEditingValue(
            text:
                "${TimeOfDay.fromDateTime(args.shift.startLunch).hour.toString()}:${TimeOfDay.fromDateTime(args.shift.startLunch).minute.toString()}");
        _endLunchController.value = TextEditingValue(
            text:
                "${TimeOfDay.fromDateTime(args.shift.endLunch).hour.toString()}:${TimeOfDay.fromDateTime(args.shift.endLunch).minute.toString()}");
        _selectedStartLunch = TimeOfDay.fromDateTime(args.shift.startLunch);
        _selectedEndLunch = TimeOfDay.fromDateTime(args.shift.endLunch);
        _selectedStartTime = TimeOfDay.fromDateTime(args.shift.startTime);
        _selectedEndTime = TimeOfDay.fromDateTime(args.shift.endTime);
        _currentSelectedValue = args.shift.position;
        _currentDate = args.day;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Shift"),
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
              TextFormField(
                onTap: () {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _presentStartTimePicker();
                  // Show Date Picker Here
                },
                controller: _startTimeController,

                //initialValue: args.shift.username,
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
              TextFormField(
                onTap: () {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _presentStartLunchPicker();
                  // Show Date Picker Here
                },
                controller: _startLunchController,

                //initialValue: args.shift.username,
                decoration: InputDecoration(
                  labelText: 'Start Lunch Time',
                  hintText: 'Enter Start Lunch Time',
                  icon: Icon(Icons.import_contacts, color: Colors.teal),
                ),
                validator: (_startLunchController) {
                  if (_startLunchController.isEmpty) {
                    return "Start Lunch required.";
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
                  _presentEndLunchPicker();
                  // Show Date Picker Here
                },
                controller: _endLunchController,

                //initialValue: args.shift.username,
                decoration: InputDecoration(
                  labelText: 'End of Lunch Time',
                  hintText: 'Enter Lunch Time',
                  icon: Icon(Icons.import_contacts, color: Colors.teal),
                ),
                validator: (_endLunchController) {
                  if (_endLunchController.isEmpty) {
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
                    confirmed: _shift.confirmed,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
