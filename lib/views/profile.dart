import 'package:flutter/material.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:Zlay/models/profile.dart';
import 'package:Zlay/models/userPost.dart';
import 'package:Zlay/repository/services.dart';
import 'package:Zlay/views/followers.dart';
import 'package:Zlay/views/following.dart';
import 'package:Zlay/views/editProfile.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';

class PreviewVideoPlayer extends StatefulWidget {
  final String url;
  PreviewVideoPlayer({Key key, this.url}) : super(key: key);

  @override
  _PreviewVideoPlayer createState() => _PreviewVideoPlayer();
}
class _PreviewVideoPlayer extends State<PreviewVideoPlayer>{
  String videoUrl;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoUrl = this.widget.url;
    _controller = VideoPlayerController.network(videoUrl.toString());
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the VideoPlayer.
          return GestureDetector(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  PlayPauseOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return Container(
            height: 350,
            child: Center(child: ShowLoader()),
          );
        }
      },
    );
  }
}

class PlayPauseOverlay extends StatefulWidget {
  const PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  _PlayPauseOverlay createState() => _PlayPauseOverlay();

}
class _PlayPauseOverlay extends State<PlayPauseOverlay> {
  var _controller;
  bool isMuted = false;

  @override
  void initState(){
    super.initState();
    _controller = this.widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: isMuted ? Icon(
                  Icons.volume_off, size: 14,
                  color: Colors.white,) :
                Icon(Icons.volume_up,
                  size: 14,
                  color: Colors.white,),
              )
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: _controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: Center(
//
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: (){
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          onTap: (){
            if(isMuted == false){
              setState(() {
                isMuted = true;
              });
            }else if(isMuted == true){
              setState(() {
                isMuted = false;
              });
            }

            setState(() {
              isMuted
                  ? _controller.setVolume(0.0)
                  : _controller.setVolume(5.5);
            });
          },
        ),
      ],
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() => _ProfileScreen();
}
class _ProfileScreen extends State<ProfileScreen> {
  var profile;
  var recentPost = [];

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: FutureBuilder(
          future: loadUsersList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              profile = snapshot.data;
              return FutureBuilder(
                future: loadUserProfileRecentPost(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var recentPost = snapshot.data;
                    return CustomScrollView(
                      slivers: [
                        SliverPersistentHeader(
                          delegate: MySliverAppBar(
                              expandedHeight: 200,
                              userAvatar: profile['user']['avatar'],
                              userName: profile['user']['username']
                          ),
                          pinned: false,
                          floating: true,
                        ),
                        SliverFixedExtentList(
                          itemExtent: 50.0,
                          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            return Container(
                              height: 350,
                              alignment: Alignment.center,
                              color: Colors.white,
                              child: Text(''),
                            );
                          },
                            childCount: 2,
                          ),
                        ),
                        SliverFixedExtentList(
                          itemExtent: 50.0,
                          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            return Container(
                                height: 350,
                                alignment: Alignment.center,
                                color: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(profile['user']['names'], style: TextStyle(fontSize: 18),),
                                        Text('@${profile['user']['username']}', style: TextStyle(fontSize: 14),),
                                      ],
                                    )
                                  ],
                                )
                            );
                          },
                            childCount: 1,
                          ),
                        ),
                        SliverFixedExtentList(
                          itemExtent: 50.0,
                          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            return Container(
                              height: 350,
                              alignment: Alignment.center,
                              color: Colors.white,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Row(
                                      children: [
                                        Icon(Icons.perm_identity, size: 16,),
                                        Text('Edit', style: TextStyle(fontSize: 16),)
                                      ],
                                    ),
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => EditProfile(profile: profile)),
                                      );
                                    },
                                  )
                                ],
                              )
                            );
                          },
                            childCount: 1,
                          ),
                        ),
                        SliverFixedExtentList(
                          itemExtent: 50.0,
                          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            return Container(
                              color: Colors.white,
                              height: 150,
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
                                  GestureDetector(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.fromLTRB(15,5,15,5),
                                          child: Text('Followers'),
                                        ),
                                        Text('${profile['followers']}')
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Follower()),
                                      );
                                    },
                                  ),
                                  GestureDetector(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.fromLTRB(15,5,15,5),
                                          child: Text('Following'),
                                        ),
                                        Text('${profile['following']}')
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Following()),
                                      );
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                            childCount: 1,
                          ),
                        ),
                        SliverFixedExtentList(
                          itemExtent: 30.0,
                          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            return Container(
                              alignment: Alignment.center,
                              color: Colors.white,
                              child: Text(''),
                            );
                          },
                            childCount: 1,
                          ),
                        ),
                        SliverGrid(
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200.0,
                              mainAxisSpacing: 5.0,
                              crossAxisSpacing: 5.0,
                            ),
                            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                              if(recentPost[index]['media']['media_type'] == 1){
                                return GestureDetector(
                                    onTap: (){
//                                      Navigator.push(
//                                        context,
//                                        MaterialPageRoute(builder: (context) => CommentScreen(post: recentPost)),
//                                      );
                                      print(recentPost[index]);
                                    },
                                  child: Container(
                                    height: 400,
                                    decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new NetworkImage(recentPost[index]['media']['media_url']),
                                        )
                                    ),
                                  ),
                                );
                              }else{
                                return GestureDetector(
                                  child: Container(
                                    child: PreviewVideoPlayer(url: recentPost[index]['media']['media_url']),
                                  ),
                                  onTap: (){
//                                      Navigator.push(
//                                        context,
//                                        MaterialPageRoute(builder: (context) => CommentScreen(post: recentPost)),
//                                      );
                                    print(recentPost[index]);
                                  },
                                ); 
                              }
                            },
                              childCount: recentPost.length,
                            )
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(
                    child: ShowLoader(),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
              child: ShowLoader(),
            );
          },
        ),
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String userAvatar;
  final String userName;
  MySliverAppBar({@required this.expandedHeight, this.userAvatar, this.userName});

  double _sigmaX = 1.0; // from 0-10
  double _sigmaY = 1.0; // from 0-10
  double _opacity = 0.1; // from 0-1.0

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Image.network(userAvatar,
          fit: BoxFit.cover,
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Text(
              "$userName",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: 150 / 2 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Card(
              elevation: 10,
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width / 2,
                child: Container(
                  padding: EdgeInsets.all(1),
                  height: 96,
                  width: 96,
                  color: Colors.blueAccent,
//                  decoration: new BoxDecoration(
//                      shape: BoxShape.circle,
//                      color: Colors.blueAccent
//                  ),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: 96,
                    width: 96,
                    decoration: new BoxDecoration(
                        color: Colors.blueAccent,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(userAvatar),
                        )
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}