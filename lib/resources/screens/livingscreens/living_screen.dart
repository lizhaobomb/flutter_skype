import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype/models/living.dart';
import 'package:flutter_skype/provider/user_provider.dart';
import 'package:flutter_skype/resources/call_methods.dart';
import 'package:flutter_skype/resources/screens/livingscreens/living_call_screen.dart';
import 'package:flutter_skype/utils/call_utilities.dart';
import 'package:flutter_skype/widgets/quiet_box.dart';
import 'package:provider/provider.dart';

class LivingScreen extends StatelessWidget {
  final CallMethods _callMethods = CallMethods();

  @override
  Widget build(BuildContext context) {
    tapItem({Living living}) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LivingCallScreen(
            living: living,
            clientRole: ClientRole.Audience,
          ),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => makeLiving(context),
        child: Text("发起\n直播"),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _callMethods.fetchLivings(),
          builder: (context, snapshots) {
            if (snapshots.hasData) {
              var datas = snapshots.data.documents;
              if (datas.isEmpty) {
                return QuietBox();
              }

              final UserProvider userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              var newDatas = List<DocumentSnapshot>();
              for (var live in datas) {
                if (live.documentID != userProvider.getUser.uid) {
                  newDatas.add(live);
                }
              }

              return GridView.builder(
                itemCount: newDatas.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  Living living = Living.fromMap(newDatas[index].data);
                  return GestureDetector(
                    onTap: () => tapItem(living: living),
                    child: GridTile(
                      child: Container(
                        color: Colors.cyan,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Image.network(
                                living.callerPic,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text(living.callerName),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  makeLiving(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (userProvider?.getUser != null) {
      CallUtilities.living(user: userProvider.getUser, context: context);
      // _currentUser = userProvider.getUser;
    }
  }

  List<String> getDataList() {
    List<String> list = [];
    for (int i = 0; i < 100; i++) {
      list.add(i.toString());
    }
    return list;
  }

  List<Widget> getWidgetList() {
    return getDataList().map((item) => getItemContainer(item));
  }

  Widget getItemContainer(String item) {
    return Container(
      child: Text(
        item,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      alignment: Alignment.center,
      color: Colors.blue,
    );
  }
}
