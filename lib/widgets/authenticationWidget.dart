import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Zlay/widgets/indexWidget.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Zlay/widgets/loader.dart';
import 'package:Zlay/widgets/modals.dart';
import 'package:Zlay/widgets/toast.dart';
import 'package:Zlay/repository/services.dart';

// Load all login widgets
class LoginWidget extends StatefulWidget{
  final String title;
  LoginWidget({Key key, this.title}) : super(key: key);

  @override
  _LoginWidget createState() => _LoginWidget();
}
class _LoginWidget extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // login user
  Future<void> __authLoginUser(email, password) async {
    final http.Response response = await http.post('http://zlayit.net/auth',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if(responseData['status'] == true){
        _save(responseData);
        ToastMessage('success', responseData['message']);
        setState((){
          // goto index widgets
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => new IndexWidget()),
          );
        });
      }else{
        ToastMessage('error', responseData['message']);
      }
    } else {
      ToastMessage('error', 'Login failed try again!');
      throw Exception('Login failed try again!');
    }
  }

  // save login data
  Future<void> _save(loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    final bool _isLogin    = true;
    final String _token    = loginResponse['token'];
    final String _email    = loginResponse['data']['email'];
    final String _userId   = loginResponse['data']['_id'];
    final String _username = loginResponse['data']['username'];
    final String _names    = loginResponse['data']['names'];
    final String _phone    = loginResponse['data']['phone'];
    final int _status      = loginResponse['data']['status'];
    final String _avatar   = loginResponse['data']['avatar'];

    prefs.setBool('_isLogin', _isLogin);
    prefs.setString('_token', _token);
    prefs.setString('_email', _email);
    prefs.setString('_userId', _userId);
    prefs.setString('_username', _username);
    prefs.setString('_names', _names);
    prefs.setString('_phone', _phone);
    prefs.setInt('_status', _status);
    prefs.setString('_avatar', _avatar);
  }

  Widget _loginStatus (message){
    return Container(
      child: Text(message),
    );
  }

  // line break
  Widget _divider (){
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
      child: new Divider(
        color: Colors.blueAccent,
      ),
    );
  }

  // add spacer
  Widget _addSpacer(){
    return Container(
      height: 45,
      child: _loginStatus(''),
    );
  }

  // Email or Phone field
  Widget _emailField(context){
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          TextField(
            controller: emailController,
            decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: 'Email or phone number'
            ),
          ),
        ],
      ),
    );
  }

  // password field
  Widget _passwordField(context){
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: 'Password'
            ),
          ),
        ],
      ),
    );
  }

  // forgot password link
  Widget _forgotPassword(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton(
          child: Text('Forgot password?', textAlign: TextAlign.left),
          color: Colors.white,
          textColor: Colors.blueAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ResetPasswordWidget()),
            );
          },
        ),
      ),
    );
  }

  // login button
  Widget _loginBtn(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(10, 1, 10, 15),
      height: 45,
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(20.0),
      ),
      child: RaisedButton(
        child: Text('LOG IN'),
        color: Colors.blueAccent,
        textColor: Colors.white,
        onPressed: () async {
          // login user
          await __authLoginUser(emailController.text, passwordController.text);
        },
      ),
    );
  }

  // register button
  Widget _registerBtn(context){
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            height: 45,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(20.0),
            ),
            width: 280,
            child: FlatButton(
              child: Text('REGISTER'),
              color: Colors.white,
              textColor: Colors.grey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpWidget()),
                );
              },
            ),
          ),
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
            body: Container(
            color: Colors.white,
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(25),
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Image.asset('assets/images/logo_no_icon.png',
                            height: 48,
                            fit: BoxFit.fill
                        ),
                      ),
                    ],
                  ),
                ),
                _addSpacer(),
                _emailField(context),
                _divider(),
                _passwordField(context),
                _divider(),
                _forgotPassword(context),
                _loginBtn(context),
                _registerBtn(context),
              ],
            ),
          ),
        ),
      );
  }
}

// Signup Widget on state
class SignUpWidget extends StatefulWidget{
  final String title;
  SignUpWidget({Key key, this.title}) : super(key: key);

