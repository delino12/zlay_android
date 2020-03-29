import 'package:flutter/material.dart';
import 'package:Zlay/repository/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Zlay/widgets/loader.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future loadChatUserProfile() async {
  var prefs =  await SharedPreferences.getInstance();
  final String userId = prefs.getString('receiver_id');
  final response = await http.get('http://zlayit.net/user/${userId}');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    var collections = json.decode(response.body)['data'];
    print(collections);
    return collections;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load notifications from API');
  }
}

// Chat Messages Screen
class ChatScreen extends StatefulWidget {
  final String title;
  ChatScreen({Key key, this.title}) : super(key: key);

  @override
  _chatScreenState  createState() => _chatScreenState();
}

class _chatScreenState extends State<ChatScreen> {

  @override
  void initState(){
    super.initState();
  }

  // chat input area
  Widget _chatInputArea(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[100],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      padding: EdgeInsets.fromLTRB(0,0,0,10),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            child: Icon(Icons.mood, color: Colors.grey[700]),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: Icon(Icons.camera_alt, color: Colors.grey[700]),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: Icon(Icons.videocam, color: Colors.grey[700]),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: TextField(
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 5, bottom: 1, top: 1, right: 5),
                  hintText: 'Type a message...'
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5,5,10,5),
            child: Icon(Icons.send, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  // chat title area
  Widget _chatTitleArea(context) {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.white,
      margin: EdgeInsets.all(9),
      child: FutureBuilder(
        future: loadChatUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var chatUserProfile = snapshot.data;
            return Row(
              children: <Widget>[
                Container(
                  width: 45.0,
                  height: 45.0,
                  child: GestureDetector(
                    child: Icon(Icons.arrow_back),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: 45.0,
                  height: 45.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(chatUserProfile['user']['avatar']),
                      )
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(9),
                    child: Row(
                      children: <Widget>[
                        Center(
                            child: Text(chatUserProfile['user']['names'],
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)
                            )
                        ),
                      ],
                    )
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: ShowLoader(),
          );
        },
      ),
    );
  }

  // chat message area
  Widget _chatMessageArea(context) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: ChatConversation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _chatTitleArea(context),
              _chatMessageArea(context),
              _chatInputArea(context)
            ],
          ),
        ),
      ),
    );
  }
}