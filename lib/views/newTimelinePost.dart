import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Zlay/widgets/toast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_uploader/flutter_uploader.dart';

class ImageSlider extends StatefulWidget {
  final List<Asset> media;
  ImageSlider({Key key, this.media}) : super(key: key);

  @override
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
              color: _current == index ? Colors.blueAccent : Colors.grey,
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
    List<Asset> mediaList = this.widget.media;

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
            items: mediaList.map((asset) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: double.infinity,
//                    decoration: BoxDecoration(
//                        image: new DecorationImage(
//                          fit: BoxFit.cover,
//                          image: new AssetImage(asset.toString()),
//                        )
//                    ),
//                    child: Align(
//                      alignment: FractionalOffset.bottomCenter,
//                      child: _buildIndicator(mediaList),
//                    )
                  child: AssetThumb(
                    asset: asset,
                    width: asset.originalWidth,
                    height: asset.originalHeight,
                    quality: 100
                  ),
                 );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class VideoSlider extends StatefulWidget {
  final List media;

  VideoSlider({Key key, this.media}) : super(key: key);

  _VideoSlider createState() => _VideoSlider();
}

class _VideoSlider extends State<VideoSlider>{
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
              color: _current == index ? Colors.blueAccent : Colors.grey,
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
    List mediaList = this.widget.media;

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
              print('Playing $i');
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: double.infinity,
                    child: new VideoPlayer(url: i.toString()),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(
            height: 25,
            child: new Align(
              alignment: FractionalOffset.bottomCenter,
              child: _buildIndicator(mediaList),
            ),
          )
        ],
      ),
    );
  }
}

class VideoPlayer extends StatefulWidget {
  final String url;
  VideoPlayer({Key key, this.url}) : super(key: key);

  @override
  _VideoPlayer createState() => _VideoPlayer();
}

class _VideoPlayer extends State<VideoPlayer>{
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(this.widget.url)..initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: false,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blueAccent,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: false,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      child: Chewie(
          controller: chewieController
      ),
    );
  }
}


class NewTimelinePost extends StatefulWidget {
  final int mediaType;
  NewTimelinePost({Key key, this.mediaType}) : super(key: key);

  @override
  _NewTimelinePost createState() => _NewTimelinePost();
}

class _NewTimelinePost extends State<NewTimelinePost> {
//  final uploader = FlutterUploader();
  var _mediaType;
  var _timelineTextInput = TextEditingController();
  var showLoader = false;
  var isImage;

  List<File> filesBox = [];
  List<Asset> images = List<Asset>();
  List<File> videos = List<File>();
  String _error = 'No Error Dectected';

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#2b2dad",
          actionBarTitle: "select photo",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      Navigator.pop(context);
    }

    if (!mounted) Navigator.pop(context);

    setState(() {
      images = resultList;
      _error = error;

      // prepare list
      getFilePathToList(images);
    });
  }

  Future<void> loadVideoAsset() async {
    String error = 'No Error Dectected';
    List<File> files;
    try {
      files = await FilePicker.getMultiFile(
          type: FileType.custom,
          allowedExtensions: ['mp4', 'avi']
      );
    } on Exception catch (e) {
      error = e.toString();
      Navigator.pop(context);
    }

    if(!mounted) Navigator.pop(context);

    setState(() {
      videos = files;
      getVideoFilePathToList(videos);
    });
  }

  Future<void> getFilePathToList(images) async {
    for (Asset asset in images) {
      var filePath = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      var fileProper = await getImageFileFromAsset(filePath);
      filesBox.add(fileProper);
    }
  }

  Future<void> getVideoFilePathToList(videos) async {
    for (File asset in videos) {
      filesBox.add(asset);
    }
  }

  Future<File> getImageFileFromAsset(String path) async {
    final file = File(path);
    return file;
  }

  BuildContext context;

  // Upload Timeline post
  uploadTimelinePost(String text) async {

  }

  // init state
  @override
  void initState(){
    super.initState();

    setState(() {
      _mediaType = this.widget.mediaType;

      // show selected image
      if(this.widget.mediaType == 1){
        isImage = true;
        loadAssets();
      }

      if(this.widget.mediaType == 2){
        isImage = false;
        loadVideoAsset();
      }
    });
  }

  // dispose after use
  @override
  void dispose() {
    // clean up the controller when the widget is disposed.
    _timelineTextInput.dispose();
    super.dispose();
  }

  // upload share widget
  Widget _uploadShareBtn(context){
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(5,5,10,5),
        child: Icon(Icons.share, color: Colors.grey[700]),
      ),
      onTap: () async {
        // share your timeline
        print('sharing timeline posts');
        var timelineResponse = await uploadTimelinePost(_timelineTextInput.text);
        if(timelineResponse['status'] == "success"){
          ToastMessage('success', timelineResponse['message']);
          // goto index widgets
          Navigator.pop(context);
        }else if(timelineResponse['status'] == "error"){
          ToastMessage('error', timelineResponse['message']);
        }
      },
    );
  }

  // chat input area
  Widget _timelineInputArea(context) {
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
          GestureDetector(
            child: Container(
              margin: EdgeInsets.all(5),
              child: Icon(Icons.location_on, color: Colors.grey[700]),
            ),
            onTap: (){
              print('adding location....');
            },
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.all(5),
              child: Icon(Icons.mood, color: Colors.grey[700]),
            ),
            onTap: (){
              print('Add expression...!');
            },
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: TextField(
              controller: _timelineTextInput,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 5, bottom: 1, top: 1, right: 5),
                  hintText: 'Share your feeling...'
              ),
            ),
          ),
          SizedBox(
              child: showLoader ? ShowLoader() : _uploadShareBtn(context),
          )
        ],
      ),
    );
  }

  // build picker view
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  // build timeline post screen
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                                  child: Text('Timeline Post',
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)
                                  )
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
                isImage ? ImageSlider(media: images) : VideoSlider(media: filesBox),
                SizedBox(
                  child: _timelineInputArea(context),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}