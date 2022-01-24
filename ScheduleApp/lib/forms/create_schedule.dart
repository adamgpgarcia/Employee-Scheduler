import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

import '../providers/schedules.dart';

class ScheduleForm extends StatefulWidget {
  static const routeName = '/schedule-form';
  @override
  _ScheduleFormState createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  final _form = GlobalKey<FormState>();

  DateTime _selectedDueDate;
  DateTime _selectedStartDate;
  DateTime _selectedEndDate;
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _dueDateController = TextEditingController();

  bool initForm = false;

  DateTime temp = DateTime.now();

  ScheduleModel _schedule = ScheduleModel(
    scheduleID: null,
    companyID: 1,
    startPeriod: null,
    endPeriod: null,
    timecardDue: null,
  );

  void _presentStartDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 360)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedStartDate = pickedDate;
        _startDateController.value =
            TextEditingValue(text: _selectedStartDate.toString());
      });
    });
  }

  void _presentEndDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 360)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedEndDate = pickedDate;
        _endDateController.value =
            TextEditingValue(text: _selectedStartDate.toString());
      });
    });
  }

  void _presentDueDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 360)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDueDate = pickedDate;
        _dueDateController.value =
            TextEditingValue(text: _selectedDueDate.toString());
      });
    });
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    if ((_selectedStartDate != null && _selectedEndDate != null) &&
        _selectedDueDate != null) {
      print('nothing equals null');
    } else {
      print('Something equals null');
    }
    _form.currentState.save();

    var auth = Provider.of<Auth>(context);

    if (initForm == true) {
      Provider.of<Schedules>(context)
          .updateSchedule(_schedule, _schedule.scheduleID, auth.token);
    } else {
      Provider.of<Schedules>(context).setSchedule(_schedule, auth.token);
    }
    print(_schedule.scheduleID);
    print(_schedule.companyID);
    print(_schedule.startPeriod);
    print(_schedule.endPeriod);
    print(_schedule.timecardDue);

    Navigator.of(context).pop();
  }

  DateTime correctDateTime(TimeOfDay day, DateTime date) {
    return DateTime(date.year, date.month, date.day, day.hour, day.minute);
  }

  DateTime correctDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    ScheduleModel args = ModalRoute.of(context).settings.arguments;

    if (initForm == false) {
      print("initing");
      if (args != null) {
        print("setting");
        setState(() {
          initForm = true;
          _schedule.scheduleID = args.scheduleID;
          _schedule.startPeriod = args.startPeriod;
          _schedule.endPeriod = args.endPeriod;
          _schedule.timecardDue = args.timecardDue;
          _schedule.companyID = args.companyID;
          _selectedStartDate = args.startPeriod;
          _selectedEndDate = args.endPeriod;
          _selectedDueDate = args.timecardDue;
          _startDateController.value =
              TextEditingValue(text: args.startPeriod.toString());
          _endDateController.value =
              TextEditingValue(text: args.endPeriod.toString());
          _dueDateController.value =
              TextEditingValue(text: args.timecardDue.toString());
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Schedule"),
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
                  _presentStartDatePicker();
                  // Show Date Picker Here
                },
                controller: _startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  hintText: 'Enter employees name',
                  icon: Icon(Icons.import_contacts, color: Colors.teal),
                ),
                validator: (_startDateController) {
                  if (_startDateController.isEmpty) {
                    return "Start date required.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _schedule = ScheduleModel(
                      scheduleID: _schedule.scheduleID,
                      companyID: _schedule.companyID,
                      startPeriod: _selectedStartDate,
                      endPeriod: _schedule.endPeriod,
                      timecardDue: _schedule.timecardDue);
                },
              ),
              TextFormField(
                onTap: () {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _presentEndDatePicker();
                  // Show Date Picker Here
                },
                controller: _endDateController,
                decoration: InputDecoration(
                  labelText: 'End Date',
                  hintText: 'Enter End Date',
                  icon: Icon(Icons.import_contacts, color: Colors.teal),
                ),
                validator: (_endDateController) {
                  if (_endDateController.isEmpty) {
                    return "End Date required.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _schedule = ScheduleModel(
                      scheduleID: _schedule.scheduleID,
                      companyID: _schedule.companyID,
                      startPeriod: _schedule.startPeriod,
                      endPeriod: _selectedEndDate,
                      timecardDue: _schedule.timecardDue);
                },
              ),
              TextFormField(
                onTap: () {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _presentDueDatePicker();
                  // Show Date Picker Here
                },
                controller: _dueDateController,

                //initialValue: args.username,
                decoration: InputDecoration(
                  labelText: 'Timecard Due Date',
                  hintText: 'Enter Timecard Due Date',
                  icon: Icon(Icons.import_contacts, color: Colors.teal),
                ),
                validator: (_dueDateController) {
                  if (_dueDateController.isEmpty) {
                    return "Timecard Due Date Required.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _schedule = ScheduleModel(
                      scheduleID: _schedule.scheduleID,
                      companyID: _schedule.companyID,
                      startPeriod: _schedule.startPeriod,
                      endPeriod: _schedule.endPeriod,
                      timecardDue: _selectedDueDate);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
