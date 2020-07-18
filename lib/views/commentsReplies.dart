import 'package:flutter/material.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:Zlay/repository/services.dart';

class CommentRepliesScreen extends StatefulWidget {
  @override
  _CommentRepliesScreen createState() => _CommentRepliesScreen();
}
class _CommentRepliesScreen extends State<CommentRepliesScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
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
                                child: Text('Comment Replies',
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)
                                )
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}