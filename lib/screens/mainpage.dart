import 'dart:async';
import 'package:outline_material_icons/outline_material_icons.dart';


import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workavane/widgets/BrandDivider.dart';

class MainPage extends StatefulWidget {

  static const String id = 'mainpage';

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  // This widget is the root of your application.
    Completer<GoogleMapController> _controller = Completer();
    GoogleMapController map;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      
      body: Stack(
        children: <Widget>[

        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kGooglePlex,

          onMapCreated:(GoogleMapController controller)
          {
            _controller.complete(controller);
            map=controller;

          } ,
          
          ),
          Positioned(
            left: 0,
            right:0,
            bottom: 0,

            child: Container(
              height: 240,
              decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.only(topLeft:Radius.circular(15),topRight: Radius.circular(15),),
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.black26,
                                 blurRadius:15.0,
                                 spreadRadius: 0.5,
                                 offset: Offset(
                                 0.7,
                                  0.7,
                                    )

                               )

                             ],

                  ),
                  child:Padding(
                    padding: const EdgeInsets.symmetric(horizontal:24,vertical:18,),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:<Widget>[
                            SizedBox(height:5,),
                             Text('Nice to see you!', style: TextStyle(fontSize: 10),),
                            Text('Where are you going?', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),

                            SizedBox(height:20.0,),
                            Container(
                              decoration: BoxDecoration(
                                color:Colors.white,
                                borderRadius:BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                 color: Colors.black26,
                                 blurRadius:5.0,
                                 spreadRadius: 0.5,
                                 offset: Offset(
                                 0.7,
                                  0.7,
                                    )

                               ),

                              
                                ],
                              ),
                              child:Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: <Widget>[
                                  Icon(Icons.search, color: Colors.blueAccent,),
                                  SizedBox(width: 10,),
                                  Text('Search Destination'),


                                ],),
                              ) ,

                              
                          ),
                          SizedBox(height:22,),
                          Row(children: [
                            Icon(OMIcons.home,color: Colors.grey,),
                            SizedBox(
                              width:12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Add Home'),
                              SizedBox(height: 3,),
                              Text('Your residential address',
                                style: TextStyle(fontSize: 11, color: Colors.grey,),
                              )
                              ],
                            )
                          ],),
                          SizedBox(height:6,),

                          BrandDivider(),
                                                    SizedBox(height:3,),


                          Row(children: [
                            Icon(OMIcons.workOutline,color: Colors.grey,),
                            SizedBox(
                              width:12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Add Work'),
                              SizedBox(height: 3,),
                              Text('Your office address',
                                style: TextStyle(fontSize: 11, color: Colors.grey,),
                              )
                              ],
                            )
                          ],),
                      ],
                    ),
                      ],
                  )
            ),
        
          )
        
      )
        ],
      ),
    );

  }
}
