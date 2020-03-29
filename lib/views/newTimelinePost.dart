import 'package:analyzer/file_system/file_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewTimelinePost extends StatefulWidget {
  final int mediaType;

  // init string
  NewTimelinePost({Key key, this.mediaType}) : super(key: key);

  @override
  _newPost createState() => _newPost();
}

class _newPost extends State<NewTimelinePost> {
  var _image;
  var _video;

  // This function will helps you to pick and Image from Gallery
  Future pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        _image = image;
      });
    }
  }

  // init state
  @override
  void initState(){
    super.initState();
    // show selected image
    if(this.widget.mediaType == 1){
      pickImage();
    }

    if(this.widget.mediaType == 2){

    }
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
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 5, bottom: 1, top: 1, right: 5),
                  hintText: 'Share your feeling...'
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.fromLTRB(5,5,10,5),
              child: Icon(Icons.share, color: Colors.grey[700]),
            ),
            onTap: (){
              // share your timeline
              print('sharing timeline posts');
            },
          )
        ],
      ),
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
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child:  _image == null ? Text('No image selected') : Image.file(_image),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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