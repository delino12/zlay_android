import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// Application endpoint
const api_endpoint = 'http://zlayit.net';

// register user device token
Future registerDeviceToken(token) async {
  final prefs        = await SharedPreferences.getInstance();
  String userId      = prefs.getString('_userId');
  String deviceToken = token;
  String queryString = "?user_id=$userId&device_token=$deviceToken";

  final http.Response response = await http.post('$api_endpoint/firebase/device$queryString',
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'user_id': userId,
    },
    body: jsonEncode(<String, String>{
      'device_token': deviceToken,
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } else {
    print('Device token registration failed try again!');
  }
}

// build a local notification popup
Future displayLocalNotification(payload) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  var android       = new AndroidInitializationSettings('@mipmap/ic_launcher');
  var iOS           = new IOSInitializationSettings();
  var initSetttings = new InitializationSettings(android, iOS);
}

// register user account and device
Future registerUserAccount(String name, String username, String email, String password, String phone, String gender) async {
  final http.Response response = await http.post('$api_endpoint/user',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'names': name,
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      'gender': gender
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('User registration failed!');
  }
}

// Forgot password retriever
Future verifyRegisteredMobile(phone) async {
  final http.Response response = await http.post('$api_endpoint/reset/verify/mobile',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'phone': phone,
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('User verification failed!');
  }
}

// Forgot password retriever
Future sendPasswordResetCode(phone) async {
  var prefs = await SharedPreferences.getInstance();
  int generatedCode = 198388;
  prefs.setInt('reset_pass_code', generatedCode);

  final http.Response response = await http.post('$api_endpoint/reset',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'message': 'Your password reset code is $generatedCode',
      'sender': 'Zlay',
      'mobiles': phone,
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('User reset code failed!');
  }
}

// change password
Future changePassword(password) async {
  final http.Response response = await http.post('$api_endpoint/reset/change/password',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'password': password
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('User change password failed!');
  }
}

// send liked action on a post
Future likeTimelinePost(postId, reaction) async {
  final prefs        = await SharedPreferences.getInstance();
  String userId      = prefs.getString('_userId');
  final http.Response response = await http.post('$api_endpoint/likes',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'user_id': userId,
      'post_id': postId
    },
    body: jsonEncode(<String, String>{
      'user_id': userId,
      'post_id': postId,
      'reaction': reaction,
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    notifyLikeOnTimelinePost(userId, postId);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('Error liking timeline post!');
  }
}

// notify liked action on post
Future notifyLikeOnTimelinePost(userId, postId) async {
  final http.Response response = await http.post('$api_endpoint/likes',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'user_id': userId,
      'post_id': postId
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('User registration failed!');
  }
}

// fetch all comments
Future fetchComments(String postId) async {
  String query = '?post_id=$postId';
  final http.Response response = await http.get('$api_endpoint/comments$query',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
  );
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body)['data'];
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('Error fetching comments!');
  }
}

// post user comment
Future postComment(postId, comment) async {
  final prefs        = await SharedPreferences.getInstance();
  String userId      = prefs.getString('_userId');
  final http.Response response = await http.post('$api_endpoint/comments',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'comment': comment,
      'user_id': userId,
      'post_id': postId,
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('Error liking timeline post!');
  }
}

// send comment notifications
Future sendCommentNotification(postId) async {
  final prefs        = await SharedPreferences.getInstance();
  String userId      = prefs.getString('_userId');
  final http.Response response = await http.post('$api_endpoint/notifications/post/comment',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'user_id': userId,
      'post_id': postId,
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('Error sending notification events!');
  }
}

// replied comments
Future fetchCommentReplies(commentId) async {
  String query = '?comment_id=$commentId';
  final http.Response response = await http.get('$api_endpoint/replies$query',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
  );
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body)['data'];
    print(responseData);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('Error fetching data!');
  }
}

// post user comment replies
Future postCommentReply(commentId, comment) async {
  final prefs        = await SharedPreferences.getInstance();
  String userId      = prefs.getString('_userId');
  final http.Response response = await http.post('$api_endpoint/replies',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'comment': comment,
      'user_id': userId,
      'comment_id': commentId,
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('Error posting comment replies!');
  }
}

// send comment notifications
Future sendCommentReplyNotification(commentId) async {
  final prefs        = await SharedPreferences.getInstance();
  String userId      = prefs.getString('_userId');
  final http.Response response = await http.post('$api_endpoint/notifications/comment/replies',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'user_id': userId,
      'post_id': commentId,
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('Error sending notification events!');
  }
}

// update user profile
Future updateUserProfileInfo(name, username, phone) async {
  final prefs        = await SharedPreferences.getInstance();
  String userId      = prefs.getString('_userId');
  final http.Response response = await http.post('$api_endpoint/profile',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'user_id': userId,
      'name': name,
      'username': username,
      'phone': phone
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('Error posting update to profile!');
  }
}

// fetch all recent post
Future fetchAllRecent() async {
  final http.Response response = await http.get('$api_endpoint/timeline/all-recent',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('Error fetching recent timeline posts!');
  }
}

// fetch all user recent with args
Future<void> loadUserRecentPost(String userId) async {
  final response = await http.get('$api_endpoint/timeline/recent?user_id=$userId');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    List collections = json.decode(response.body)['posts'];
    return collections;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load notifications from API');
  }
}

// load user recent post
Future loadUserProfileRecentPost() async {
  var prefs =  await SharedPreferences.getInstance();
  final String userId = prefs.getString('_userId');
  final response = await http.get('$api_endpoint/timeline/recent?user_id=${userId}');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    List collections = json.decode(response.body)['posts'];
    return collections;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load notifications from API');
  }
}

