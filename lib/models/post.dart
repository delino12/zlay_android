import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:Zlay/models/user.dart';
import 'package:Zlay/widgets/ProfileMenu.dart';

class Post {
  final String title;
  final String postUser;
  final String postUserAvatar;
  final String postMediaAvatar;
  final String postCreatedAt;
  final String postLikes;
  final List postMedia;
  final int mediaType;

  Post({
    this.title,
    this.postUser,
    this.postUserAvatar,
    this.postMediaAvatar,
    this.postCreatedAt,
    this.postLikes,
    this.mediaType,
    this.postMedia
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['post']['contents'],
      postUser: json['user']['username'],
      postUserAvatar: json['user']['avatar'],
      postMediaAvatar: json['media'][0]['media_url'],
      postCreatedAt: json['post']['createdAt'],
      postLikes: json['likes'],
      mediaType: json['media'][0]['media_type'],
      postMedia: json['media']
    );
  }
}

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
            onDoubleTap: (){
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            ),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return Center(child: ShowLoader());
        }
      },
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
              color: _current == index ? Colors.blueAccent : Colors.white70,
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
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: new DecorationImage(
                            fit: BoxFit.cover,
                            image:  NetworkImage(i['media_url']),
                          )
                      ),
                      child: new Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: _buildIndicator(mediaList),
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

class PostTimelineStories extends StatefulWidget {
  @override
  _PostTimelineStories createState() => _PostTimelineStories();
}
class _PostTimelineStories extends State<PostTimelineStories> {
  var timelinePosts;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var mediaType;

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      timelinePosts = __fetchPosts();
    });
  }

  Future<List<Post>> __fetchPosts() async {
    final response = await http.get('http://zlayit.net/posts');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      List responseData = json.decode(response.body)['posts'];
      return responseData.map((post) => new Post.fromJson(post)).toList();
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load posts from API');
    }
  }

  Widget timelineListView(data){
    return ListView.builder(
      itemCount: data?.length,
      itemBuilder: (context, index){
        if(data[index].mediaType == 1){
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
        Container(
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
                      image: new NetworkImage(post.postUserAvatar),
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
                        Text(post.postUser,
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
        ImageSlider(media: post.postMedia),
        Container(
            child: Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.favorite_border, size: 24),
                        Text(post.postLikes, style: TextStyle(fontSize: 12)),
                      ],
                    )
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.chat_bubble_outline, size: 24),
                      Text('', style: TextStyle(fontSize: 12)),
                    ],
                  ),
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
          child: Text(post.title),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Text(post.postCreatedAt, style: TextStyle(fontSize: 12)),
        ),
      ],
    ),
  );

  Widget postWithVideos (dynamic post) => Container(
    margin: EdgeInsets.fromLTRB(0,0,0,15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
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
                      image: new NetworkImage(post.postUserAvatar),
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
                        Text(post.postUser,
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
        PreviewVideoPlayer(url: post.postMediaAvatar),
        Container(
            child: Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.favorite_border, size: 24),
                        Text(post.postLikes, style: TextStyle(fontSize: 12)),
                      ],
                    )
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.chat_bubble_outline, size: 24),
                      Text('', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                  ),
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
          child: Text(post.title, style: TextStyle(fontSize: 14)),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Text(post.postCreatedAt, style: TextStyle(fontSize: 12)),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
        future: __fetchPosts(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            timelinePosts = snapshot.data;
            return RefreshIndicator(
              key: refreshKey,
              onRefresh: refreshList,
              child:  timelineListView(timelinePosts),
            );
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
