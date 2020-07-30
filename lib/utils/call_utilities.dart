
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype/models/call.dart';
import 'package:flutter_skype/models/living.dart';
import 'package:flutter_skype/models/user.dart';
import 'package:flutter_skype/resources/call_methods.dart';
import 'package:flutter_skype/resources/screens/callscreens/call_screen.dart';
import 'package:flutter_skype/resources/screens/livingscreens/living_call_screen.dart';

class CallUtilities {
  static final CallMethods callMethods = CallMethods();

  static living({User user, context}) async {
    Living living = Living(
        callerId: user.uid,
        callerName: user.username,
        callerPic: user.profilePhoto,
        channelId: user.uid);
    bool livingMade = await callMethods.makeLiving(living: living);
    living.hasDialled = true;
    if (livingMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LivingCallScreen(
            living: living,
            clientRole: ClientRole.Broadcaster,
          ),
        ),
      );
    }
  }

  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: from.uid,
    );
    bool callMade = await callMethods.makeCall(call: call);
    call.hasDialled = true;
    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      );
    }
  }
}
