import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Zlay/widgets/loader.dart';

class Notification {
  Map media;
  Map by;
  String message;

  Notification({
    this.media,
    this.by,
    this.message
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
        media: json['media'],
        by: json['by'],
        message: json['message'],
    );
  }
}

class NotificationList extends StatefulWidget {
  // all notifications
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList>{
  var notifications = const [];

  Future __fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('_userId');

    final response = await http.get('http://zlayit.net/notifications?user_id=${userId}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      List collections = json.decode(response.body)['data'];
      print(collections);
      return collections;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load notifications from API');
    }
  }

  void initState(){
    super.initState();
  }

  ListView __notificationListView (notifications){
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index){
        return __buildNotificationList(notifications[index]);
      },
    );
  }

  Widget __buildNotificationList(notification){
    return Container(
      child: Container(
        padding: EdgeInsets.all(5),
        child: ListTile(
          leading: Container(
            width: 45.0,
            height: 45.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(notification['by']['avatar']),
                )
            ),
          ),
          title: Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Text(notification['message'], style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                ),
                Container(
                  child: Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(notification['media']['media_url']),
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
          subtitle: Container(
            child: Row(
              children: <Widget>[
//                Text('2 mins ago', style: TextStyle(fontSize: 12.0)),
              ],
            ),
          ),
          dense: true,
          onTap: (){
            print('Reply Messages');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: __fetchNotifications(),
        builder: (context, snapshot){
          if(snapshot.hasData){
             List notifications = snapshot.data;
             return  __notificationListView(notifications);
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