import 'package:ScheduleApp/providers/schedules.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TimeCardOff extends StatelessWidget {
  final TimeCard userTimeCard;

  TimeCardOff(this.userTimeCard);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          
            color: Colors.grey[400],
            height: 50,
            child: Row(
              children: <Widget>[
               Flexible(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 12.0, left: 20, bottom: 12),
                            child: Text(
                                "${DateFormat.MMM().format(userTimeCard.day)} ${DateFormat.Md().format(userTimeCard.day)}",
                                style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                       Center(child: Text("OFF",style: TextStyle(fontSize: 22),),),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(),
                  
                ),
               
              ],
            ),
          
        ),
        Container(height:2,color: Colors.white),
      ],
    );
  }
}