// fetch zlay timeline tv post
Future<void> fetchZlayTvPost() async {
  final http.Response response = await http.get('$api_endpoint/timeline/tv/post',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
  );
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body)['posts'];
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('Error fetching zlay tv timeline posts!');
  }
}

// add to view counter
Future<void> addToView(String mediaId) async {
  final prefs        = await SharedPreferences.getInstance();
  String userId      = prefs.getString('_userId');
  final http.Response response = await http.post('$api_endpoint/views',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'user_id': userId,
      'post_id': mediaId,
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('View counter recording failed!');
  }
}

// fetch real timeline post
Future<void> fetchTimelinePosts() async {
  final prefs        = await SharedPreferences.getInstance();
  String userId      = prefs.getString('_userId');
  final response = await http.get('$api_endpoint/posts?user_id=$userId');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    var responseData = json.decode(response.body)['posts'];
    return responseData;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load posts from API');
  }
}

// convert coordinates to address
Future convertCoordinatesToAddress(longitude, latitude)  async {
  final response = await http.get('$api_endpoint/locations/points-to-address?longitude=$longitude&latitude=$latitude');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    var responseData = json.decode(response.body)['data'];
    return responseData;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load address from coordinates API');
  }
}

// fetch real timeline post
Future<void> loadUserProfile(profileUserId) async {
  final response = await http.get('$api_endpoint/user/$profileUserId');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    var responseData = json.decode(response.body)['data'];
    return responseData;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load posts from API');
  }
}

// fetch timeline post
Future<dynamic> fetchTimelinePostToFile() async {
    var responseDataFromLocal = await readTimelineFromFile();
    var responseData = json.decode(responseDataFromLocal)['posts'];
    return responseData;
}

// locate directory path
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// init file location
Future<File> get _localFile async {
  final path =  await _localPath;
  return File('$path/posts.json');
}

// write data to file
Future<File> writeTimelinePost(String posts) async {
  final file = await _localFile;
  print('timeline post written to json');
  return file.writeAsString(posts);
}

// read post from file
Future<String> readTimelineFromFile() async {
  try {
    final file = await _localFile;
    String timelinePostContents = await file.readAsString();
    return timelinePostContents;
  } catch(e) {
    return e.getMessage;
  }
}

// write images to temp location
Future<File> writeTimelineImageToLocal (String imageUrl) async {
  final Directory temporary = await getTemporaryDirectory();
  final File imageFile = File('${temporary.path}/images/$imageUrl');
  if(await imageFile.exists()){
    return imageFile;
  }else{
    await imageFile.create(recursive: true);
    return imageFile;
  }
}

// fetch all followers
Future fetchFollowers() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('_userId');

  final response = await http.get('$api_endpoint/follower?user_id=$userId');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    List collections = json.decode(response.body)['data'];
    return collections;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load notifications from API');
  }
}

// fetch all followings
Future fetchFollowings() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('_userId');

  final response = await http.get('$api_endpoint/following?user_id=$userId');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    List collections = json.decode(response.body)['data'];
    return collections;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load notifications from API');
  }
}

// fetch all favorite
Future fetchFavorites() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('_userId');

  final response = await http.get('$api_endpoint/favorites?user_id=$userId');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    List collections = json.decode(response.body)['data'];
    return collections;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load favorites from API');
  }
}

// load chat recipient user
Future loadChatUserProfile(receiverId) async {
  final response = await http.get('$api_endpoint/user/$receiverId');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    var collections = json.decode(response.body)['data'];
    return collections;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load notifications from API');
  }
}

// fetch chat from api
Future fetchChatHistory() async {
  var pref = await SharedPreferences.getInstance();
  var senderId = pref.getString('_userId');

  final response = await http.get('$api_endpoint/chats/history?sender_id=$senderId');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    List collections = json.decode(response.body)['data'];
    return collections;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load notifications from API');
  }
}

// fetch chat from api
Future fetchChat(senderId, receiverId) async {
  print('sender id: $senderId');
  print('receiver id: $receiverId');

  final response = await http.get('$api_endpoint/chats?sender_id=$senderId&receiver_id=$receiverId');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    List collections = json.decode(response.body)['data'];
    return collections;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load notifications from API');
  }
}

// send chat
Future sendChat(message, senderId, receiverId) async {
  final http.Response response = await http.post('$api_endpoint/chats',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    var chatId = responseData['data']['message']['_id'];
    print('chat id: $chatId');
    await sendChatMessageNotification(message, senderId, receiverId, chatId);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('View counter recording failed!');
  }
}

// send chat message notification
Future sendChatMessageNotification(message, senderId, receiverId, chatId) async {
  print('sending chat notifications');
  final http.Response response = await http.post('$api_endpoint/notifications/notify/message',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'chat_id': chatId
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    return responseData;
  } else if(response.statusCode != 200) {
    print(json.decode(response.body));
    print('Error sending chat notifications');
  }
}

// display notifications bar
class DisplayNotification extends StatefulWidget {
  @override
  _DisplayNotification createState() => _DisplayNotification();
}
class _DisplayNotification extends State<DisplayNotification> {

  @override
  void initState(){
    super.initState();

  }

  // when notification is selected
  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  // show notifications
  showNotification() async {
    var android = new AndroidNotificationDetails('channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
//    await flutterLocalNotificationsPlugin.show(0, 'New Video is out', 'Flutter Local Notification', platform,
//        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  @override
  Widget build(BuildContext context) {
    return showNotification();
  }
}

// init firebase notification
class FirebaseNotifications {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();
    _firebaseMessaging.getToken().then((token) async {
      print('Device token: ');
      print(token);
      var tokenResponse = await registerDeviceToken(token);
      print(tokenResponse);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        Map notificationMessage = message;
        print(notificationMessage);
      },
      onResume: (Map<String, dynamic> message) async {
        print('Resume screen');
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('On launch screen');
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}