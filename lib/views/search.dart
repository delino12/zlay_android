import 'package:flutter/material.dart';
import 'package:Zlay/repository/services.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
        itemCount: recentPost.length,
        itemBuilder: (BuildContext context, int index){
          if(recentPost[index]['media'][0]['media_type'] == 1){
            return GestureDetector(
              onTap: (){
                print(recentPost[index]);
              },
              child: Container(
                height: 500,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(recentPost[index]['media'][0]['media_url']),
                    )
                ),
              ),
            );
          }else{
            return GestureDetector(
              child: Container(
                child: PreviewVideoPlayer(url: recentPost[index]['media'][0]['media_url']),
              ),
              onTap: (){
                print(recentPost[index]);
              },
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
                  future: fetchTimelinePosts(),
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