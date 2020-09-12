import 'package:flutter/material.dart';
import 'package:Zlay/widgets/authenticationWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Zlay/widgets/toast.dart';
import 'package:Zlay/repository/services.dart';

class EditProfile extends StatefulWidget {
  final String title;
  final Map profile;
  EditProfile({Key key, this.title, this.profile}) : super(key: key);

  @override
  _EditProfile createState() => _EditProfile();
}
class _EditProfile extends State<EditProfile>{
  bool _value1 = false;
  bool _value2 = false;
  int _gender;
  Map profileDetails;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState(){
    profileDetails = this.widget.profile;
    nameController.text = profileDetails['user']['names'];
    usernameController.text = profileDetails['user']['username'];
    emailController.text = profileDetails['user']['email'];
    phoneController.text = profileDetails['user']['phone'];
//    print(profileDetails);
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  //we omitted the brackets '{}' and are using fat arrow '=>' instead, this is dart syntax
  void _value1Changed(bool value){
    setState(() {
      _value1 = true;
      _value2 = false;
      _gender = 1;
    });
  }
  void _value2Changed(bool value){
    setState(() {
      _value1 = false;
      _value2 = true;
      _gender = 2;
    });
  }

  Widget avatarWidget(profile){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Container(
            child: Card(
              elevation: 10,
              child: Image.network('${profile['user']['avatar']}',
                  height: 148,
                  fit: BoxFit.fill
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text('${profile['user']['names']}', style: TextStyle(fontSize: 26),),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: Text('@${profile['user']['username']}'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
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
                                  child: Text('Edit Profile',
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
                  height: size.height,
                  color: Colors.white,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      avatarWidget(profileDetails),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: nameController,
                              decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: '${profileDetails['user']['names']}'
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: new Divider(
                          color: Colors.blueAccent,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: usernameController,
                              decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: '${profileDetails['user']['username']}'
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: new Divider(
                          color: Colors.blueAccent,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: emailController,
                              decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: '${profileDetails['user']['email']}'
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: new Divider(
                          color: Colors.blueAccent,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: phoneController,
                              decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: '${profileDetails['user']['phone']}'
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 25,
                        margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(10, 1, 10, 15),
                              height: 45,
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              child: RaisedButton(
                                child: Text('Update Profile'),
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                                onPressed: () async {
                                  var name = nameController.text;
                                  var username = usernameController.text;
                                  var email = emailController.text;
                                  var password = passwordController.text;
                                  var phone = phoneController.text;
                                  var gender = _gender;

                                  ToastMessage('status', 'message');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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