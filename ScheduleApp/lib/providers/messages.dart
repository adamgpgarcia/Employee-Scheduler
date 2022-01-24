import 'package:ScheduleApp/main.dart';
import 'package:ScheduleApp/providers/chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
//import 'package:http/http.dart' as http;
//import 'dart:convert';



class MessageModel {
  final int messageID;
  final int chatID;
  final int senderID;
  final int receiverID;
  final DateTime sentTime;
  final String message;
  final bool notification;

  MessageModel({
    @required this.messageID,
    @required this.chatID,
    @required this.senderID,
    @required this.receiverID,
    @required this.sentTime,
    @required this.message,
    @required this.notification,
  });
}

class ChatArguments {
  final int userId;
  int senderId;

  ChatArguments(this.userId, this.senderId);
}

class Messages with ChangeNotifier {
  List<MessageModel> _messageList = [];

  int get messageCount {
    return _messageList.length;
  }

  List<MessageModel> findById(int userId, int senderId) {
    return _messageList.where((element) {
      return (element.receiverID == userId && element.senderID == senderId) ||
          (element.receiverID == senderId && element.senderID == userId);
    }).toList();
  }

  int sharedMessages(int userId, int receipientId) {    
     MessageModel sharedMessage;
    for(int i = 0; i < _messageList.length; i ++){
      if((_messageList[i].senderID == userId && _messageList[i].receiverID == receipientId) || (_messageList[i].receiverID == userId && _messageList[i].senderID == receipientId)){
        sharedMessage = _messageList[i];
        
        break;
      }
      
    }
    if(sharedMessage == null){
      return null;
    }else{
      return sharedMessage.chatID;
    }
    
  }

  

  //deletes all messages from a certain user

  List<MessageModel> getChatMessages(int id) {
    List tempMessages = [];
    tempMessages =
        _messageList.where((element) => (element.chatID == id)).toList();
    tempMessages.sort((a, b) => b.sentTime.compareTo(a.sentTime));
    return tempMessages;
  }

  // void addMessage(MessageModel temp){
  //   print("in addmessage");
  //   _messageList.add(temp);
  //   notifyListeners();
  // }

  List<MessageModel> get items {
    return [..._messageList]; // ... is the spread operator
  }

  bool inList(MessageModel temp, List<MessageModel> tempList) {
    bool isIn = false;
    for (var message in tempList) {
      if (temp.senderID == message.senderID) {
        isIn = true;
      }
    }
    return isIn;
  }

  List<MessageModel> inListNewer(
      MessageModel temp, List<MessageModel> tempList) {
    for (int i = 0; i < tempList.length; i++) {
      if (temp.senderID == tempList[i].senderID) {
        if (tempList[i].sentTime.isBefore(temp.sentTime)) {
          tempList[i] = temp;
        }
      }
    }
    return tempList;
  }

  MessageModel lastMessage(int chatNumber) {
    List<MessageModel> tempMessages = [];
    var last;
    tempMessages = _messageList
        .where((element) => (element.chatID == chatNumber))
        .toList();
    tempMessages.sort((a, b) => a.sentTime.compareTo(b.sentTime));

    for (int i = 0; i < tempMessages.length; i++) {
      last = tempMessages[i];
    }

    if (last == null) {
      last = _messageList[0];
    }
    return last;
  }

  List<MessageModel> openChats(int currentUser) {
    List<MessageModel> chats = [];

    for (var message in _messageList) {
      if (message.receiverID == currentUser ||
          message.senderID == currentUser) {
        if (!inList(message, chats)) {
          chats.add(message);
        } else if (inList(message, chats)) {
          chats = inListNewer(message, chats);
        }
      }
    }
    return chats;
  }

  Future<void> getMessages(String token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "token $token",
    };
    const url = 'http://35.233.225.216:8000/message/';
    try {
      final response = await http.get(url, headers: headers);
      final loadedData = json.decode(response.body) as List<dynamic>;
      final List<MessageModel> messageList = [];

      for (int i = 0; i < loadedData.length; i++) {
        var temp = MessageModel(
          messageID: loadedData[i]['messageID'],
          chatID: loadedData[i]['chatID'],
          senderID: loadedData[i]['senderID'],
          receiverID: loadedData[i]['receiverID'],
          sentTime: DateTime.parse("${loadedData[i]['sentTime']}"),
          message: loadedData[i]['message'],
          notification: loadedData[i]['notification'],
        );
        messageList.add(temp);
      }

      _messageList = messageList;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> sendMessage(MessageModel message, String token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "token $token",
    };
    DateTime tempTime = message.sentTime;
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(tempTime);
    const url = 'http://35.233.225.216:8000/message/';

    return http
        .post(
      url,
      headers: headers,
      body: json.encode({
        'chatID': message.chatID,
        'senderID': message.senderID,
        'receiverID': message.receiverID,
        'sentTime': formattedDate,
        'message': message.message,
        'notification': message.notification,
      }),
    ).then((response) {
      final newMessage = MessageModel(
        messageID: json.decode(response.body)['id'],
        chatID: message.chatID,
        senderID: message.senderID,
        receiverID: message.receiverID,
        sentTime: message.sentTime,
        message: message.message,
        notification: false,
      );
      _messageList.add(newMessage);
      //_items.insert(0, newProduct); //insert at the begining of the list
      notifyListeners();
    }).catchError((onError) {
      throw onError;
    });
  }
}


