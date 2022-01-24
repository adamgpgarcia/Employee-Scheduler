import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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

class ChatModel {
  int chatID;
  List<int> recipients;

  ChatModel({@required this.chatID, @required this.recipients});
}
