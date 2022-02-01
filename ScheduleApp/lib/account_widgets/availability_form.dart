import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/employees.dart';
import '../providers/timeslot.dart';

//This stateful widget promts the user with a form where they can change their availability based on day
class AvailabilityForm extends StatefulWidget {
  final String day;
  AvailabilityForm(this.day);

  @override
  _AvailabilityFormState createState() => _AvailabilityFormState();
}

class _AvailabilityFormState extends State<AvailabilityForm> {
  final _form = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  TimeOfDay pickedTime;
  TimeOfDay _selectedStartTime;
  TimeOfDay _selectedEndTime;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  String _currentSelectedValue;

  DateTime temp = DateTime.now();

  //slot is empty by default
  TimeSlotModel _slot = TimeSlotModel(
      id: null,
      employeeID: null,
      startTime: null,
      endTime: null,
      currentDay: null);

  //void function presents user with built in widget to select time
  void _presentStartTimePicker() {
    showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        }).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      //alters state
      setState(() {
        _selectedStartTime = pickedTime;
        _startTimeController.value = TextEditingValue(
            text:
                "${_selectedStartTime.hour.toString()}:${_selectedStartTime.minute.toString()}");
      });
    });
  }

  //void function presents user with built in widget to select time
  void _presentEndTimePicker() {
    showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        }).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      //alters state
      setState(() {
        _selectedEndTime = pickedTime;

        _endTimeController.value = TextEditingValue(
            text:
                "${_selectedEndTime.hour.toString()}:${_selectedEndTime.minute.toString()}");
      });
    });
  }

  //void function to validate and save availability form
  void saveAvailabilityForm() {
    //checks if form is validate
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();

    var auth = Provider.of<Auth>(context);

    _slot = TimeSlotModel(
        id: null,
        employeeID: auth.user,
        startTime: correctDateTime(_selectedStartTime, date),
        endTime: correctDateTime(_selectedEndTime, date),
        currentDay: widget.day);

    Provider.of<TimeSlots>(context).setTimeSlot(_slot, auth.token);

    // print(_slot.employeeID);
    // print(_slot.startTime);
    // print(_slot.endTime);
    // print(_slot.currentDay);
    // print(_slot.employeeID.runtimeType);
    // print(_slot.startTime.runtimeType);
    // print(_slot.endTime.runtimeType);
    // print(_slot.currentDay.runtimeType);

    Navigator.of(context).pop();
  }

  //function breaks down date into the needed format
  DateTime correctDateTime(TimeOfDay day, DateTime date) {
    return DateTime(date.year, date.month, date.day, day.hour, day.minute);
  }

  //formatting and styling of widget
  @override
  Widget build(BuildContext context) {
    var employees = Provider.of<Employees>(context, listen: false);
    List<EmployeeAccount> employeeList =
        Provider.of<Employees>(context, listen: false).items;

    return Form(
      key: _form,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 50,
                width: 100,
                child: TextFormField(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _presentStartTimePicker();
                  },
                  controller: _startTimeController,
                  decoration: InputDecoration(
                    labelText: 'Start Time',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    filled: true,
                  ),
                  validator: (_startTimeController) {
                    if (_startTimeController.isEmpty) {
                      return "Start time required.";
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),
              ),
              Text(" - "),
              Container(
                height: 50,
                width: 100,
                child: TextFormField(
                  onTap: () {
                    // Below line stops keyboard from appearing
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _presentEndTimePicker();
                  },
                  controller: _endTimeController,
                  decoration: InputDecoration(
                    labelText: 'End Time',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    filled: true,
                    // fillColor: Colors.white70,
                  ),
                  validator: (_endTimeController) {
                    if (_endTimeController.isEmpty) {
                      return "End time required.";
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.teal[500],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.teal[200])),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text("  "),
                RaisedButton(
                  color: Colors.teal[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.teal[500])),
                  onPressed: () {
                    saveAvailabilityForm();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
