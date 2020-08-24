import 'package:flutter/material.dart';
import 'package:Zlay/widgets/authenticationWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final String title;
  EditProfile({Key key, this.title}) : super(key: key);

  @override
  _EditProfile createState() => _EditProfile();
}
class _EditProfile extends State<EditProfile>{


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
                height: 60,
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
                                child: Text('Edit Profile',
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
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}