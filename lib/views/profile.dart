import 'package:flutter/material.dart';
import 'package:Zlay/models/user.dart';
import 'package:Zlay/widgets/ProfileMenu.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:Zlay/models/profile.dart';
import 'package:Zlay/models/userPost.dart';

// Profile Screen
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() => _ProfileScreen();
}
class _ProfileScreen extends State<ProfileScreen> {

  var profile;

  @override
  void initState(){
    super.initState();
    profile = loadUsersList();
  }

  Widget _profileDetails(profile){
    return SizedBox(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(1),
            height: 96,
            width: 96,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent
            ),
            child: Container(
              padding: EdgeInsets.all(15),
              height: 96,
              width: 96,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(profile['user']['avatar']),
                  )
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0,15,0,5),
            child: Text(profile['user']['names'], style: TextStyle(fontSize: 18)),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text('@${profile['user']['username']}'),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Icon(Icons.edit),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15,5,15,5),
                      child: Text('Posts'),
                    ),
                    Text('${profile['timeline']}')
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15,5,15,5),
                      child: Text('Followers'),
                    ),
                    Text('${profile['followers']}')
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15,5,15,5),
                      child: Text('Following'),
                    ),
                    Text('${profile['following']}')
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileRecentPosts(recentPost){
    return Expanded(
      child: new StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: recentPost.length,
        itemBuilder: (BuildContext context, int index){
          if(recentPost[index]['media']['media_type'] == 1){
            return Container(
              height: 400,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(recentPost[index]['media']['media_url']),
                  )
              ),
            );
          }else{
            return Container(
              height: 400,
              decoration: new BoxDecoration(

              ),
            );
          }
        },
        staggeredTileBuilder: (int index) =>
        new StaggeredTile.count(2, index.isEven ? 2 : 1),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProfileMenuBar(),
              Container(
                child: FutureBuilder(
                  future: loadUsersList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var profile = snapshot.data;
                      return _profileDetails(profile);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(
                      child: ShowLoader(),
                    );
                  },
                ),
              ),
              Container(
                child: FutureBuilder(
                  future: loadUserRecentPost(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var recentPost = snapshot.data;
                      return _profileRecentPosts(recentPost);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(
                      child: ShowLoader(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}