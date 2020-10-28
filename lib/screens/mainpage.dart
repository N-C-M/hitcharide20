import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('MainPage'),

      ),
      body: Center(
        child: MaterialButton(
          onPressed: (){
            DatabaseReference dref= FirebaseDatabase.instance.reference().child('Test');
            dref.set('IsConnected');
          },
          height: 30,
          minWidth: 300,
          color: Colors.amber,
          child: Text('Test Connection'),
          ),
      )

    );
   
  }
}