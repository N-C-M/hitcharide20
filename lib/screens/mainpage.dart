import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:outline_material_icons/outline_material_icons.dart';



import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workavane/helper/helperMethods.dart';
import 'package:workavane/styles/styles.dart';
import 'package:workavane/widgets/BrandDivider.dart';

class MainPage extends StatefulWidget {

  static const String id = 'mainpage';

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  // This widget is the root of your application.
    double searchSheetHeight = (Platform.isIOS) ? 300 : 275;

       GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

    Completer<GoogleMapController> _controller = Completer();
    GoogleMapController map;
    double mapBottomPadding=0;

    var geoLocator = Geolocator();//Fetch Riders Position
    Position currentPosition;

   /* void setupPositionLocator() async {

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
        map.animateCamera(CameraUpdate.newCameraPosition(cp));

    


  }*/
   

  void setupPositionLocator() async {
    Position position = await geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    map.animateCamera(CameraUpdate.newCameraPosition(cp));

    String address= await HelperMethods.findCordinateAddress(position);
    print(address);

    // confirm location
    

  }
  
 

  

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      key:scaffoldKey,

      drawer: Container( // Side Navigation
        width: 250,
        color: Colors.white,
        child:Drawer(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[

              Container(
                color: Colors.white,
                child:DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child:Row(
                    children: <Widget>[
                      Image.asset('images/user_icon.png', height: 60, width: 60,),
                      SizedBox(width: 15,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Ningal Ith Kanu', style: TextStyle(fontSize: 15, fontFamily: 'Brand-Bold'),),
                          SizedBox(height: 5,),
                          Text('View Profile'),
                        ],
                      )
                      

                    ],
                  ),

                ) ,
                ),
                BrandDivider(),
                SizedBox(height: 10,),

              ListTile(
                leading: Icon(OMIcons.cardGiftcard),
                title: Text('Free Rides', style: kDrawerItemStyle,),
              ),

              ListTile(
                leading: Icon(OMIcons.creditCard),
                title: Text('Payments', style: kDrawerItemStyle,),
              ),

              ListTile(
                leading: Icon(OMIcons.history),
                title: Text('Ride History', style: kDrawerItemStyle,),
              ),

              ListTile(
                leading: Icon(OMIcons.contactSupport),
                title: Text('Support', style: kDrawerItemStyle,),
              ),

              ListTile(
                leading: Icon(OMIcons.info),
                title: Text('About', style: kDrawerItemStyle,),
              ),


            ],
          ),
          
          ),
      ),




      
      body: Stack(
        children: <Widget>[

        GoogleMap(
          padding: EdgeInsets.only(bottom:mapBottomPadding),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,

          onMapCreated:(GoogleMapController controller)
          {
            _controller.complete(controller);
            map=controller;

            setState(() {
              mapBottomPadding=(Platform.isAndroid) ? 280 : 270;
            });

              setupPositionLocator();
          } ,
          
          ),

          // Menu Vende Menu
           Positioned(
            top: 44,
            left: 20,
            child: GestureDetector(
              onTap: (){
                
                  scaffoldKey.currentState.openDrawer();
                
                
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      )
                    )
                  ]
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.menu, color: Colors.black87,),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right:0,
            bottom: 0,

            child: Container(
              height: searchSheetHeight,
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
                          SizedBox(height:7,),

                          BrandDivider(),
                                                    SizedBox(height:5,),


                          Row(children: [
                            Icon(OMIcons.workOutline,color: Colors.grey,),
                            SizedBox(
                              width:12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                               //Text((Provider.of<AppData>(context).pickupAddress.placeName != null)?Provider.of<AppData>(context).pickupAddress.longitude:'Add Home'),
                                 Text('Changeam'), 
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
