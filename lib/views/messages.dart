import 'package:flutter/material.dart';
import 'package:Zlay/views/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Zlay/repository/services.dart';
import 'package:Zlay/widgets/ProfileMenu.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:simple_moment/simple_moment.dart';

// Message Screen
class MessageScreen extends StatefulWidget {

  @override
  _MessageScreen createState() => _MessageScreen();
}
class _MessageScreen extends State<MessageScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  ListView chatHistoryListView (chatHistoryUsers){
    return ListView.builder(
      itemCount: chatHistoryUsers.length,
      itemBuilder: (context, index){
        return buildChatHistoryList(chatHistoryUsers[index]);
      },
    );
  }

  Widget buildChatHistoryList(chatHistory){
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide( //                   <--- left side
            color: Colors.black12,
            width: 1.0,
          ),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 45.0,
          height: 45.0,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(chatHistory['avatar']),
              )
          ),
        ),
        title: Container(
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text('${chatHistory['names']}', style: TextStyle(fontSize: 14.0)),
              ),
              Container(
                child: Text(chatHistory['last_chat']['createdAt']),
              )
            ],
          ),
        ),
        subtitle: Text(chatHistory['last_chat']['body'], style: TextStyle(fontSize: 12)),
        dense: true,
        onTap: () async {
          print('To chat screen');
          var prefs = await SharedPreferences.getInstance();
          var receiverId = chatHistory['_id'];
          var senderId = prefs.getString('_userId');
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(senderId: senderId, receiverId: receiverId)));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ProfileMenuBarNoOption(),
          Expanded(
            child: FutureBuilder(
                future: fetchChatHistory(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List chatHistory = snapshot.data;
                    print(chatHistory);
                    return  chatHistoryListView(chatHistory);
                  } else if(snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(
                    child: ShowLoader(),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}