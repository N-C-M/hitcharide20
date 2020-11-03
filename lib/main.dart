 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workavane/dataprovider/appdata.dart';
import 'package:workavane/globalvariables.dart';
import 'package:workavane/screens/driverrider.dart';
import 'package:workavane/screens/loginpage.dart';

import 'dart:async';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';

import 'package:workavane/screens/mainpage.dart';
import 'package:workavane/screens/mainpagedriver.dart';
import 'package:workavane/screens/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*final FirebaseApp app = await FirebaseApp.initializeApp(         //.configure nop initializeAPP
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
  );*/

  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
      googleAppID: '1:151917049307:android:eb39f37f63e7045ff0e3fe',
      gcmSenderID: '169450788828',
      databaseURL: 'https://finaltry-622c5.firebaseio.com',
    )
        : const FirebaseOptions(
      googleAppID: '1:151917049307:android:eb39f37f63e7045ff0e3fe',
      apiKey: 'AIzaSyAzLpKCifErLVEp69BQvV2y2morxyM3lms',
      databaseURL: 'https://finaltry-622c5.firebaseio.com',
    ),
  );
    currentFirebaseUser = await FirebaseAuth.instance.currentUser();


  runApp(MaterialApp(home: MyApp(),));
}

 
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
 Widget build(BuildContext context) {

    return ChangeNotifierProvider(
          create: (context) => AppData(),
          child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
        ),
        //initialRoute: (currentFirebaseUser == null) ? LoginPage.id : DriverRider.id,
         initialRoute : MainPageDriver.id,// MainPAge arnn
         routes:{
            MainPageDriver.id:(context)=>MainPageDriver(),
            DriverRider.id:(context)=>DriverRider(),
            Register.id: (context) => Register(),
            LoginPage.id: (context) => LoginPage(),
            MainPage.id: (context) => MainPage(),
          },
        ),
    );
    
  }
}

