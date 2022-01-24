import 'package:ScheduleApp/providers/schedules.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedules.dart';
import '../providers/shifts.dart';
import '../providers/auth.dart';
import 'package:intl/intl.dart';


double countAllHours(shift, List <TimeCard> userTimeCard){
  double totalHours = 0;

  for(var item in userTimeCard){
    if(item.shift.employeeID != 0){
       totalHours += shift.hoursWorked(item.shift.startTime,item.shift.endTime);
    }
  }
  return totalHours;
}




class HourViewer extends StatelessWidget {

  DateTime dueDate;
  List <TimeCard> userTimeCard;

  HourViewer(this.dueDate,this.userTimeCard);

  // Container(
  //             padding: EdgeInsets.all(5),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: <Widget>[
  //                 Expanded(

  //                   child: Container(
  //                     child: Center(child: 
  //                     
  //                 ),
                  
  //               ],
  //             ),
  //           ),
  
  @override
  Widget build(BuildContext context) {

    var auth = Provider.of<Auth>(context);
    var shift = Provider.of<Shifts>(context);
    TimecardCalculations timeCalulations = shift.timeCalculations(shift, auth.user,userTimeCard);

   

    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15.00, right: 15.00),
      child: Container(
        decoration: BoxDecoration(
           color: Colors.white,
           border: Border.all(
             color:Colors.grey,
           ),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
                  
       
        width: deviceSize.width,
        height: 185,
        child: Column(children:<Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top:20, bottom:20),
            child: Row(children: <Widget>[Text("Due Date:   ${DateFormat.yMMMd().format(dueDate)}",style: TextStyle(fontSize: 20),)],),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Container(color: Colors.grey[300], width: deviceSize.width-50,height: 2,)],),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Text("Total ${countAllHours(shift, userTimeCard).toString()} hr", style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold))],),
          ),  //Text(countAllHours(shift, userTimeCard).toString())
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
              Column(children:<Widget>[Text("${timeCalulations.regTime}", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),), Text("Reg"),]),
              Column(children:<Widget>[Text("${timeCalulations.overTime}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),), Text("OT1"),]),
              Column(children:<Widget>[Text("${timeCalulations.doubleTime}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),), Text("OT2"),]),
            ],),
            
          ),
          Spacer(),
           Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Container(color: Colors.grey[300], width: deviceSize.width-45,height: 2,)],),
        ]),
      ),
    );
  }
}