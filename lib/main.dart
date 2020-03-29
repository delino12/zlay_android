import 'package:flutter/material.dart';
import 'package:Zlay/widgets/authenticationWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Zlay/widgets/indexWidget.dart';
import 'package:Zlay/repository/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zlay Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Zlay'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLogin = false;

  Future<void> _isLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('_isLogin') ?? false;

    setState(() {
      _isLogin = value;
    });
  }

  @override
  void initState(){
    super.initState();
    FirebaseNotifications().setUpFirebase();
    _isLoginStatus();
  }

  Widget _buildAppBody (context){
    if(_isLogin == true) {
      return IndexWidget(title: 'Timeline');
    } else {
      return LoginWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  _buildAppBody(context);
  }
}