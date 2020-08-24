import 'package:flutter/material.dart';
import 'package:Zlay/views/timeline.dart';
import 'package:Zlay/views/notification.dart';
import 'package:Zlay/views/favorite.dart';
import 'package:Zlay/views/messages.dart';
import 'package:Zlay/views/profile.dart';
import 'package:Zlay/views/newTimelinePost.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:badges/badges.dart';

// Tim Widget on state
class IndexWidget extends StatefulWidget{
  final String title;
  IndexWidget({Key key, this.title}) : super(key: key);

  @override
  _IndexWidget createState() => _IndexWidget();
}

// register user widgets
class _IndexWidget extends State<IndexWidget> {
  int _selectedIndex = 0;
  bool isLogin = false;

  @override
  void initState(){
    super.initState();
  }

  // list of tab bar screen
  static List<Widget> _widgetOptions = <Widget>[
    new Timeline(),
    new NotificationScreen(),
    new FavoriteScreen(),
    new MessageScreen(),
    new ProfileScreen(),
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
          heroTag: '$index',
          backgroundColor: Colors.blueAccent[500],
          mini: true,
          child: Icon(iconData),
          onPressed: onPressed,
        )
    );
  }

  // active screen
  Widget _activeScreen(){
    return SizedBox(
      child: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  // bottom navigation
  Widget _bottomNavigation(){
    return  BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(FontAwesome.home, size: 22,),
          title: Text('home'),
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Badge(
              shape: BadgeShape.circle,
              borderRadius: 100,
              child: Icon(FontAwesome.bell, size: 22,),
              badgeContent: Container(
                height: 3,
                width: 3,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
          ),
          title: Text('notification'),
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(FontAwesome.heart_empty, size: 22,),
          title: Text('favorite'),
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Badge(
            shape: BadgeShape.circle,
            borderRadius: 100,
            child: Icon(FontAwesome.mail, size: 22,),
            badgeContent: Container(
              height: 3,
              width: 3,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
          ),
          title: Text('message'),
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(FontAwesome.user, size: 22,),
          title: Text('profile'),
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
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: _activeScreen(),
          floatingActionButton: _unicornDialerWidget(),
          bottomNavigationBar: _bottomNavigation(),
        ), // trailing comma makes auto-formatting nicer for build methods.
      );
    }else{
      return SafeArea(
        child:  Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: _activeScreen(),
          bottomNavigationBar: _bottomNavigation(),
        ), // trailing comma makes auto-formatting nicer for build methods.
      );
    }
  }
}
