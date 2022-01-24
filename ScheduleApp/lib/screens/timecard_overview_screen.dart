import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/schedules.dart';
import '../providers/auth.dart';
import '../screens/timecard_screen.dart';

class TimecardOverviewScreen extends StatelessWidget {
  static const routeName = '/timecard-overview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timecard Overview"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed(TimeCardScreen.routeName);
                     
                  },
                                child: Container(
                    color: Colors.grey,
                    width: 100,
                    height: 100,
                    child: Center(child: Text("Edit Timecard")),
                  ),
                ),
                GestureDetector(
                                child: Container(
                                   color: Colors.grey,
                    width: 100,
                    height: 100,
                    child: Center(child: Text("Timecard History")),
                  ),
                ),
                
              ],

            ),
          ),
          
              Text("Scheduled hours Timeperiod"),
              Text("Hours So Far"),
        
        ],
      ),
    );
  }
}
