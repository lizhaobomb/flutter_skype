import 'package:flutter/material.dart';
import 'package:flutter_skype/models/contact.dart';
import 'package:flutter_skype/models/message.dart';
import 'package:flutter_skype/models/user.dart';
import 'package:flutter_skype/provider/user_provider.dart';
import 'package:flutter_skype/resources/auth_methods.dart';
import 'package:flutter_skype/resources/chat_methods.dart';
import 'package:flutter_skype/resources/screens/chatscreens/chat_screen.dart';
import 'package:flutter_skype/utils/universal_variables.dart';
import 'package:flutter_skype/widgets/cached_image.dart';
import 'package:flutter_skype/widgets/online_dot_indicator.dart';
import 'package:provider/provider.dart';

import 'custom_tile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;

  final AuthMethods _authMethods = AuthMethods();
  ContactView({this.contact});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;
          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();
  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    UserProvider _userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            receiver: contact,
          ),
        ),
      ),
      title: Text(
        contact?.username ?? "...",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Arial",
          fontSize: 19,
        ),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: _userProvider.getUser.uid,
          receiverId: contact.uid,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(
          maxHeight: 60,
          maxWidth: 60,
        ),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(uid: contact.uid),
          ],
        ),
      ),
    );
  }
}

class LastMessageContainer extends StatelessWidget {
  final Stream stream;

  LastMessageContainer({
    @required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.documents;
          if (docList.isNotEmpty) {
            Message message = Message.fromMap(docList.last.data);
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                message.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return Text(
            "No Message",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          );
        }

        return Text(
          "..",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
