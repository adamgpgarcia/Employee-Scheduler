//import 'package:ScheduleApp/models/message_model.dart';
import 'package:flutter/material.dart';
import '../providers/messages.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {

  final MessageModel message;

  MessageBubble(this.message);

  bool isCurrentUser(int currentUser, int sender){
    if(currentUser == sender){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    int currentUser = Provider.of<Auth>(context, listen: false).user;
    return Row(

      mainAxisAlignment: isCurrentUser(currentUser, message.receiverID) ? MainAxisAlignment.start :  MainAxisAlignment.end,
      children: <Widget> [
        Container(
            
            child: Column(
              children: [
                Container(
                
                decoration: BoxDecoration(
                  color: isCurrentUser(currentUser, message.receiverID) ? Colors.teal[300] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(18),
                ),
                width: 160,
                padding: EdgeInsets.symmetric(
                  vertical:10,
                  horizontal:16,
                ),
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2,),
                child: Text(message.message)
          ),
                Text("${DateFormat.MMMd().format(message.sentTime)} - ${DateFormat("h:mma").format(message.sentTime)}"),
              ],
            ),
        ),
      ],
    );
  }
}



