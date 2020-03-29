import 'package:flutter/material.dart';
import 'package:Zlay/views/timeline.dart';
import 'package:Zlay/views/notification.dart';
import 'package:Zlay/views/favorite.dart';
import 'package:Zlay/views/messages.dart';
import 'package:Zlay/views/newTimelinePost.dart';
import 'package:unicorndial/unicorndial.dart';

// Tim Widget on state
class IndexWidget extends StatefulWidget{
  final String title;
  IndexWidget({Key key, this.title}) : super(key: key);

  @override
  _indexWidget createState() => _indexWidget();
}

// register user widgets
class _indexWidget extends State<IndexWidget> {
  int _selectedIndex = 0;
  bool isLogin = false;

  @override
  void initState(){
    super.initState();
  }

  // list of tab bar screen
  static List<Widget> _widgetOptions = <Widget>[
    new Timeline(),
    new MessageScreen(),
    new FavoriteScreen(),
    new NotificationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // unicorn icons list
  List<UnicornButton> _getProfileMenu() {
    List<UnicornButton> children = [];

    // Add Children here
    children.add(_profileOption(index: 1, iconData: Icons.center_focus_weak, onPressed:() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => new NewTimelinePost(mediaType: 1)));
    }));

    children.add(_profileOption(index: 2, iconData: Icons.video_library, onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => new NewTimelinePost(mediaType: 2)));
    }));

    // Add Children here
    return children;
  }

  // profile option widget
  Widget _profileOption({int index, IconData iconData, Function onPressed}) {
    return UnicornButton(
        currentButton: FloatingActionButton(
          heroTag: '${index}',
          backgroundColor: Colors.blueAccent[500],
          mini: true,
          child: Icon(iconData),
          onPressed: onPressed,
        )
    );
  }

  // active screen
  Widget _activeScreen(){
    return Container(
      color: Colors.white70,
      child: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  // bottom navigation
  Widget _bottomNavigation(){
    return  BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mail_outline),
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          title: Text(''),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue[800],
      onTap: _onItemTapped,
    );//
  }

  // float icon bar
  Widget _unicornDialerWidget(){
    return UnicornDialer(
      parentButtonBackground: Colors.blueAccent[400],
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.filter_center_focus),
      childButtons: _getProfileMenu(),
    );
  }

  // build display
  @override
  Widget build(BuildContext context) {
    if(_selectedIndex == 0){
      return SafeArea(
        child:  Scaffold(
          resizeToAvoidBottomInset: false,
          body: _activeScreen(),
          floatingActionButton: _unicornDialerWidget(),
          bottomNavigationBar: _bottomNavigation(),
        ), // trailing comma makes auto-formatting nicer for build methods.
      );
    }else{
      return SafeArea(
        child:  Scaffold(
          resizeToAvoidBottomInset: false,
          body: _activeScreen(),
          bottomNavigationBar: _bottomNavigation(),
        ), // trailing comma makes auto-formatting nicer for build methods.
      );
    }
  }
}
