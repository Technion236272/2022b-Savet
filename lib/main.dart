// @dart=2.9

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'auth/login_page.dart';
import 'auth/auth_repoitory.dart';
import 'package:flutter/src/services/asset_bundle.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //create: (context) => AuthRepository.instance();,

  runApp(
      ChangeNotifierProvider(
          create: (context) => AuthRepository.instance(),
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
        builder:  (context,snapshot){

          return MaterialApp(
            title: 'Savet',
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
            ),
            home: Splash2(),
            debugShowCheckedModeBanner: false,
          );
    }
    );
  }
}
class Splash2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 6,
      navigateAfterSeconds: new Login(),
      title: new Text('Savet',textScaleFactor: 2,style: TextStyle(color: Colors.white),),
      image: Image.asset("assets/image/splash.png"),
      backgroundColor: Colors.deepOrange,
      loadingText: Text("Loading",style: TextStyle(color: Colors.white),),
      photoSize: 100.0,
      loaderColor: Colors.white,
    );
  }
}

