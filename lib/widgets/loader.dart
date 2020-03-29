import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

// Show Loader
class ShowLoader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 25,
        width: 25,
        child: SpinKitRing(
          lineWidth: 1,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}