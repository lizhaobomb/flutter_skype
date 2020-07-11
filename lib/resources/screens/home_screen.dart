import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_skype/enum/user_state.dart';
import 'package:flutter_skype/provider/user_provider.dart';
import 'package:flutter_skype/resources/auth_methods.dart';
import 'package:flutter_skype/resources/screens/callscreens/pickup/pickup_layout.dart';
import 'package:flutter_skype/utils/universal_variables.dart';
import 'package:provider/provider.dart';

import 'chatscreens/chat_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _page = 0;
  PageController pageController;
  UserProvider userProvider;
  double _labelFontSize = 10;
  static final AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();
      if (userProvider.getUser.uid != null) {
        _authMethods.setUserState(
            userId: userProvider.getUser.uid, userState: UserState.Online);
      }
    });
    pageController = PageController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";
    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resumed state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: <Widget>[
            Container(
              child: ChatListScreen(),
            ),
            Center(
              child: Text("Call Logs",
                  style: TextStyle(color: UniversalVariables.greyColor)),
            ),
            Center(
              child: Text("Contact Screen",
                  style: TextStyle(color: UniversalVariables.greyColor)),
            ),
          ],
          controller: pageController,
          onPageChanged: pageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: _page == 0
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    "Chats",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: _page == 0
                            ? UniversalVariables.lightBlueColor
                            : UniversalVariables.greyColor),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.call,
                    color: _page == 1
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    "Calls",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: _page == 1
                            ? UniversalVariables.lightBlueColor
                            : UniversalVariables.greyColor),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.contact_phone,
                    color: _page == 2
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    "Contacts",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: _page == 2
                            ? UniversalVariables.lightBlueColor
                            : UniversalVariables.greyColor),
                  ),
                ),
              ],
              onTap: navigationTaped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }

  void pageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTaped(int page) {
    pageController.jumpToPage(page);
  }
}
