import 'package:flutter/material.dart';

class HelpDesk extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
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
                                  child: Text('FAQ',
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)
                                  )
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 200,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('This is a question', style: TextStyle(fontSize: 25),),
                              Text('This is a question', style: TextStyle(fontSize: 16),)
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 200,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('This is a question', style: TextStyle(fontSize: 25),),
                              Text('This is a question', style: TextStyle(fontSize: 16),)
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 200,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('This is a question', style: TextStyle(fontSize: 25),),
                              Text('This is a question', style: TextStyle(fontSize: 16),)
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 200,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('This is a question', style: TextStyle(fontSize: 25),),
                              Text('This is a question', style: TextStyle(fontSize: 16),)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}