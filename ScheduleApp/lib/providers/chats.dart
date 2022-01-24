import 'package:ScheduleApp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';


class ChatModel{
  int chatID;
  List <int> recipients;

  ChatModel({
    @required this.chatID,
    @required this.recipients
  });
}

class Chats with ChangeNotifier{
  List<ChatModel> _chatList = [];

  List<ChatModel> get items {
    return [..._chatList]; // ... is the spread operator
  }

   List <ChatModel> openChats(int userID){
     return _chatList.where((tx) {
      return tx.recipients.contains(userID);
    }).toList();
   }

   bool inChatWith(int userID, int otherUser){
    bool isInChatWith = false;
    
    for(int i = 0; i < _chatList.length; i ++){
      if(_chatList[i].recipients.contains(userID) && _chatList[i].recipients.contains(otherUser)){
        isInChatWith = true;
      }
    }  
     return isInChatWith;
   }

   int inChatWithID(int userID, int otherUser){
    int isInChatWithID;
    
    for(int i = 0; i < _chatList.length; i ++){
      if(_chatList[i].recipients.contains(userID) && _chatList[i].recipients.contains(otherUser)){
        isInChatWithID = _chatList[i].chatID;
      }
    }  
     return isInChatWithID;
   }

  //  rejoinChat(int userId, int receiverId){
     
  //    get chat id 
  //    add user id to list
  //    return tempChat;

  //  }


  ChatModel inChatWithChat(int chatID){
    ChatModel tempChat;
    
      for(int i = 0; i < _chatList.length; i ++){
        if(_chatList[i].chatID == chatID){ 
          tempChat = _chatList[i];
        }
      }  
      return tempChat;
   }

  Future<void>getChats(String token) async {
    var headers = {
      'Content-Type' : 'application/json',
      'Authorization' : "token $token",

    };
    const url = 'http://35.233.225.216:8000/chat/';
    try{
      final response = await http.get(url, headers: headers);
      final loadedData = json.decode(response.body) as List<dynamic>;
      final List<ChatModel> chatList = [];

      for(int i = 0; i < loadedData.length; i++){
          
          // print(loadedData[i]['chatID']);
          // print((loadedData[i]['recipients']).map((s) => s as int).toList().runtimeType);

          
          var temp = ChatModel(
             chatID: loadedData[i]['chatID'],
             recipients : (loadedData[i]['recipients']).cast<int>(),
          );
          chatList.add(temp);
      }

      _chatList = chatList;
      notifyListeners();     
    } 
    catch(error){
      throw(error);
    }
  }

  Future<int> createChat(ChatModel chat, String token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "token $token",
    };
    //DateTime tempTime = message.sentTime;
    //String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(tempTime);
    const url = 'http://35.233.225.216:8000/chat/';

    return http
        .post(
      url,
      headers: headers,
      body: json.encode({
        'recipients': chat.recipients,
      }),
    ).then((response) {
      final newChat = ChatModel(
        chatID: json.decode(response.body)['chatID'],
        recipients: chat.recipients,
       
      );
      _chatList.add(newChat);
      //_items.insert(0, newProduct); //insert at the begining of the list
      notifyListeners();
      // print("New chat future:${newChat.chatID}");
      
      return newChat.chatID;
    }).catchError((onError) {
      throw onError;
    });
  }

  Future<void>deleteChat(String token, ChatModel chat, int userID) async {

    chat.recipients = removeFromChat(chat, userID);

    var headers = {
      'Content-Type' : 'application/json',
      'Authorization' : "token $token",

    };

    final chatIndex = _chatList.indexWhere((item) => item.chatID == chat.chatID);
    try{
      final url = 'http://35.233.225.216:8000/chat/${chat.chatID}/';
      await http.put(url, headers: headers, body: json.encode({
        'chatID' : chat.chatID,
        'recipients' : chat.recipients,
      }));
  
      _chatList[chatIndex] = chat;
      notifyListeners();     
    } 
    catch(error){
      throw(error);
    }
  }

  Future<void>rejoinChat(String token, ChatModel chat, int userID) async {

    chat.recipients = addToChat(chat, userID);

    var headers = {
      'Content-Type' : 'application/json',
      'Authorization' : "token $token",

    };

    final chatIndex = _chatList.indexWhere((item) => item.chatID == chat.chatID);
    try{
      final url = 'http://35.233.225.216:8000/chat/${chat.chatID}/';
      await http.put(url, headers: headers, body: json.encode({
        'chatID' : chat.chatID,
        'recipients' : chat.recipients,
      }));
  
      _chatList[chatIndex] = chat;
      notifyListeners();     
    } 
    catch(error){
      throw(error);
    }
  }

  int findReceiver(ChatModel args, int currentUser) {
    int receiver;
    for (int i = 0; i < args.recipients.length; i++) {
      if (args.recipients[i] != currentUser) {
        receiver = args.recipients[i];
      }
    }
    return receiver;
  }

  List <int> removeFromChat(ChatModel chat,int userID){
    List <int> tempRecipients = chat.recipients;

    tempRecipients.removeWhere((element) => element == userID);
    
    return tempRecipients;
  }

  List <int> addToChat(ChatModel chat,int userID){
    List <int> tempRecipients = chat.recipients;

    tempRecipients.add(userID);
    
    return tempRecipients;
  }

  // List <int> othersInChat(int currentUser, int currentChat){
  //   List <int> otherUserList = [];
  //   for(int i = 0; i < _chatList.length; i++){
  //     if(_chatList[i].chatID == currentChat){
  //       for(int j =0; j < _chatList[i].recipients.length; j++){
  //         if(_chatList[i].recipients[j] != currentUser){
  //           otherUserList.add(_chatList[i].recipients[j]);
  //         }
  //       }
  //     }
  //   } 
  //   return otherUserList;
  // }
}