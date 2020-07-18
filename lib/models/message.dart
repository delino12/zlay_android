import 'package:flutter/material.dart';
import 'package:Zlay/views/chat.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Zlay/repository/services.dart';

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

  ListView followerListView (follower){
    return ListView.builder(
      itemCount: follower.length,
      itemBuilder: (context, index){
        return buildFollowerList(follower[index]);
      },
    );
  }

  Widget buildFollowerList(follower){
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
          var receiverId = follower['user']['_id'];
          var senderId = prefs.getString('_userId');
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(senderId: senderId, receiverId: receiverId)));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchFollowers(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List followers = snapshot.data;
            return  followerListView(followers);
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