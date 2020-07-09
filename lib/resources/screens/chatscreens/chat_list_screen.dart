import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype/models/contact.dart';
import 'package:flutter_skype/provider/user_provider.dart';
import 'package:flutter_skype/resources/chat_methods.dart';
import 'package:flutter_skype/resources/firebase_repository.dart';
import 'package:flutter_skype/utils/universal_variables.dart';
import 'package:flutter_skype/widgets/contact_view.dart';
import 'package:flutter_skype/widgets/custom_app_bar.dart';
import 'package:flutter_skype/widgets/custom_tile.dart';
import 'package:flutter_skype/widgets/new_chat_button.dart';
import 'package:flutter_skype/widgets/quiet_box.dart';
import 'package:flutter_skype/widgets/user_circle.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
//globe
  final FirebaseRepository _repository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(),
    );
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {}),
      title: UserCircle(),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/search_screen");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {
            _repository.signOut();
          },
        )
      ],
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider _userProvider = Provider.of<UserProvider>(context);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(userId: _userProvider.getUser.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuietBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);
                  return ContactView(
                    contact: contact,
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
