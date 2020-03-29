import 'package:flutter/material.dart';
import 'package:Zlay/widgets/ProfileMenu.dart';
import 'package:Zlay/models/notification.dart';

// Notification Screen
class NotificationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ProfileMenuBarNoOption(),
          Expanded(
            child: new NotificationList(),
          ),
        ],
      ),
    );
  }
}