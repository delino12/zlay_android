import 'package:flutter/material.dart';
import 'package:Zlay/repository/services.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:bubble/bubble.dart';
import 'package:emoji_picker/emoji_picker.dart';

// Chat Messages Screen
class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String senderId;
  ChatScreen({Key key, this.receiverId, this.senderId}) : super(key: key);

  @override
  _ChatScreen  createState() => _ChatScreen();
}
class _ChatScreen extends State<ChatScreen> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var chatTextController = TextEditingController();
  var chatConversations;
  String senderId;
  String receiverId;
  bool isShowSticker;

  @override
  void initState() {
    super.initState();
    senderId = this.widget.senderId;
    receiverId = this.widget.receiverId;
    isShowSticker = false;
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  Future<void> refreshChatArea() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      chatConversations = fetchChat(senderId, receiverId);
    });
  }

  void dispose(){
    chatTextController.dispose();
    super.dispose();
  }

  // chat title area
  Widget _chatTitleArea(context) {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.transparent,
      margin: EdgeInsets.all(9),
      child: FutureBuilder(
        future: loadChatUserProfile(receiverId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var chatUserProfile = snapshot.data;
            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
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
                )
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
      child: FutureBuilder(
          future: fetchChat(senderId, receiverId),
          builder: (context, snapshot){
            if(snapshot.hasData){
              List chatConversations = snapshot.data;
              return RefreshIndicator(
                key: refreshKey,
                onRefresh: refreshChatArea,
                child: chatListView(chatConversations)
              );
            } else if(snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
              child: ShowLoader(),
            );
          }
      ),
    );
  }

  // chat input area
  Widget _chatInputArea(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      padding: EdgeInsets.fromLTRB(0,0,0,10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: 25,
              margin: EdgeInsets.all(5),
              child: Icon(Icons.mood, size: 28, color: Colors.grey[700]),
            ),
            onTap: (){
              print('clicking something');
//              setState(() {
//                isShowSticker = !isShowSticker;
//              });
            },
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: TextField(
              controller: chatTextController,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 5, bottom: 1, top: 1, right: 5),
                  hintText: 'Type a message...'
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.fromLTRB(5,5,10,5),
              child: Icon(Icons.send, color: Colors.grey[700]),
            ),
            onTap: () async {
              var message = chatTextController.text;
              if(message == ""){
                // do not send
              }else{
                await sendChat(message, senderId, receiverId);
                setState(() {
                  chatConversations = fetchChat(senderId, receiverId);
                });
                chatTextController.text = "";
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildSticker() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: ["racing", "horse"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        print(emoji);
      },
    );
  }

  // sender chat message call out
  Widget senderChat(message){
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightTop,
      color: Colors.blueAccent,
      child: Column(
        children: [
          Text('${message['message']['body']}', textAlign: TextAlign.right, style: TextStyle(color: Colors.white)),
          Text('${message['message']['createdAt']}', textAlign: TextAlign.right, style: TextStyle(color: Colors.white70, fontSize: 10))
        ],
      ),
    );
  }

  // receiver chat message call out
  Widget receiverChat(message){
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftTop,
      child: Column(
        children: [
          Text('${message['message']['body']}', style: TextStyle(color: Colors.black54)),
          Text('${message['message']['createdAt']}', style: TextStyle(color: Colors.black45, fontSize: 10))
        ],
      ),
    );
  }

  // chat messages positions
  ListView chatListView(messages){
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index){
        if(messages[index]['from']['_id'] == senderId){
          return Container(
            margin: EdgeInsets.fromLTRB(45, 1, 8, 1),
            child: senderChat(messages[index]),
          );
        }else{
          return Container(
            margin: EdgeInsets.fromLTRB(8, 1, 45, 1),
            child: receiverChat(messages[index]),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: WillPopScope(
              child: Stack(
              children: [
                Image.asset("assets/images/zlay_chat_bg.png",
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: <Widget>[
                    _chatTitleArea(context),
                    _chatMessageArea(context),
                    _chatInputArea(context)
                  ],
                ),
              ],
            ),
            onWillPop: onBackPress,
          )
        ),
      ),
    );
  }
}