import 'package:flutter/material.dart';
import 'package:flutter_contact/contact.dart';
import 'package:Zlay/widgets/loader.dart';

class InviteFriends extends StatefulWidget {

  @override
  _InviteFriends createState() => _InviteFriends();
}
class _InviteFriends extends State<InviteFriends> {
  Iterable<Contact> contactLists;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadContacts();
  }

  Future<dynamic> loadContacts() async {
    // Get all contacts on device

  }

  ListView contactListView (contacts){
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index){
        return buildContactList(contacts[index]);
      },
    );
  }

  Widget buildContactList(contact){
    return ListTile(
      leading: Icon(Icons.contacts),
      title: Text('Phone here..'),
      subtitle: Text('Invites to zlay'),
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
                                child: Text('Invite Friends',
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)
                                )
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
//              Expanded(
//                child: FutureBuilder(
//                    future: loadContacts(),
//                    builder: (context, snapshot){
//                      if(snapshot.hasData){
//                        contactLists = snapshot.data;
//                        return  contactListView(contactLists);
//                      } else if(snapshot.hasError) {
//                        return Text("${snapshot.error}");
//                      }
//                      return Center(
//                        child: ShowLoader(),
//                      );
//                    }
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}