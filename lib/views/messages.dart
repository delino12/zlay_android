import 'package:flutter/material.dart';
import 'package:Zlay/views/chat.dart';
import 'package:Zlay/widgets/ProfileMenu.dart';
import 'package:Zlay/models/message.dart';

// Message Screen
class MessageScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ProfileMenuBarNoOption(),
          Expanded(
            child: FollowerList(),
          ),
        ],
      ),
    );
  }
}