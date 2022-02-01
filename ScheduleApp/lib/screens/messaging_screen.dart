import 'package:ScheduleApp/messaging_widgets/chat_card.dart';
import '../providers/messages.dart';
import '../providers/auth.dart';
import '../messaging_widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chats.dart';
import '../messaging_widgets/individual_chat.dart';

//this widget shows the chat thread screen, and allows user to delete chat thread
class MessagingScreen extends StatefulWidget {
  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  var _isInit = true;

  var _isLoading = false;

  @override
  void didChangeDependencies() {
    var auth = Provider.of<Auth>(context, listen: false);
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Messages>(context).getMessages(auth.token).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context, listen: false);
    int currentUser = auth.user;

    Provider.of<Chats>(context, listen: false).getChats(auth.token);

    List<ChatModel> currentChats =
        Provider.of<Chats>(context).openChats(auth.user);

    //formatting and styling
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(IndividualChatScreen.routeName,
                  arguments: ChatModel(chatID: 0, recipients: []));
            }, //selectScreen(context), //must make this an ananoymoys function to pass context as a parameter, reason cant have function() sitting by itself otherwise it would run on runtime
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Container(
                  child: Expanded(
                    child: ListView.builder(
                        itemCount: currentChats.length,
                        itemBuilder: (ctx, i) {
                          return Dismissible(
                            key: ValueKey(currentChats[i].chatID),
                            background: Container(
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 40,
                              ),
                              alignment: Alignment.centerRight,
                            ),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) {
                              return showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Are you sure?'),
                                  content: Text(
                                      'Delete your chat with ?'), //${employees.getName(currentChats[i].chatID)}
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Confirm'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {
                              Provider.of<Chats>(context, listen: false)
                                  .deleteChat(
                                      auth.token, currentChats[i], auth.user);
                            },
                            child: GestureDetector(
                              onTap: () {
                                //if(currentChats[i].senderID == currentUser){
                                Navigator.of(context).pushNamed(
                                    IndividualChatScreen.routeName,
                                    arguments: currentChats[i]);
                              },
                              child: Container(
                                width: double.infinity,
                                child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      ChatCard(currentChats[i]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
    );
  }
}
