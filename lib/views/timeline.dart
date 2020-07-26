import 'dart:async';
import 'package:Zlay/models/profile.dart';
import 'package:Zlay/models/user.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:Zlay/widgets/iconMenu.dart';
import 'package:Zlay/repository/services.dart';
import 'package:Zlay/widgets/ProfileMenu.dart';
import 'package:Zlay/views/comments.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Zlay/views/viewProfile.dart';

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

class ImageSlider extends StatefulWidget {
  final List media;
  ImageSlider({Key key, this.media}) : super(key: key);

  _ImageSlider createState() => _ImageSlider();
}
class _ImageSlider extends State<ImageSlider>{
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildIndicator(media) {
    if(media.length > 1){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(media, (index, url) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index ?
              Colors.blueAccent :
              Colors.white70,
            ),
          );
        }),
      );
    }else{
      return Row(
        children: <Widget>[],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> mediaList = this.widget.media;
    return Container(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            height: 400.0,
            enableInfiniteScroll: false,
            initialPage: 0,
            viewportFraction: 1.0,
            aspectRatio: 2.0,
            autoPlay: false,
            enlargeCenterPage: false,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: mediaList.map((i) {
              CachedNetworkImage(imageUrl: i['media_url']);
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: new DecorationImage(
                            fit: BoxFit.cover,
                            image:  CachedNetworkImageProvider(i['media_url']),
                          )
                      ),
                      child: new Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: _buildIndicator(mediaList),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(
            height: 2,
          )
        ],
      ),
    );
  }
}

class Timeline extends StatefulWidget {
  @override
  _Timeline createState() => _Timeline();
}
class _Timeline extends State<Timeline> {
  ScrollController _controller;
  var timelinePosts;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var mediaType;
  var likeColor = Colors.black;
  bool topScroll = true;
  bool postLike;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_controller.offset <= _controller.position.maxScrollExtent) {
      setState(() {
        topScroll = true;
        print("reach the bottom");
      });
    }

    if (_controller.offset >= _controller.position.minScrollExtent) {
      setState(() {
        topScroll = false;
        print("reach the bottom");
      });
    }

    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        topScroll = false;
        print("reach the bottom");
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        topScroll = true;
        print("reach the top");
      });
    }
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      timelinePosts = fetchTimelinePosts();
    });
  }

  Widget scrollableMenuBar (){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ProfileMenuBar()
      ],
    );
  }

  Widget showStatusAvatar() {
    return Container(
      child: Flexible(
        flex: 1,
        fit: FlexFit.loose,
        child: Container(
          padding: EdgeInsets.all(4),
          height: 200,
          child: UserList(),
        ),
      ),
    );
  }

  Widget timelineListView(data){
    return ListView.builder(
      controller: _controller,
      itemCount: data?.length,
      itemBuilder: (context, index){
        if(data[index]['media'][0]['media_type'] == 1){
          return postWithImages(data[index]);
        }else{
          return postWithVideos(data[index]);
        }
      },
    );
  }

  Widget postWithImages (dynamic post) => Container(
    margin: EdgeInsets.fromLTRB(0,0,0,15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Container(
                  width: 35.0,
                  height: 35.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(post['user']['avatar']),
                      )
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(post['user']['username'],
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          Text('Surulere Lagos',
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                          ),
                        ],
                      )
                  ),
                ),
                Icon(Icons.more_vert),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewProfileScreen(userId: post['user']['_id'])),
            );
          },
        ),
        ImageSlider(media: post['media']),
        Container(
            child: Row(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.favorite_border, size: 24, color: likeColor),
                          Text(post['likes'], style: TextStyle(fontSize: 12)),
                        ],
                      )
                  ),
                  onTap: () async {
                    setState(() {
                      likeColor = Colors.redAccent;
                    });
                    await likeTimelinePost(post['post']['_id'], 'happy');
                  },
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.chat_bubble_outline, size: 24),
                        Text(post['comments'], style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CommentScreen(post: post)),
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.share, size: 24),
                      Text('', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            )
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Text(post['post']['contents']),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Text('349 views', style: TextStyle(fontSize: 12)),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Text(post['post']['createdAt'], style: TextStyle(fontSize: 12)),
        ),
      ],
    ),
  );

  Widget postWithVideos (dynamic post) => Container(
    margin: EdgeInsets.fromLTRB(0,0,0,15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Container(
                  width: 35.0,
                  height: 35.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(post['user']['avatar']),
                      )
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(post['user']['username'],
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          Text('Surulere Lagos',
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                          ),
                        ],
                      )
                  ),
                ),
                Icon(Icons.more_vert),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewProfileScreen(userId: post['user']['_id'])),
            );
          },
        ),
        PreviewVideoPlayer(url: post['media'][0]['media_url']),
        Container(
            child: Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.favorite_border, size: 24),
                        Text('', style: TextStyle(fontSize: 12)),
                      ],
                    )
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.chat_bubble_outline, size: 24),
                        Text('', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CommentScreen()),
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.share, size: 24),
                      Text('', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            )
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Text(post['post']['contents'], style: TextStyle(fontSize: 14)),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Text('349 views', style: TextStyle(fontSize: 12)),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Text(post['post']['createdAt'], style: TextStyle(fontSize: 12)),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconMenuBar(),
            topScroll ? showStatusAvatar() : SizedBox(),
            Expanded(
              flex: 10,
              child: FutureBuilder(
                future: fetchTimelinePosts(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    timelinePosts = snapshot.data;

                    return RefreshIndicator(
                      key: refreshKey,
                      onRefresh: refreshList,
                      child: timelineListView(timelinePosts),
                    );
                  } else if(snapshot.hasError) {
                    return Text("Internet connection lost!");
                  }
                  return Center(
                    child: ShowLoader(),
                  );
                }
              ),
            )
          ],
        )
    );
  }
}
