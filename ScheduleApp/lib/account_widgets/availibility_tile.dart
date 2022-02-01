import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/timeslot.dart';

//This widget displays employee schedule availability based on day of the week
class AvailabilityTile extends StatelessWidget {
  int user;
  String day;
  AvailabilityTile(this.user, this.day);

  //function checks if temp is null
  bool isNull(var temp) {
    if (temp == null) {
      return true;
    } else {
      return false;
    }
  }

  //formatting and styling of widget
  @override
  Widget build(BuildContext context) {
    //gets Auth key from Auth Provider
    var auth = Provider.of<Auth>(context);
    var timeSlots = Provider.of<TimeSlots>(context, listen: false);
    //gets time slots of employee from database
    timeSlots.getTimeSlots(auth.token);
    List<TimeSlotModel> userTimeSlots =
        Provider.of<TimeSlots>(context, listen: false)
            .sortedTimeSlots(auth.user, day);

    print("value: ${userTimeSlots.length}");

    return userTimeSlots.length == 0
        ? Container(
            height: 50,
            width: double.infinity,
            color: Colors.white,
            child: Center(
                child: Text("No Availability", style: TextStyle(fontSize: 15))))
        : ListView.builder(
            //userTimeSlots == null ?
            itemCount: userTimeSlots.length,
            itemBuilder: (ctx, i) {
              return Container(
                height: 50,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0),
                      child: Text(
                          "From: ${TimeOfDay.fromDateTime(userTimeSlots[i].startTime).hour.toString()}:${TimeOfDay.fromDateTime(userTimeSlots[i].startTime).minute.toString()}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    Text(
                        "To: ${TimeOfDay.fromDateTime(userTimeSlots[i].endTime).hour.toString()}:${TimeOfDay.fromDateTime(userTimeSlots[i].endTime).minute.toString()}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Padding(
                      padding: const EdgeInsets.only(right: 70.0),
                      child: IconButton(
                        icon: Icon(Icons.delete_forever_rounded),
                        color: Colors.red,
                        onPressed: () {
                          timeSlots.deleteTimeSlot(
                              userTimeSlots[i].id, auth.token);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
