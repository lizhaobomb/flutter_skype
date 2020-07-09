import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype/enum/user_state.dart';
import 'package:flutter_skype/models/user.dart';
import 'package:flutter_skype/resources/auth_methods.dart';
import 'package:flutter_skype/utils/utilities.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();

  OnlineDotIndicator({
    @required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToUserState(state)) {
        case UserState.Online:
          return Colors.grey;
        case UserState.Offline:
          return Colors.red;
        default:
          return Colors.orange;
      }
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _authMethods.getUserStream(uid: uid),
      builder: (context, snapshot) {
        User user;
        if (snapshot.hasData && snapshot.data.data != null) {
          user = User.fromMap(snapshot.data.data);
        }

        return Container(
          height: 10,
          width: 10,
          margin: EdgeInsets.only(right: 8, top: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getColor(user?.state),
          ),
        );
      },
    );
  }
}
