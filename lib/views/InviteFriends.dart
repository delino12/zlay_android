import 'package:flutter/material.dart';
import 'package:Zlay/widgets/loader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:contacts_service/contacts_service.dart';

class InviteFriends extends StatefulWidget {
  @override
  _InviteFriends createState() => _InviteFriends();
}
class _InviteFriends extends State<InviteFriends> {
  // Get all contacts on device as a stream
  Iterable<Contact> contacts;
  bool isReady = false;

  @override
  void initState(){
    super.initState();
    _getContact();
  }

  _getContact() async {
    var loaded = await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = loaded;
      isReady = true;
    });
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
      subtitle: Text('Invites to Zlay'),
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
              Expanded(
                child: isReady ? contactListView(contacts) : Center(
                      child: ShowLoader(),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}