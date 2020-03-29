import 'package:shared_preferences/shared_preferences.dart';

class AuthUser {
  bool _isLogin;
  String _token;
  String _email;
  String _userId;
  String _username;
  String _names;
  String _phone;
  int _status;
  String _avatar;

  // function
  getLogin() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('_isLogin');
  }

  getToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('_token');
  }

  getEmail() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('_email');
  }

  getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('_userId');
  }

  getUsername() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('_username');
  }

  getNames() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('_names');
  }

  getPhone() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('_phone');
  }

  getStatus() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt('_status');
  }

  getAvatar() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('_avatar');
  }
}