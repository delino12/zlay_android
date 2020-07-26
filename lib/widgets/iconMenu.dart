import 'package:Zlay/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:Zlay/views/zlayLiveTv.dart';
import 'package:Zlay/views/search.dart';

class IconMenuBar extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide( //                   <--- left side
            color: Colors.black12,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
              height: 42.0,
              child: Image.asset(
                "assets/images/logo_no_icon.png",
                fit: BoxFit.contain,
              )
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
                margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
            ),
          ),
          Container(
            margin: EdgeInsets.all(9),
            child: GestureDetector(
              child: Icon(Icons.search),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchTimeline()),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(9),
            child: GestureDetector(
              child: Icon(Icons.airplay),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ZlayLiveTV()),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(9),
            child: GestureDetector(
              child: Icon(Icons.settings),
              onTap: (){
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