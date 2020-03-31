import 'package:analyzer/file_system/file_system.dart';
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
  var _mediaType;

  var _timelineTextInput = TextEditingController();

  // dispose after use
  @override
  void dispose() {
    // clean up the controller when the widget is disposed.
    _timelineTextInput.dispose();
    super.dispose();
  }

  // This function will helps you to pick and Image from Gallery
  Future pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        _image = image;
      });
    }
  }

  // Upload Timeline post
  uploadTimelinePost(String text) async {
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('_userId');

    // init file post request
    var request = http.MultipartRequest("POST", Uri.parse("http://zlayit.net/timeline/post"));
    request.fields["post_text"]   = text;
    request.fields["user_id"]     = userId;
    request.fields["media_type"]  = "${_mediaType}";
    request.fields["is_multiple"] = "1"; // 1 means single : 2 means it's multiple

    // init media file section
    var media = await http.MultipartFile.fromPath("post_media", _image.path);

    request.files.add(media);

    // get response from server
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var responseObject = json.decode(responseString);

    print('Timeline post response: ');
    print(responseObject);

    // return response
    return responseObject;
  }

  // init state
  @override
  void initState(){
    super.initState();

    setState(() {
      _mediaType = this.widget.mediaType;

      // show selected image
      if(this.widget.mediaType == 1){
        pickImage();
      }

      if(this.widget.mediaType == 2){

      }
    });
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
          GestureDetector(
            child: Container(
              margin: EdgeInsets.fromLTRB(5,5,10,5),
              child: Icon(Icons.share, color: Colors.grey[700]),
            ),
            onTap: () async {
              // share your timeline
              print('sharing timeline posts');
              var timelineResponse = await uploadTimelinePost(_timelineTextInput.text);
              Navigator.pop(context);
//              if(timelineResponse['status'] == "success"){
//                ToastMessage('success', timelineResponse['message']);
//                // goto index widgets
//                Navigator.pop(context);
//              }else if(timelineResponse['status'] == "error"){
//                ToastMessage('error', timelineResponse['message']);
//              }
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