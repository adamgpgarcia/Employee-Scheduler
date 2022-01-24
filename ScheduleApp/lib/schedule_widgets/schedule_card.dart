//import '../providers/shift.dart';
import 'package:flutter/material.dart';
import '../providers/shifts.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import "../providers/employees.dart";
import 'package:intl/intl.dart';
import './shift_message.dart';


class ScheduleCard extends StatefulWidget {

  final List <ShiftModel> weekSchedule;
  final int index;
  final int currentUser;
  ScheduleCard(this.weekSchedule,this.index,this.currentUser);



  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  
  @override
  Widget build(BuildContext context) {

    // for(var temp in widget.weekSchedule){
    //   print(temp.employeeID);
    //    print(temp.startTime);
    //     print(temp.endTime);
    //      print(temp.position);
          
    // }

 
    var schedule = Provider.of<Shifts>(context);
    var auth = Provider.of<Auth>(context, listen: false);
    var employee = Provider.of<Employees>(context);
     Provider.of<Employees>(context, listen: false).getEmployees(auth.token);
    return Card(
                    margin: EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 75,
                          height: 75,
                          padding: EdgeInsets.only(top: 12),
                          child: Column(
                            children: <Widget>[
                              Text(
                                DateFormat.E().format(
                                    widget.weekSchedule[widget.index].startTime),
                                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)
                              ),
                              Text(
                                DateFormat.d().format(
                                    widget.weekSchedule[widget.index].startTime),
                                    style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            height: 50,
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${DateFormat.jm().format(widget.weekSchedule[widget.index].startTime)} - ${DateFormat.jm().format(widget.weekSchedule[widget.index].endTime)}",
                                
                                style: TextStyle(fontSize: 21,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:7.0, top:3, bottom: 3),
                              child: Text(
                                "${employee.getName(widget.weekSchedule[widget.index].employeeID)}  -  ${widget.weekSchedule[widget.index].position } ",  // ${employee.getName(widget.weekSchedule[widget.index].employeeID )}
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        new Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: Container(
                          
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget> [
                                if(widget.weekSchedule[widget.index].employeeID == auth.user)
                                  if(widget.weekSchedule[widget.index].release == true)
                                    RaisedButton(
                                        color: Colors.grey[700],
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.teal[500])),
                                        onPressed: () {
                                          widget.weekSchedule[widget.index].release = !widget.weekSchedule[widget.index].release;
                                      schedule.updateShift(widget.weekSchedule[widget.index], widget.weekSchedule[widget.index].shiftID , auth.token);
                                        },
                                         child: Text(
                                          "Released",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      
                                    
                                    )
                                  else
                                      RaisedButton(
                                        color: Colors.grey[400],
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.teal[500])),
                                        onPressed: () {
                                          widget.weekSchedule[widget.index].release = !widget.weekSchedule[widget.index].release;
                                      schedule.updateShift(widget.weekSchedule[widget.index], widget.weekSchedule[widget.index].shiftID , auth.token);
                                        },
                                        child: Text(
                                          "Release",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                  

                                  // else
                                  //   IconButton( icon: Icon(Icons.check_circle_outline_sharp), onPressed: (){}),
                                // if(widget.weekSchedule[widget.index].employeeID == auth.user)
                                //   IconButton(color: Colors.red,icon: Icon(Icons.error_outline), onPressed: (){
                                //      Navigator.of(context).pushNamed(
                                //       ShiftMessage.routeName,
                                //       arguments: widget.weekSchedule[widget.index] );
                                //   }),
                                
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
  }
}