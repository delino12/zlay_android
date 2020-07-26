import 'package:flutter/material.dart';
import 'package:Zlay/widgets/ProfileMenu.dart';
import 'package:Zlay/models/follower.dart';
import 'package:Zlay/models/following.dart';

// Favorite Screen
class FavoriteScreen extends StatelessWidget {

  // tab bar widgets
  Widget _tabBarWidget(context) {
    return Flexible(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 50),
              color: Colors.white,
              child: TabBar(tabs: [
                Tab(
                  child: Container(
                    child: Text('Following', style: TextStyle(color: Colors.blueAccent)),
                  )
                ),
                Tab(
                    child: Container(
                      child: Text('Followers', style: TextStyle(color: Colors.blueAccent)),
                    )
                ),
              ]),
            ),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: FollowingList(),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: FollowerList(),
                      ),
                    ],
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ProfileMenuBarNoOption(),
          _tabBarWidget(context),
        ],
      ),
    );
  }
}