import 'package:flutter/material.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:Zlay/repository/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:Zlay/views/commentsReplies.dart';

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

class CommentScreen extends StatefulWidget {
  final Map post;
  CommentScreen({Key key, this.post}) : super(key: key);

  @override
  _CommentScreen createState() => _CommentScreen();
}
class _CommentScreen extends State<CommentScreen> {
  var commentInput = TextEditingController();
  var post;
  var allPostComments;
  var likeColor = Colors.black;
  bool postLike ;
  String postId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    post = this.widget.post;
    postId = this.widget.post['post']['_id'];
  }

  @override
  void dispose(){
    super.dispose();
    commentInput.dispose();
  }

  // comment input widget
  Widget commentInputArea(context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[100],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      padding: EdgeInsets.fromLTRB(0,0,0,10),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            child: Icon(Icons.mood, color: Colors.grey[700]),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: TextField(
              controller: commentInput,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 5, bottom: 1, top: 1, right: 5),
                  hintText: 'Add your comment...'
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.fromLTRB(5,5,10,5),
              child: Icon(Icons.send, color: Colors.grey[700]),
            ),
            onTap: () async {
              // send comments
              var commentText = commentInput.text;
              commentInput.text = "";
              await postComment(postId, commentText);
              setState(() {
                allPostComments = fetchComments(postId);
              });
            },
          ),
        ],
      ),
    );
  }

  // post with images
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
                  onDoubleTap: () async {
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
                        Text('', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  onTap: (){
                    print('already in comment screen');
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

  // post with videos
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

  // build list widget
  Widget postCommentLists(comments){
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index){
        index--;
        if(index == -1){
          return buildPostView(post);
        }else{
          return buildPostComments(comments[index]);
        }
      }
    );
  }

  // build list widget element
  Widget buildPostComments(comment){
    return  Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: ListTile(
          leading: Container(
            width: 35.0,
            height: 35.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(comment['user']['avatar']),
                )
            ),
          ),
          title: Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Text('${comment['user']['names']} - @${comment['user']['username']}', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                ),
                Container(
                  child: Text(comment['createdAt'], style: TextStyle(fontSize: 10.0, color: Colors.grey[500])),
                )
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                child: Text(comment['body'], style: TextStyle(fontSize: 12)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.favorite_border, size: 18, color: Colors.black54),
                        Container(
                          margin: EdgeInsets.fromLTRB(0,5,0,0),
                          child: Text('42 likes'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                    child: GestureDetector(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.reply, size: 18, color: Colors.black54),
                          Container(
                            margin: EdgeInsets.fromLTRB(0,5,0,0),
                            child: Text('12 replies'),
                          ),
                        ],
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CommentRepliesScreen(commentId: comment['_id'])),
                        );
                      },
                    )
                  )
                ],
              )
            ],
          ),
          dense: true,
          onTap: () async {

          },
        ),
    );
  }

  // build post view
  Widget buildPostView(post){
    if(post['media'][0]['media_type'] == 1){
      return postWithImages(post);
    }else{
      return postWithVideos(post);
    }
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
                                child: Text('Comments',
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
                  future: fetchComments(postId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      allPostComments = snapshot.data;
                      allPostComments.add('first');
                      return postCommentLists(allPostComments);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(
                      child: ShowLoader(),
                    );
                  },
                ),
              ),
              commentInputArea(context)
            ],
          ),
        ),
      ),
    );
  }
}