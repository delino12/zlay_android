import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future loadUsersList() async {
  var prefs =  await SharedPreferences.getInstance();
  final String userId = prefs.getString('_userId');
  final response = await http.get('http://zlayit.net/user/${userId}');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    var collections = json.decode(response.body)['data'];
    return collections;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load notifications from API');
  }
}

class UserProfile {
  Map user;
  String followers;
  String following;
  String timeline;

  UserProfile({
    this.user,
    this.followers,
    this.following,
    this.timeline,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json){
    return UserProfile(
      user: json['user'],
      followers: json['followers'],
      following: json['following'],
      timeline: json['timeline'],
    );
  }
}