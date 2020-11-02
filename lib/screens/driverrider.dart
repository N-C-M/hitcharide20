import 'package:flutter/material.dart';
import 'package:workavane/brand_colors.dart';
import 'package:workavane/screens/mainpage.dart';

import 'package:workavane/screens/vehicleinfo.dart';

class DriverRider extends StatefulWidget {

  static const String id = 'choose';
  @override
  _DriverRiderState createState() => _DriverRiderState();
}

class _DriverRiderState extends State<DriverRider> {

     

  @override
  Widget build(BuildContext context) {


    

    return MaterialApp(  
      home: Scaffold(  
          appBar: AppBar(  
            title: Text('Choose your Preference'),  
          ),  
          body: Center(child: Column(children: <Widget>[  
            Container(  
              margin: EdgeInsets.all(25),  
              child: FlatButton(  
                color: BrandColors.colorGreen,
                child: Text('Driver', style: TextStyle(fontSize: 20.0,color:Colors.white ),),  
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>VehicleInfoPage()));
                },  
              ),  
            ),  
            Container(  
              margin: EdgeInsets.all(25),  
              child: FlatButton(  
                child: Text('Rider', style: TextStyle(fontSize: 20.0),),  
                color: BrandColors.colorGreen,  
                textColor: Colors.white,  
                onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MainPage()));

                },  
              ),  
            ),  
          ]  
         ))  
      ),  
    );  
  }
}