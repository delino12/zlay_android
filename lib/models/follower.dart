import 'package:flutter/material.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:Zlay/views/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Zlay/repository/services.dart';

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
      child: Container(
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
                  child: Text('@${follower['user']['username']} is now following you', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                ),
                Container(
                  child: Icon(Icons.more_vert, size: 12),
                )
              ],
            ),
          ),
          subtitle: Text('Send instant message', style: TextStyle(fontSize: 12)),
          dense: true,
          onTap: () async {
            var prefs = await SharedPreferences.getInstance();
            prefs.setString('receiver_id', follower['user']['_id']);
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
          },
        ),
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