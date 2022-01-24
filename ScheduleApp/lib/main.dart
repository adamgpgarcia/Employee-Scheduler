import 'package:ScheduleApp/account_widgets/availibility_screen.dart';
import 'package:ScheduleApp/admin_timecard/employee_timecards.dart';
import 'package:ScheduleApp/admin_timecard/timecard_list.dart';
import 'package:ScheduleApp/forms/create_schedule.dart';
import 'package:ScheduleApp/messaging_widgets/individual_chat.dart';
import './screens/timecard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/messages.dart';
import './forms/create_shift.dart';
import './providers/employees.dart';
import './providers/auth.dart';
import './providers/shifts.dart';
import './providers/timeslot.dart';
import './providers/chats.dart';
import './account_widgets/availibility_screen.dart';
import './providers/schedules.dart';
import './screens/auth_screen.dart';
import './forms/timecard_form.dart';
import './screens/employee_screen.dart';
import './admin_timecard/single_view_timecard.dart';
import './screens/schedule_list.dart';
import './admin_schedule/shifts_list.dart';
import './schedule_widgets/shift_message.dart';
import './screens/single_employee_screen.dart';
import './admin_schedule/schedule_info.dart';
import './employee_widgets/employee_form.dart';
import './admin_timecard/employee_timecards.dart';
import './nav.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Messages(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Employees(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Schedules(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Shifts(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Chats(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TimeSlots(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            theme: ThemeData(
              primaryColor: Colors.teal[900],
            ),
            title: 'Bottom navigation bar',
            home: auth.isAuth ? Nav(auth.user) : AuthScreen(),
            routes: {
              IndividualChatScreen.routeName: (ctx) => IndividualChatScreen(),
              SingleEmployeeScreen.routeName: (ctx) => SingleEmployeeScreen(),
              EmployeeScreen.routeName: (ctx) => EmployeeScreen(),
              EmployeeForm.routeName: (ctx) => EmployeeForm(),
              ShiftMessage.routeName: (ctx) => ShiftMessage(),
              ScheduleForm.routeName: (ctx) => ScheduleForm(),
              ShiftForm.routeName: (ctx) => ShiftForm(),
              TimeCardScreen.routeName: (ctx) => TimeCardScreen(),
              ScheduleList.routeName: (ctx) => ScheduleList(),
              ScheduleInfo.routeName: (ctx) => ScheduleInfo(),
              ShiftsList.routeName: (ctx) => ShiftsList(),
              TimecardForm.routeName: (ctx) => TimecardForm(),
              TimecardList.routeName: (ctx) => TimecardList(),
              EmployeeTimecards.routeName: (ctx) => EmployeeTimecards(),
              AvailibilityScreen.routeName: (ctx) => AvailibilityScreen(),
              SingleViewTimecards.routeName: (ctx) => SingleViewTimecards(),
            }),
      ),
    );
  }
}
