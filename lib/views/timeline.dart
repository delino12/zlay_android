import 'package:flutter/material.dart';
import 'package:Zlay/models/post.dart';
import 'package:Zlay/models/user.dart';
import 'package:Zlay/widgets/iconMenu.dart';
import 'package:Zlay/widgets/ProfileMenu.dart';

class Timeline extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Column(
        children: <Widget>[
          IconMenuBar(),
          ProfileMenuBar(),
          SizedBox(
            height: 70,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: UserList(),
                )
              ],
            ),
          ),
          Expanded(
            child: PostTimelineStories(),
          ),
        ],
      ),
    );
  }
}