import 'package:flutter/material.dart';
import 'package:Zlay/repository/services.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:Zlay/views/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Favorite Screen
class Follower extends StatefulWidget {

  @override
  _Follower createState() => _Follower();
}
class _Follower extends State<Follower> {

  @override
  void initState() {
    // TODO: implement initState
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
            var receiverId = follower['user']['_id'];
            var senderId = prefs.getString('_userId');
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(senderId: senderId, receiverId: receiverId)));
          },
        ),
      ),
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
              Container(
                width: double.infinity,
                height: 55,
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                        padding: EdgeInsets.all(9),
                        child: Row(
                          children: <Widget>[
                            Center(
                                child: Text('Followers',
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)
                                )
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}