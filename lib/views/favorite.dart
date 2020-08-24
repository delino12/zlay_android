import 'package:flutter/material.dart';
import 'package:Zlay/widgets/ProfileMenu.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:Zlay/views/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Zlay/repository/services.dart';

// Favorite Screen
class FavoriteScreen extends StatefulWidget {

  @override
  _FavoriteScreen  createState() => _FavoriteScreen();
}
class _FavoriteScreen extends State<FavoriteScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  ListView favoriteListView (favorites){
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index){
        return buildFavoriteList(favorites[index]);
      },
    );
  }

  Widget buildFavoriteList(favorite){
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
                  image: NetworkImage(favorite['user']['avatar']),
                )
            ),
          ),
          title: Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Text('You are now following @${favorite['user']['username']}', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                ),
                Container(
                  child: Icon(Icons.more_vert, size: 12),
                )
              ],
            ),
          ),
          subtitle: Text(favorite['user']['names'], style: TextStyle(fontSize: 12)),
          dense: true,
          onTap: () async {
            var prefs = await SharedPreferences.getInstance();
            var receiverId = favorite['user']['_id'];
            var senderId = prefs.getString('_userId');
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(senderId: senderId, receiverId: receiverId)));
          },
        ),
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
                future: fetchFavorites(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List following = snapshot.data;
                    return  favoriteListView(following);
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