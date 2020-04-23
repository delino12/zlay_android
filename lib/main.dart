import 'package:flutter/material.dart';
import 'package:Zlay/widgets/authenticationWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Zlay/widgets/indexWidget.dart';
import 'package:Zlay/repository/services.dart';

void main() => runApp(MyApp());

Future<bool> isLoginStatus() async {
  var prefs = await SharedPreferences.getInstance();
  var value = prefs.getBool('_isLogin') ?? false;
  return value;
}

class MyApp extends StatefulWidget {

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  // This widget is the root of your application.
  bool isLogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zlay Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
          future: isLoginStatus(),
          builder:(BuildContext context, AsyncSnapshot<bool> snapshot){
            if (snapshot.data == false){
              return LoginWidget();
            }
            else{
              return MyHomePage(title: 'Timeline');
            }
          }
      ),
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

  @override
  void initState(){
    super.initState();
    FirebaseNotifications().setUpFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return IndexWidget(title: 'Timeline');
  }
}