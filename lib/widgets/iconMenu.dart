import 'package:flutter/material.dart';

class IconMenuBar extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      color: Colors.white,
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
//                      print('heading to the next page');
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => SettingScreen()),
//                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(9),
            child: GestureDetector(
              child: Icon(Icons.account_balance),
              onTap: (){
//                      print('heading to the next page');
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => SettingScreen()),
//                );
              },
            ),
          ),
        ],
      ),
    );
  }
}