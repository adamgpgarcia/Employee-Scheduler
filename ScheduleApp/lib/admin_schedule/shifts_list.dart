import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/shifts.dart';
import '../providers/employees.dart';
import 'package:intl/intl.dart';
import '../forms/create_shift.dart';

class ShiftsList extends StatelessWidget {
  static const routeName = '/shifts-list';
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var auth = Provider.of<Auth>(context, listen: false);
    var width = screenSize.width;
    var employee = Provider.of<Employees>(context, listen: false);
    DateTime args = ModalRoute.of(context).settings.arguments;

    List<ShiftModel> shifts = Provider.of<Shifts>(context).getShiftsOnDay(args);

    bool isNull(temp) {
      if (temp == null) {
        return true;
      } else {
        return false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${DateFormat.EEEE().format(args).toString()}  ${DateFormat.yMMMd().format(args).toString()}"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 10.0, bottom: 8),
                child: RaisedButton(
                  color: Colors.teal[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.teal[500])),
                  onPressed: () {
                    Navigator.of(context).pushNamed(ShiftForm.routeName);
                  },
                  child: Text(
                    "Add Shift",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 400,
            color: Colors.white,
            child: !isNull(shifts)
                ? ListView.builder(
                    itemCount: shifts.length,
                    itemBuilder: (ctx, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.grey[400],
                          width: width - 16,
                          height: 110,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                          "Shift ID: ${shifts[i].shiftID.toString()}"),
                                      Text(
                                          "Employee: ${employee.getName(shifts[i].employeeID)}"),
                                      Text(
                                          "Start Shift: ${shifts[i].startTime.hour.toString()}:${shifts[i].startTime.minute.toString()}  -  End Shift: ${shifts[i].endTime.hour.toString()}:${shifts[i].endTime.minute.toString()}"),
                                    ]),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    RaisedButton(
                                      color: Colors.teal[900],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.teal[500])),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            ShiftForm.routeName,
                                            arguments: shifts[i]);
                                      },
                                      child: Text(
                                        "Edit Shift",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    RaisedButton(
                                      color: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.teal[500])),
                                      onPressed: () {
                                        return showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('Are you sure?'),
                                            content: Text(
                                                'Permenently delete shift.'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Confirm'),
                                                onPressed: () {
                                                  Provider.of<Shifts>(context,
                                                          listen: false)
                                                      .deleteShift(
                                                          shifts[i],
                                                          shifts[i].shiftID,
                                                          auth.token);
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: Text("No Shifts on this day")),
          )
        ],
      ),
    );
  }
}
