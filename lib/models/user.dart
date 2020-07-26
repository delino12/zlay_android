import 'dart:async';
import 'dart:convert';
import 'package:Zlay/views/viewProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:Zlay/widgets/loader.dart';

class UserList extends StatefulWidget {
  @override
  _UserList createState() => _UserList();
}
class _UserList extends State<UserList>{
  // users collections
  var users;

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
      var collections = json.decode(response.body)['users'];
      return collections;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load notifications from API');
    }
  }

  Widget loadUsersView (users) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index){
        return buildUsersList(users[index]);
      },
    );
  }

  Widget buildUsersList(user){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        GestureDetector(
          child: Container(
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
                height: 25,
                width: 25,
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
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => new ViewProfileScreen(userId: user['_id'])));
          },
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
            users = snapshot.data;
            return loadUsersView(users);
          } else if(snapshot.hasError) {
            return Text("Internet connection lost!");
          }
          return Center(
            child: ShowLoader(),
          );
        }
    );
  }
}