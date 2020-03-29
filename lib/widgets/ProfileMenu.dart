import 'package:flutter/material.dart';
import 'package:Zlay/views/settings.dart';
import 'package:Zlay/views/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileMenuBar extends StatefulWidget {
  @override
  _profileMenuState createState() => _profileMenuState();
}

class _profileMenuState extends State<ProfileMenuBar>{

  String _email = '';
  String _username = '';
  String _names = '';
  String _avatar = 'assets/images/profile.jpg';

  Future<String> _getLoginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      this._names = prefs.getString('_names') ?? '';
      this._email = prefs.getString('_email') ?? '';
      this._avatar = prefs.getString('_avatar') ?? '';
      this._username = prefs.getString('_username') ?? '';
    });
  }

  @override
  void initState(){
    super.initState();
    _getLoginDetails();
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
          GestureDetector(
            child: Container(
              width: 45.0,
              height: 45.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(_avatar),
                  )
              ),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => new ProfileScreen()));
            },
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
                margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_names,
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
          Container(
            child: GestureDetector(
              child: Icon(Icons.settings),
              onTap: (){
//                      print('heading to the next page');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuBarNoOption extends StatefulWidget {
  @override
  _profileMenuStateNoOption createState() => _profileMenuStateNoOption();
}

class _profileMenuStateNoOption extends State<ProfileMenuBarNoOption>{

  String _email = '';
  String _username = '';
  String _names = '';
  String _avatar = 'assets/images/profile.jpg';

  Future<String> _getLoginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      this._names = prefs.getString('_names') ?? '';
      this._email = prefs.getString('_email') ?? '';
      this._avatar = prefs.getString('_avatar') ?? '';
      this._username = prefs.getString('_username') ?? '';
    });
  }

  @override
  void initState(){
    super.initState();
    _getLoginDetails();
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
                  image: new NetworkImage(_avatar),
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
                    Text(_names,
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