import 'package:flutter/material.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:Zlay/repository/services.dart';

class CommentRepliesScreen extends StatefulWidget {
  final Map comment;
  CommentRepliesScreen({Key key, this.comment}) : super(key: key);

  @override
  _CommentRepliesScreen createState() => _CommentRepliesScreen();
}
class _CommentRepliesScreen extends State<CommentRepliesScreen> {
  var commentReplyInput = TextEditingController();
  var allCommentReplies;
  var commentId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentId = this.widget.comment['_id'];
  }

  // comment input widget
  Widget commentInputArea(context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[100],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      padding: EdgeInsets.fromLTRB(0,0,0,10),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            child: Icon(Icons.mood, color: Colors.grey[700]),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: TextField(
              controller: commentReplyInput,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 5, bottom: 1, top: 1, right: 5),
                  hintText: 'Type a reply...'
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.fromLTRB(5,5,10,5),
              child: Icon(Icons.send, color: Colors.grey[700]),
            ),
            onTap: () async {
              // send comments
              var commentReplyText = commentReplyInput.text;
              commentReplyInput.text = "";
              await postComment(commentId, commentReplyText);
              setState(() {
                allCommentReplies = fetchCommentReplies(commentId);
              });
            },
          ),
        ],
      ),
    );
  }

  // build comment replies list
  Widget commentReplyList(commentReplies) {
    return ListView.builder(
        itemCount: commentReplies.length,
        itemBuilder: (context, index){
          return buildCommentsReplies(commentReplies[index]);
        }
    );
  }

  // build comment replies
  Widget buildCommentsReplies(commentReply) {
    return  Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: ListTile(
        leading: Container(
          width: 35.0,
          height: 35.0,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(commentReply['user']['avatar']),
              )
          ),
        ),
        title: Container(
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text('${commentReply['user']['names']} - @${commentReply['user']['username']}', style: TextStyle(fontSize: 14.0, color: Colors.grey[500])),
              ),
              Container(
                child: Text(commentReply['createdAt'], style: TextStyle(fontSize: 10.0, color: Colors.grey[500])),
              )
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              child: Text(commentReply['body'], style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        dense: true,
        onTap: () async {

        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
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
                                child: Text('Comments',
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)
                                )
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: fetchCommentReplies(commentId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      allCommentReplies = snapshot.data;
                      allCommentReplies.add('first');
                      return commentReplyList(allCommentReplies);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(
                      child: ShowLoader(),
                    );
                  },
                ),
              ),
              commentInputArea(context)
            ],
          ),
        ),
      ),
    );
  }
}