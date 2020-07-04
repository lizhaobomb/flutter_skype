import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype/provider/image_upload_provider.dart';
import 'package:flutter_skype/provider/user_provider.dart';
import 'package:flutter_skype/resources/firebase_repository.dart';
import 'package:flutter_skype/resources/screens/home_screen.dart';
import 'package:flutter_skype/resources/screens/login_screen.dart';
import 'package:flutter_skype/resources/screens/search_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseRepository _repository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider(),),
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MaterialApp(
        title: "Flutter Skype",
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {'/search_screen': (context) => SearchScreen()},
        home: FutureBuilder(
          future: _repository.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
