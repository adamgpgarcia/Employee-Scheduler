import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

//chartmodel class definition
class ChartModel {
  List<String> day;
  List<int> date;
  List<bool> working;

  ChartModel({
    @required this.day,
    @required this.date,
    @required this.working,
  });
}

//chartmodel class definition
class ChatModel {
  int chatID;
  List<int> recipients;

  ChatModel({@required this.chatID, @required this.recipients});
}
