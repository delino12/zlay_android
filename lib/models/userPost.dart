import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future loadUserRecentPost() async {
  var prefs =  await SharedPreferences.getInstance();
  final String userId = prefs.getString('_userId');
  final response = await http.get('http://zlayit.net/timeline/recent?user_id=${userId}');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    List collections = json.decode(response.body)['posts'];
    return collections;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load notifications from API');
  }
}

class UserPost {
  Map post;
  Map media;

  UserPost({
    this.post,
    this.media,
  });

  factory UserPost.fromJson(Map<String, dynamic> json){
    return UserPost(
      post: json['post'],
      media: json['media'],
    );
  }
}