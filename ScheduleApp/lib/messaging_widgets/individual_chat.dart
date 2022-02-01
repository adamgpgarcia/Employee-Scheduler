import 'package:flutter/material.dart';
import '../providers/messages.dart';
import '../providers/auth.dart';
import '../providers/chats.dart';
import '../providers/employees.dart';
import 'package:provider/provider.dart';
import './message_bubble.dart';
import 'dart:async';
import 'dart:math' as math;

//the search bar allows the user to pick which employee they want to send a message too, drop down list selection
class SearchBar extends StatefulWidget {
  final ChatModel chatItem;
  final Function setLocalChat;

  SearchBar(this.chatItem, this.setLocalChat);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  //final _searchFocusNode = FocusNode();

  //this function sets the current chat
  void _pickUser(int receiverId, int userId, var chat) {
    widget.setLocalChat(receiverId, userId, chat);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchTextController.dispose();
    super.dispose();
  }

  bool searchDropdown = true;
  TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final employeeLink = Provider.of<Employees>(context, listen: false);
    final employeeList = employeeLink.contactList();
    var auth = Provider.of<Auth>(context, listen: false);
    var chat = Provider.of<Chats>(context, listen: false);

    //formatting and styling
    return Column(
      children: <Widget>[
        searchDropdown
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 12),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Center(
                    child: TextField(
                      //initialValue: _initValues['description'],
                      controller: searchTextController,
                      onTap: () {
                        setState(() {
                          searchDropdown = !searchDropdown;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(bottom: 40 / 2, left: 20),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Colors.grey[800]), //color: Colors.transparent
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[800]),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        hintText: "Select Name",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            : Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.zero),
                      ),
                      child: Center(
                        child: TextField(
                          controller: searchTextController,
                          onTap: () {
                            setState(() {
                              searchDropdown = !searchDropdown;
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 40 / 2, left: 20),
                              hintStyle: TextStyle(fontSize: 17),
                              hintText: 'Send to',
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0)),
                      ),
                      height: 150,
                      child: ListView.builder(
                          reverse: true,
                          itemCount: employeeList.length,
                          itemBuilder: (ctx, i) {
                            return Container(
                              child: GestureDetector(
                                onTap: () {
                                  searchTextController.text =
                                      "${employeeList[i].firstName} ${employeeList[i].lastName}";
                                  _pickUser(employeeList[i].employeeID,
                                      auth.user, chat);
                                  setState(() {
                                    searchDropdown = !searchDropdown;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "${employeeList[i].firstName}  ${employeeList[i].lastName}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

//returns the user id of the person in the chat
int chatMember(ChatModel args, auth) {
  int temp;
  for (int i = 0; i < args.recipients.length; i++) {
    if (auth.user != args.recipients[i]) {
      temp = args.recipients[i];
      return temp;
    }
  }
  return temp;
}

class IndividualChatScreen extends StatefulWidget {
  static const routeName = '/individual-chat';

  @override
  _IndividualChatScreenState createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final _messageController = TextEditingController();

  int currentReceiver;

  //sets local chat
  void setLocalChat(int receiverId, int userId, var chat) {
    if (chat.inChatWith(userId, receiverId)) {
      int temp = chat.inChatWithID(userId, receiverId);
      ChatModel temper = chat.inChatWithChat(temp);
      currentReceiver = receiverId;
      print(temper.recipients);
      print(temper.chatID);
      setState(() {
        tempChat = temper;
      });
    } else {
      setState(() {
        currentReceiver = receiverId;
        tempChat.recipients.add(userId);
        tempChat.recipients.add(receiverId);
      });
    }
  }

  bool initChat = false;

  List<MessageModel> messageList = [];

  ChatModel tempChat;

  @override
  Widget build(BuildContext context) {
    ChatModel args;
    final auth = Provider.of<Auth>(context, listen: false);
    final chat = Provider.of<Chats>(context, listen: false);
    final employees = Provider.of<Employees>(context, listen: false);
    final messages = Provider.of<Messages>(context);
    messages.getMessages(auth.token);

    if (initChat == false) {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
        tempChat = args;
        initChat = true;
      });
    }

    print(tempChat.chatID);

    //function checks if null
    bool isNull() {
      if (tempChat.chatID == 0) {
        return true;
      }
      return false;
    }

    if (!isNull()) {
      currentReceiver = chat.findReceiver(tempChat, auth.user);
      messageList = messages.getChatMessages(tempChat.chatID);
    } else {
      // print("chatID ==null");
    }

    //this function sends the message
    Future<void> createChatnMessage() async {
      final enteredMessage = _messageController.text;

      int tempChatID = await chat.createChat(tempChat, auth.token);

      messages.sendMessage(
        MessageModel(
          messageID: null,
          chatID: tempChatID,
          senderID: auth.user,
          receiverID: currentReceiver,
          sentTime: DateTime.now(),
          message: enteredMessage,
          notification: false,
        ),
        auth.token,
      );
    }

    //this function submits the message
    void _submitMessage() {
      final enteredMessage = _messageController.text;
      //final enteredAmount = double.parse(_amountController.text);

      if (enteredMessage.isEmpty) {
        // checks for title input and non negitive amount
        return; // returns and does not exacute addTransaction
      }

      if (tempChat.chatID != 0) {
        messages.sendMessage(
          MessageModel(
            messageID: null,
            chatID: tempChat.chatID,
            senderID: auth.user,
            receiverID: currentReceiver,
            sentTime: DateTime.now(),
            message: enteredMessage,
            notification: false,
          ),
          auth.token,
        );
      } else if (messages.sharedMessages(auth.user, currentReceiver) != null) {
        ChatModel temp = chat.inChatWithChat(
            messages.sharedMessages(auth.user, currentReceiver));
        chat.rejoinChat(auth.token, temp, auth.user);

        messages.sendMessage(
          MessageModel(
            messageID: null,
            chatID: chat.inChatWithID(auth.user, currentReceiver),
            senderID: auth.user,
            receiverID: currentReceiver,
            sentTime: DateTime.now(),
            message: enteredMessage,
            notification: false,
          ),
          auth.token,
        );
      } else {
        createChatnMessage();
      }

      FocusScope.of(context).unfocus();
      _messageController.clear();
      Navigator.of(context).pop();
    }

    //formatting and styling
    return Scaffold(
      appBar: AppBar(
        title: !isNull()
            ? Text(employees.getName(chatMember(tempChat, auth)))
            : Text("Send to"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: <Widget>[
            !isNull() ? Text("") : SearchBar(tempChat, setLocalChat),
            Container(
              child: Expanded(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messageList.length,
                    itemBuilder: (ctx, i) {
                      return MessageBubble(messageList[i]);
                    }),
              ),
            ),
            Container(
              height: 10,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        child: TextField(
                          controller: _messageController,
                          cursorHeight: 20,
                          autofocus: true,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 40 / 2, left: 20),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .grey[800]), //color: Colors.transparent
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[800]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            hintText: "Input message",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ButtonTheme(
                      minWidth: 70,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.green[500],
                        shape: StadiumBorder(),
                        onPressed: () {
                          _submitMessage();
                        },
                        child: Transform.rotate(
                          angle: 350 * math.pi / 180,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
