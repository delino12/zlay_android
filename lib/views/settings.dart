import 'package:flutter/material.dart';
import 'package:Zlay/widgets/authenticationWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Zlay/views/help.dart';
import 'package:Zlay/views/account.dart';
import 'package:Zlay/views/InviteFriends.dart';
import 'package:Zlay/views/privacyPolicy.dart';
import 'package:Zlay/views/messageSetting.dart';
import 'package:Zlay/views/paymentSetting.dart';
import 'package:Zlay/views/zlayAds.dart';
import 'package:Zlay/views/notificationSetting.dart';

class SettingScreen extends StatefulWidget {
  final String title;
  SettingScreen({Key key, this.title}) : super(key: key);

  @override
  _SettingScreen createState() => _SettingScreen();
}
class _SettingScreen extends State<SettingScreen>{

  Future _logout() async {
      final prefs = await SharedPreferences.getInstance();
      final key = 'isLogin';
      final value = false;
      prefs.setBool(key, value);
      print('saved $value');
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
                                child: Text('Settings',
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
                    ListTile(
                      leading: Icon(Icons.account_circle, size: 24.0),
                      title: Text('Account', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                      dense: true,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AccountSetting()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.forum, size: 24.0),
                      title: Text('Chat setting', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                      dense: true,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MessageSetting()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.supervisor_account, size: 24.0),
                      title: Text('Invite a friend', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                      dense: true,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InviteFriends()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.payment, size: 24.0),
                      title: Text('Payment', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                      dense: true,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PaymentSettings()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications_none, size: 24.0),
                      title: Text('Notifications', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                      dense: true,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NotificationSettings()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.subscriptions, size: 24.0),
                      title: Text('Zlay Ads', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                      dense: true,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SponsoredAds()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.import_contacts, size: 24.0),
                      title: Text('Privacy & Terms', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                      dense: true,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.help_outline, size: 24.0),
                      title: Text('Help', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                      dense: true,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HelpDesk()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app, size: 24.0),
                      title: Text('Logout', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                      dense: true,
                      onTap: (){
                        setState(() {
                          _logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginWidget()),
                          );
                        });
                      },
                    ),
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