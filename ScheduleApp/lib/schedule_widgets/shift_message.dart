import 'package:flutter/material.dart';
import '../providers/shifts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum Reason { late, call_off, other }

Reason status;

//this widget allows an employee to message a supervisor about their shift call off, late,
class ShiftMessage extends StatefulWidget {
  static const routeName = '/shift-message';
  @override
  _ShiftMessageState createState() => _ShiftMessageState();
}

class _ShiftMessageState extends State<ShiftMessage> {
  //this functions sets reason
  void setReason(Reason temp) {
    setState(() {
      status = temp;
    });
  }

  //returns id of current supervisor
  int currentSupervisor(
      DateTime dateShift, List<ShiftModel> schedules, var schedule) {
    for (int i = 0; i < schedules.length; i++) {
      if (schedule.sameDay(schedules[i].startTime, dateShift)) {
        if (schedules[i].position == "Lead") {
          return schedules[i].employeeID;
        }
      }
    }
    return null;
  }

  //formatting and styling
  @override
  Widget build(BuildContext context) {
    print(status);
    ShiftModel args = ModalRoute.of(context).settings.arguments;
    var schedule = Provider.of<Shifts>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shift: ${DateFormat.E().format(args.startTime)} ${DateFormat.d().format(args.startTime)}  at  ${DateFormat.jm().format(args.startTime)} - ${DateFormat.jm().format(args.endTime)}",
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Reason", style: TextStyle(fontSize: 25)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ButtonTheme(
                    minWidth: 125,
                    height: 40,
                    child: status == Reason.late
                        ? RaisedButton(
                            color: Colors.teal[900],
                            shape: StadiumBorder(),
                            onPressed: () {},
                            child: Text(
                              "Late",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : RaisedButton(
                            color: Colors.grey,
                            shape: StadiumBorder(),
                            onPressed: () {
                              setReason(Reason.late);
                            },
                            child: Text("Late"),
                          )),
                ButtonTheme(
                    minWidth: 125,
                    height: 40,
                    child: status == Reason.call_off
                        ? RaisedButton(
                            color: Colors.teal[900],
                            shape: StadiumBorder(),
                            onPressed: () {},
                            child: Text(
                              "Call Off",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : RaisedButton(
                            color: Colors.grey,
                            shape: StadiumBorder(),
                            onPressed: () {
                              setReason(Reason.call_off);
                            },
                            child: Text("Call Off"),
                          )),
                ButtonTheme(
                    minWidth: 125,
                    height: 40,
                    child: status == Reason.other
                        ? RaisedButton(
                            color: Colors.teal[900],
                            shape: StadiumBorder(),
                            onPressed: () {},
                            child: Text(
                              "Other",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : RaisedButton(
                            color: Colors.grey,
                            shape: StadiumBorder(),
                            onPressed: () {
                              setReason(Reason.other);
                            },
                            child: Text("Other"),
                          )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Message", style: TextStyle(fontSize: 25)),
            ),
            Container(
              width: 375,
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey[800]), //color: Colors.transparent
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[800]),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  hintText: "Input message",
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                maxLines: 3,
              ),
            ),
            ButtonTheme(
              minWidth: 125,
              height: 40,
              child: RaisedButton(
                color: Colors.green,
                shape: StadiumBorder(),
                onPressed: () {
                  print(currentSupervisor(
                      args.startTime, schedule.items, schedule));
                  status = null;
                  Navigator.of(context).pop();
                },
                child: Text("Send"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
