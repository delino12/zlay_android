import 'package:flutter/material.dart';
import 'package:Zlay/repository/services.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchTimeline extends StatefulWidget {
  @override
  _SearchTimeline createState() => _SearchTimeline();
}

class _SearchTimeline extends State<SearchTimeline> {

  // build recent post widgets
  Widget _profileRecentPosts(recentPost){
    return Expanded(
      child: new StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: 25,
        itemBuilder: (BuildContext context, int index){
//          if(recentPost[index]['media']['media_type'] == 1){
//            print('images');
//            return Container(
//              width: double.infinity,
//              decoration: BoxDecoration(
//                  image: new DecorationImage(
//                    fit: BoxFit.cover,
//                    image: new NetworkImage('http://zlayit.net/gallery/zlay_1590367861907683015.jpg'),
//                  )
//              ),
//            );
//          }else if(recentPost[index]['media']['media_type'] == 2){
//            print('video');
//            return Container(
//              width: double.infinity,
//              decoration: BoxDecoration(
//                  image: new DecorationImage(
//                    fit: BoxFit.cover,
//                    image: new NetworkImage('http://zlayit.net/gallery/zlay_1590367861907683015.jpg'),
//                  )
//              ),
//            );
//          }
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: new NetworkImage('http://zlayit.net/gallery/zlay_1590367861907683015.jpg'),
                )
            ),
          );
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
                                child: Text('Discover inside Africa',
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)
                                )
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              Container(
                child: FutureBuilder(
                  future: fetchAllRecent(),
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