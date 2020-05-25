import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:Zlay/views/chat.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Follower {
  String id;
  String userId;
  String followingId;
  int status;
  String createdAt;
  String updatedAt;
  Map user;

  Follower({
    this.id,
    this.userId,
    this.followingId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: json['id'],
      userId: json['user_id'],
      followingId: json['following_id'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: json['user'],
    );
  }
}

class FollowerList extends StatefulWidget {
  @override
  _FollowerList createState() => _FollowerList();
}

class _FollowerList extends State<FollowerList> {
  var followers = const [];

  void initState(){
    super.initState();
  }

  Future __fetchFollower() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('_userId');

    final response = await http.get('http://zlayit.net/follower?user_id=${userId}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      List collections = json.decode(response.body)['data'];
      return collections;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load notifications from API');
    }
  }

  ListView __followerListView (follower){
    return ListView.builder(
      itemCount: follower.length,
      itemBuilder: (context, index){
        return __buildFollowerList(follower[index]);
      },
    );
  }

  Widget __buildFollowerList(follower){
    return Container(
      child: ListTile(
        leading: Container(
          width: 45.0,
          height: 45.0,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(follower['user']['avatar']),
              )
          ),
        ),
        title: Container(
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text('${follower['user']['names']}', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
              ),
              Container(
//                  child: Icon(Icons.more_vert, size: 12),
              )
            ],
          ),
        ),
        subtitle: Text(follower['user']['username'], style: TextStyle(fontSize: 12)),
        dense: true,
        onTap: () async {
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('receiver_id', follower['user']['_id']);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: __fetchFollower(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List followers = snapshot.data;
            return  __followerListView(followers);
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