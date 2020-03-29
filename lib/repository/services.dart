import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bubble/bubble.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Zlay/widgets/loader.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DisplayNotification extends StatefulWidget {

  @override
  _displayNotificationState createState() => _displayNotificationState();
}

class _displayNotificationState extends State<DisplayNotification> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState(){
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings);
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails('channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, 'New Video is out', 'Flutter Local Notification', platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  @override
  Widget build(BuildContext context) {
    return showNotification();
  }
}

class FirebaseNotifications {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();
    _firebaseMessaging.getToken().then((token) {
      print('Device token: ');
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        var android = new AndroidNotificationDetails('channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
            priority: Priority.High,importance: Importance.Max
        );
        var iOS = new IOSNotificationDetails();
        var platform = new NotificationDetails(android, iOS);

        await flutterLocalNotificationsPlugin.show(
            0,
            'New Video is out',
            'Flutter Local Notification',
             platform,
            payload: 'Nitish Kumar Singh is part time Youtuber');
        print('Notification on active screen');
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('Resume screen');
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('On launch screen');
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}

// init chat conversation class
class ChatConversation extends StatefulWidget {

  // create state
  @override
  chatConversation createState() => chatConversation();
}

// extend class with state
class chatConversation extends State<ChatConversation> {
  String senderId;
  String receiverId;

  // fetch chat from api
  Future fetchChat() async {
    final prefs = await SharedPreferences.getInstance();
    senderId = prefs.getString('_userId');
    receiverId = prefs.getString('receiver_id');

    print('sender id: ${senderId}');
    print('receiver id: ${receiverId}');

    final response = await http.get('http://zlayit.net/chats?sender_id=${senderId}&receiver_id=${receiverId}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      List collections = json.decode(response.body)['data'];
      return collections;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load notifications from API');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  // sender chat message callout
  Widget __senderChat (message){
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightTop,
      color: Colors.blueAccent,
      child: Text('${message['message']['body']}', textAlign: TextAlign.right, style: TextStyle(color: Colors.white)),
    );
  }

  // reciever chat message callout
  Widget __receiverChat (message){
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftTop,
      child: Text('${message['message']['body']}'),
    );
  }

  ListView __chatListView (messages){
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index){
        if(messages[index]['from']['_id'] == senderId){
          return Container(
            margin: EdgeInsets.fromLTRB(45, 1, 8, 1),
            child: __senderChat(messages[index]),
          );
        }else{
          return Container(
            margin: EdgeInsets.fromLTRB(8, 1, 45, 1),
            child: __receiverChat(messages[index]),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchChat(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List chatMessages = snapshot.data;
            return __chatListView(chatMessages);
          } else if(snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: ShowLoader(),
          );
        }
    );
  }
}