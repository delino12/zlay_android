import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:Zlay/widgets/loader.dart';

class User {
  String id;
  String username;
  String avatar;
  String phone;
  String names;
  String email;
  int status;
  String createdAt;
  String updatedAt;

  User({
    this.id,
    this.username,
    this.avatar,
    this.phone,
    this.names,
    this.email,
    this.status,
    this.createdAt,
    this.updatedAt
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['_id'],
      username: json['username'],
      avatar: json['avatar'],
      phone: json['phone'],
      names: json['names'],
      email: json['email'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class UserList extends StatefulWidget {

  @override
  _UserList createState() => _UserList();
}

class _UserList extends State<UserList>{
  // users collections
  var users = const [];

  final kInnerDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.circular(32),
  );

  final kGradientBoxDecoration = BoxDecoration(
    gradient: LinearGradient(colors: [Colors.black, Colors.redAccent]),
    border: Border.all(
      color: Colors.blueAccent,
    ),
    borderRadius: BorderRadius.circular(32),
  );

  @override
  void initState(){
    super.initState();
  }

  Future loadUsersList() async {
    final response = await http.get('http://zlayit.net/user');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      List collections = json.decode(response.body)['users'];
      return collections;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load notifications from API');
    }
  }

  Widget loadUsersView (users) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
//      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index){
        return buildUsersList(users[index]);
      },
    );
  }

  Widget buildUsersList(user){
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.all(2),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [Colors.blueAccent, Colors.deepPurpleAccent]),
          ),
          child: Container(
            height: 62,
            width: 62,
            margin: EdgeInsets.all(2),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Colors.white, Colors.white]),
            ),
            child: Container(
              height: 64,
              width: 64,
              margin: EdgeInsets.all(2),
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(user['avatar']),
                  )
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadUsersList(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List users = snapshot.data;
            return  loadUsersView(users);
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