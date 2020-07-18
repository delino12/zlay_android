import 'package:flutter/material.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Zlay/repository/services.dart';
import 'package:Zlay/views/chat.dart';

class FollowingList extends StatefulWidget {
  @override
  _FollowingList createState() => _FollowingList();
}
class _FollowingList extends State<FollowingList> {
  var followings = const [];

  void initState(){
    super.initState();
  }


  ListView followingListView (following){
    return ListView.builder(
      itemCount: following.length,
      itemBuilder: (context, index){
        return buildFollowingList(following[index]);
      },
    );
  }

  Widget buildFollowingList(following){
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
                  image: NetworkImage(following['user']['avatar']),
                )
            ),
          ),
          title: Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Text('You are now following @${following['user']['username']}', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                ),
                Container(
                  child: Icon(Icons.more_vert, size: 12),
                )
              ],
            ),
          ),
          subtitle: Text(following['user']['names'], style: TextStyle(fontSize: 12)),
          dense: true,
          onTap: () async {
            var prefs = await SharedPreferences.getInstance();
            var receiverId = following['user']['_id'];
            var senderId = prefs.getString('_userId');
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(senderId: senderId, receiverId: receiverId)));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchFollowings(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List notifications = snapshot.data;
            return  followingListView(notifications);
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