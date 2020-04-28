import 'package:flutter/material.dart';
import 'package:Zlay/models/post.dart';
import 'package:Zlay/widgets/iconMenu.dart';


class Timeline extends StatefulWidget {
  @override
  _Timeline createState() => _Timeline();
}

class _Timeline extends State<Timeline> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        IconMenuBar(),
        Expanded(
          child: PostTimelineStories(),
        )
      ],
    );
  }
}