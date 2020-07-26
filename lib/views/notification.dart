import 'package:flutter/material.dart';
import 'package:Zlay/widgets/ProfileMenu.dart';
import 'package:Zlay/models/notification.dart';

// Notification Screen
class NotificationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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