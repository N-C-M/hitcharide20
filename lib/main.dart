 
import 'package:flutter/material.dart';
import 'package:workavane/screens/loginpage.dart';

import 'dart:async';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:workavane/screens/mainpage.dart';
import 'package:workavane/screens/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            appId: '1:151917049307:android:eb39f37f63e7045ff0e3fe',
            apiKey: 'AIzaSyAzLpKCifErLVEp69BQvV2y2morxyM3lms',
            messagingSenderId: '297855924061',
            projectId: 'finaltry-622c5',
            databaseURL: 'https://finaltry-622c5.firebaseio.com',
          )
        : FirebaseOptions(
            appId: '1:151917049307:android:eb39f37f63e7045ff0e3fe',
            apiKey: 'AIzaSyAzLpKCifErLVEp69BQvV2y2morxyM3lms',
            messagingSenderId: '297855924061',
            projectId: 'finaltry-622c5',
            databaseURL: 'https://finaltry-622c5.firebaseio.com',
          ),
  );
  runApp(MaterialApp(home: MyApp(),));
}

 
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
 Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Brand-Regular',
        primarySwatch: Colors.blue,
      ),
       initialRoute : MainPage.id,
       routes:{
          Register.id: (context) => Register(),
          LoginPage.id: (context) => LoginPage(),
          MainPage.id: (context) => MainPage(),
        },
      );
    
  }
}

