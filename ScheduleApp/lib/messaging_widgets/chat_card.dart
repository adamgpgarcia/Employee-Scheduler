import 'package:ScheduleApp/providers/chats.dart';
import 'package:flutter/material.dart';
import '../providers/messages.dart';
import '../providers/auth.dart';
import '../providers/chats.dart';
import '../providers/employees.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

//this widget shows if you have a chat thread from a person, which you can click into
class ChatCard extends StatelessWidget {
  final ChatModel currentChat;

  ChatCard(this.currentChat);

  //this checks if sender is the current user
  bool isCurrentUser(int currentUser, int sender) {
    if (currentUser == sender) {
      return true;
    }
    return false;
  }

  String correctStringAmount(String temp, int sender, int currentUser) {
    String you = "You:";
    String newish = '';
    print(sender);
    print("true: ${isCurrentUser(currentUser, sender)}");

    if (temp.length > 40) {
      for (int i = 0; i < 30; i++) {
        newish += temp[i];
      }
      if (isCurrentUser(currentUser, sender)) {
        return "$you $newish";
      } else {
        return newish;
      }
    }
    if (isCurrentUser(currentUser, sender)) {
      return "$you $temp";
    } else {
      return temp;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    var auth = Provider.of<Auth>(context, listen: false);
    var chat = Provider.of<Chats>(context, listen: false);
    var employees = Provider.of<Employees>(context, listen: false);
    var messages = Provider.of<Messages>(context, listen: false);

    //formatting and styling
    return Container(
      width: width,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[500],
              child: Text(
                employees.getIntials(chat.findReceiver(currentChat, auth.user)),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(employees
                      .getName(chat.findReceiver(currentChat, auth.user))),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(correctStringAmount(
                      messages.lastMessage(currentChat.chatID).message,
                      messages.lastMessage(currentChat.chatID).senderID,
                      auth.user)),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 15.0, bottom: 20),
            child: Container(
              child: Text(
                  "${DateFormat.MMMd().format(messages.lastMessage(currentChat.chatID).sentTime)}"),
            ),
          ),
        ],
      ),
    );
  }
}
