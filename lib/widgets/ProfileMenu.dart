import 'package:flutter/material.dart';
import 'package:Zlay/views/settings.dart';
import 'package:Zlay/views/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileMenuBar extends StatefulWidget {
  @override
  _ProfileMenuBar createState() => _ProfileMenuBar();
}
class _ProfileMenuBar extends State<ProfileMenuBar>{

  String email = '';
  String username = '';
  String names = '';
  String avatar = 'https://res.cloudinary.com/zlayit/image/upload/v1587824183/avatar/profile-user_wr2vgi.png';

  Future<void> getLoginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      names = prefs.getString('_names');
      email = prefs.getString('_email');
      avatar = prefs.getString('_avatar');
      username = prefs.getString('_username');
    });
  }

  @override
  void initState(){
    super.initState();
    getLoginDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.white,
      margin: EdgeInsets.all(9),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Container(
              width: 45.0,
              height: 45.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(avatar),
                  )
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(names,
                          style: TextStyle(fontWeight: FontWeight.w500,
                              fontSize: 16)
                      ),
                      Text('Apapa Lagos, NG',
                        style: TextStyle(fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                    ],
                  )
              ),
            ),
          ],
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => new ProfileScreen()));
        },
      ),
    );
  }
}

class ProfileMenuBarNoOption extends StatefulWidget {
  @override
  _ProfileMenuBarNoOption createState() => _ProfileMenuBarNoOption();
}
class _ProfileMenuBarNoOption extends State<ProfileMenuBarNoOption>{

  String email = '';
  String username = '';
  String names = '';
  String avatar = 'https://res.cloudinary.com/zlayit/image/upload/v1587824183/avatar/profile-user_wr2vgi.png';

  Future<void> getLoginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      names = prefs.getString('_names');
      email = prefs.getString('_email');
      avatar = prefs.getString('_avatar');
      username = prefs.getString('_username');
    });
  }

  @override
  void initState(){
    super.initState();
    getLoginDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.white,
      margin: EdgeInsets.all(9),
      child: Row(
        children: <Widget>[
          Container(
            width: 45.0,
            height: 45.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(avatar),
                )
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
                margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(names,
                        style: TextStyle(fontWeight: FontWeight.w500,
                            fontSize: 16)
                    ),
                    Text('Apapa Lagos, NG',
                      style: TextStyle(fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
}