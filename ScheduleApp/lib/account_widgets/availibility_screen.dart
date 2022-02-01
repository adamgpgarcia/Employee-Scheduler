import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timeslot.dart';
import '../providers/auth.dart';
import '../account_widgets/availibility_tile.dart';
import '../account_widgets/availability_form.dart';

List<String> weekDays = [
  "Sunday",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday"
];

//this is the stateful widget for the availability screen
class AvailibilityScreen extends StatefulWidget {
  static const routeName = '/change-availibility';
  @override
  _AvailibilityScreenState createState() => _AvailibilityScreenState();
}

class _AvailibilityScreenState extends State<AvailibilityScreen> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    Provider.of<TimeSlots>(context, listen: false).getTimeSlots(auth.token);

    var userTimeSlots = Provider.of<TimeSlots>(context, listen: false);

    int dayIndex = 0;
    bool init = false;

    bool isDayChange(String day) {
      if (init == false) {
        init = true;
        return true;
      }
      if (weekDays[dayIndex] != day) {
        dayIndex++;
        return true;
      } else {
        return false;
      }
    }

    //formatting and styling
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Availability",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: ListView.builder(
        itemCount: weekDays.length,
        itemBuilder: (ctx, i) {
          return Column(
            children: <Widget>[
              Container(
                height: 50,
                width: double.infinity,
                color: Colors.grey[700],
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        weekDays[i],
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                          icon: Icon(Icons.add),
                          color: Colors.white,
                          onPressed: () {
                            return showDialog(
                              context: context,
                              builder: (ctx) => Dialog(
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          "${weekDays[i]} Availability",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Container(
                                          width: 250,
                                          height: 140,
                                          child: AvailabilityForm(weekDays[i])),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
              Container(
                height: 50 * userTimeSlots.countSlots(auth.user, weekDays[i]),
                width: double.infinity,
                color: Colors.white,
                child: AvailabilityTile(auth.user, weekDays[i]),
              )
            ],
          );
        },
      ),
    );
  }
}