  @override
  _SignUpWidget createState() => _SignUpWidget();
}
class _SignUpWidget extends State<SignUpWidget> {
  bool _value1 = false;
  bool _value2 = false;
  int _gender;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState(){
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
                  height: size.height,
                  color: Colors.white,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(25),
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Image.asset('assets/images/logo_no_icon.png',
                                  height: 48,
                                  fit: BoxFit.fill
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                  hintText: 'Name'
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
                                  hintText: 'Username'
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
                                  hintText: 'Email'
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
                              controller: passwordController,
                              obscureText: true,
                              decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: 'Password'
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
                                  hintText: 'Phone'
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
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: Row(
                          children: <Widget>[
                            Checkbox(value: _value1, onChanged: _value1Changed),
                            Text('Male'),
                            Container(
                              width: 34,
                              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                            ),
                            Checkbox(value: _value2, onChanged: _value2Changed),
                            Text('Female'),
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
                                child: Text('REGISTER'),
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                                onPressed: () async {
                                  var name = nameController.text;
                                  var username = usernameController.text;
                                  var email = emailController.text;
                                  var password = passwordController.text;
                                  var phone = phoneController.text;
                                  var gender = _gender;

                                  var response = await registerUserAccount(name, username, email, password, "$phone", "$gender");
                                  print(response);
                                  if(response['status'] == "success"){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginWidget()),
                                    );
                                  }

                                  ToastMessage(response['status'], response['message']);
                                },
                              ),
                            ),
                            Container(
                              height: 45,
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              width: 280,
                              child: FlatButton(
                                child: Text('Already have an account? Log in'),
                                color: Colors.white,
                                textColor: Colors.grey,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginWidget()),
                                  );
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

// Reset password widgets
class ResetPasswordWidget extends StatefulWidget {
  _ResetPasswordWidget createState() => _ResetPasswordWidget();
}
class _ResetPasswordWidget extends State<ResetPasswordWidget> {
  var resetEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    resetEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea (
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(25),
                width: double.infinity,
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Image.asset('assets/images/logo_no_icon.png',
                          height: 48,
                          fit: BoxFit.fill
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 45,
              ),
              Container(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: resetEmailController,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText: 'Enter phone number'
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(10, 1, 10, 15),
                      height: 45,
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                      child: RaisedButton(
                        child: Text('RESET'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        onPressed: () async {
                          var res = await verifyRegisteredMobile(resetEmailController.text);
                          if(res['status'] == "success"){
                            await sendPasswordResetCode(resetEmailController.text);
                            ToastMessage('success', res['message']);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new ResetVerifyCodeWidget()));
                          }else{
                            ToastMessage('error', res['message']);
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 45,
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                      width: 280,
                      child: FlatButton(
                        child: Text('Already register? Log in'),
                        color: Colors.white,
                        textColor: Colors.grey,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginWidget()),
                          );
                        },
                      ),
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

// Verify Reset request
class ResetVerifyCodeWidget extends StatefulWidget {
  _ResetVerifyCodeWidget createState() => _ResetVerifyCodeWidget();
}
class _ResetVerifyCodeWidget extends State<ResetVerifyCodeWidget>{
  var resetCodeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea (
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(25),
                width: double.infinity,
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Image.asset('assets/images/logo_no_icon.png',
                          height: 48,
                          fit: BoxFit.fill
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 45,
              ),
              Container(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: resetCodeController,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText: 'Enter verification code!'
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(10, 1, 10, 15),
                      height: 45,
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                      child: RaisedButton(
                        child: Text('VERIFY'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        onPressed: () async {
                          var pref = await SharedPreferences.getInstance();
                          int resetPassCode = pref.getInt('reset_pass_code');
                          int smsEnteredCode = int.parse(resetCodeController.text);
                          if(resetPassCode == smsEnteredCode){
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new ChangePasswordScreen()));
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 45,
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                      width: 280,
                      child: FlatButton(
                        child: Text('Already register? Log in'),
                        color: Colors.white,
                        textColor: Colors.grey,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginWidget()),
                          );
                        },
                      ),
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

// Change Password
class ChangePasswordScreen extends StatefulWidget {
  _ChangePasswordScreen createState() => _ChangePasswordScreen();
}
class _ChangePasswordScreen extends State<ChangePasswordScreen> {

  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return SafeArea (
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(25),
                width: double.infinity,
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Image.asset('assets/images/logo_no_icon.png',
                          height: 48,
                          fit: BoxFit.fill
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 45,
              ),
              Container(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText: 'New password!'
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText: 'Confirm password!'
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(10, 1, 10, 15),
                      height: 45,
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                      child: RaisedButton(
                        child: Text('UPDATE PASSWORD'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        onPressed: () async {
                          var password = passwordController.text;
                          var confirmPassword = confirmPasswordController.text;
                          if(password == confirmPassword){
                            // change password
                            var res = await changePassword(password);
                            if(res['status'] == "success"){
                              ToastMessage('success', res['message']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginWidget()),
                              );
                            }
                          }else{
                            ToastMessage('error', 'Password did not match!');
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 45,
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                      width: 280,
                      child: FlatButton(
                        child: Text('Already register? Log in'),
                        color: Colors.white,
                        textColor: Colors.grey,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginWidget()),
                          );
                        },
                      ),
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