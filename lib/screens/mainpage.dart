import 'dart:async';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:outline_material_icons/outline_material_icons.dart';



import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workavane/brand_colors.dart';
import 'package:workavane/datamodels/directiondetails.dart';
import 'package:workavane/datamodels/nearbydriver.dart';
import 'package:workavane/dataprovider/appdata.dart';
import 'package:workavane/globalvariables.dart';
import 'package:workavane/helper/firehelper.dart';

import 'package:workavane/helper/helperMethods.dart';
import 'package:workavane/screens/searchride.dart';
import 'package:workavane/styles/styles.dart';
import 'package:workavane/widgets/BrandDivider.dart';
import 'package:workavane/widgets/TaxiButton.dart';

class MainPage extends StatefulWidget {

  static const String id = 'mainpage';

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage > with TickerProviderStateMixin{
  // This widget is the root of your application.
    double searchSheetHeight = (Platform.isIOS) ? 300 : 275;

       GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

    Completer<GoogleMapController> _controller = Completer();
    GoogleMapController map;
    double mapBottomPadding=0;
    double rideDetailsSheetHeight = 0;
    double requestSheetHeight=0;


    List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};

  Set<Marker> _Markers = {};
  Set<Circle> _Circles = {};

  BitmapDescriptor nearbyIcon;

    var geoLocator = Geolocator();//Fetch Riders Position
    Position currentPosition;

  DirectionDetails tripDirectionDetails;

    bool drawerCanOpen = true;

  DatabaseReference rideRef;

  bool nearbyDriversKeysLoaded=false;


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

    String address= await HelperMethods.findCordinateAddress(position,context);
    
    //make position
    //print(address);
    startGeofireListener();

    // confirm location
    

  }
  
 

  

 

   void showDetailSheet () async {
     await getDirection();
     setState(() {
       searchSheetHeight=0;
       rideDetailsSheetHeight=(Platform.isAndroid) ? 235 : 260;
       mapBottomPadding=(Platform.isAndroid) ? 240 : 230;
       drawerCanOpen=false;
       
     });
  }

  void showRequestingSheet(){
    setState(() {

      rideDetailsSheetHeight = 0;
      requestSheetHeight = (Platform.isAndroid) ? 195 : 220;
      mapBottomPadding = (Platform.isAndroid) ? 200 : 190;
      drawerCanOpen = true;

    });

    createRideRequest();
  }

  void createMarker(){
    if(nearbyIcon == null){

      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2,2));
      BitmapDescriptor.fromAssetImage(
          imageConfiguration, (Platform.isIOS)
          ? 'images/car_ios.png'
          : 'images/car_android.png'
      ).then((icon){
        nearbyIcon = icon;
      });
    }
  }

  @override
   void initState() {
    super.initState();
    HelperMethods.getCurrentUserInfo();
  }


   
  @override
  Widget build(BuildContext context) {

        createMarker();


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
          initialCameraPosition: googlePlex,
          myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: _polylines,
            markers: _Markers,
            circles: _Circles,

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
                
                if(drawerCanOpen){
                  scaffoldKey.currentState.openDrawer();
                }
                else{
                  resetApp();
                }                
                
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
                  child: Icon((drawerCanOpen) ? Icons.menu : Icons.arrow_back, color: Colors.black87,),


                ),
              ),
            ),
          ),
          Positioned(

            left: 0,
            right:0,
            bottom: 0,

            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
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
                              GestureDetector(
                                onTap: ()async{
                                  var response=await Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage(),
                                  )
                                  );
                                  if(response=='getDirection'){
                                    showDetailSheet();
                                  }

                                },

                                  child: Container(
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
        
          ),
            ),
        
      ),

      //Rider Details

      Positioned(
          left:0,
          right:0,
          bottom:0,
              child: AnimatedSize(
                vsync: this,
                duration: new Duration(milliseconds: 150),
                              child: Container(
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15.0, // soften the shadow
                          spreadRadius: 0.5, //extend the shadow
                          offset: Offset(
                            0.7, // Move to right 10  horizontally
                            0.7, // Move to bottom 10 Vertically
                          ),
                        )
                      ],

          ),
          height:rideDetailsSheetHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical:18,),
            child: Column(
                children:<Widget>[
                  Container(
                    width:double.infinity,
                    color:BrandColors.colorTextLight,
                    child: Padding(
                         padding: EdgeInsets.symmetric(horizontal:20),
                                    child: Row(children: [
                        Image.asset('images/taxi.png', height: 70, width: 70,),
                                      SizedBox(width: 16,),
                        Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Taxi', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),
                                          Text((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : '', style: TextStyle(fontSize: 16, color: Colors.white),)



                                        ],
                                      ),
                      
                                          Expanded(
                                            
                                                                              child: Container(

                                            ),
                                          ),
                              Text((tripDirectionDetails != null) ? '\$${HelperMethods.estimateFares(tripDirectionDetails)}' : '', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),

                      ],),
                    ),
                  ),
                SizedBox(
                  height:22,
                ),
                Padding(
                  padding:EdgeInsets.symmetric(horizontal:16),
                  child: Row(children: [
                    Icon(FontAwesomeIcons.moneyBill, size: 18, color: BrandColors.colorTextLight,),
                                SizedBox(width: 16,),
                                Text('Cash'),
                                SizedBox(width: 5,),
                                Icon(Icons.keyboard_arrow_down, color: BrandColors.colorTextLight, size: 16,),

                  ],),
                ),
                 SizedBox(height:20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal:28),
                        child: TaxiButton(
                          title:('SEARCH A RIDE'),
                          color:Colors.blueGrey,
                          
                          onPressed: (){
                            showRequestingSheet();

                          },
                        ),
                      ),

                ],
            ),
          ),
        ),
              ),
      ),
    
    Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0, // soften the shadow
                      spreadRadius: 0.5, //extend the shadow
                      offset: Offset(
                        0.7, // Move to right 10  horizontally
                        0.7, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                height: requestSheetHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(height: 10,),

                      SizedBox(
                        width: double.infinity,
                        child: TextLiquidFill(
                        text: 'Searching Nearby Rides...',
                        waveColor: BrandColors.colorTextSemiLight,
                        boxBackgroundColor: Colors.white,
                        textStyle: TextStyle(
                          color: BrandColors.colorText,
                          fontSize: 22.0,
                          fontFamily: 'Brand-Bold'
                        ),
                        boxHeight: 40.0,
                      ),
                      ),

                      SizedBox(height: 20,),

                      GestureDetector(
                        onTap: (){
                          cancelRequest();
                          resetApp();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(width: 1.0, color: BrandColors.colorLightGrayFair),

                          ),
                          child: Icon(Icons.close, size: 25,),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        width: double.infinity,
                        child: Text(
                          'Cancel Search',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ),
    
    ],
  ),
    );

}
    Future<void> getDirection() async {

      var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =  Provider.of<AppData>(context, listen: false).destinationAddress;

    var pickLatLng = LatLng(pickup.latitude, pickup.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);
    

        var thisDetails = await HelperMethods.getDirectionDetails(pickLatLng, destinationLatLng);
        setState(() {
                  tripDirectionDetails=thisDetails;

        });
           

     //print(thisDetails.encodedPoints);
      PolylinePoints polylinePoints = PolylinePoints();
   List<PointLatLng> results = polylinePoints.decodePolyline(thisDetails.encodedPoints);
   polylineCoordinates.clear();
   if(results.isNotEmpty){
     // loop through all PointLatLng points and convert them
     // to a list of LatLng, required by the Polyline
     results.forEach((PointLatLng point) {
       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
     });
   }

   _polylines.clear();

   setState(() {

     Polyline polyline = Polyline(
       polylineId: PolylineId('polyid'),
       color: Color.fromARGB(255, 95, 109, 237),
       points: polylineCoordinates,
       jointType: JointType.round,
       width: 4,
       startCap: Cap.roundCap,
       endCap: Cap.roundCap,
       geodesic: true,
     );

     _polylines.add(polyline);

   });

    LatLngBounds bounds;// make the line fit inside the map completely

    if(pickLatLng.latitude > destinationLatLng.latitude && pickLatLng.longitude > destinationLatLng.longitude){
      bounds = LatLngBounds(southwest: destinationLatLng, northeast: pickLatLng);
    }
    else if(pickLatLng.longitude > destinationLatLng.longitude){
      bounds = LatLngBounds(
        southwest: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, pickLatLng.longitude)
      );
    }
    else if(pickLatLng.latitude > destinationLatLng.latitude){
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
        northeast: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
      );
    }
    else{
      bounds = LatLngBounds(southwest: pickLatLng, northeast: destinationLatLng);
    }
        map.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
        Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: pickup.placeName, snippet: 'My Location'),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: destination.placeName, snippet: 'Destination'),
    );

    setState(() {
      _Markers.add(pickupMarker);
      _Markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickLatLng,
      fillColor: BrandColors.colorGreen,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: BrandColors.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: BrandColors.colorAccentPurple,
    );



    setState(() {
      _Circles.add(pickupCircle);
      _Circles.add(destinationCircle);
    });




}

void startGeofireListener() {
    
    Geofire.initialize('driversAvailable');
    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 5).listen((map) {
      
      print(map);

      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:

           NearbyDriver nearbyDriver = NearbyDriver();    //add destination to and frm db
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];
            FireHelper.nearbyDriverList.add(nearbyDriver);

            if(nearbyDriversKeysLoaded){
              updateDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            FireHelper.removeFromList(map['key']);
             updateDriversOnMap();
            break;

          case Geofire.onKeyMoved:
          // Update your key's location

            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];

            FireHelper.updateNearbyLocation(nearbyDriver);
            updateDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
          print('firehelper length:${FireHelper.nearbyDriverList.length}');

            nearbyDriversKeysLoaded = true;
            updateDriversOnMap();
            break;
        }
      }
    });
  }


void updateDriversOnMap(){

    setState(() {
     _Markers.clear();
    });

    Set<Marker> tempMarkers = Set<Marker>();

    for (NearbyDriver driver in FireHelper.nearbyDriverList){

      LatLng driverPosition = LatLng(driver.latitude, driver.longitude);
      Marker thisMarker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverPosition,
        icon: nearbyIcon,
        rotation: HelperMethods.generateRandomNumber(360),
      );

      tempMarkers.add(thisMarker);
    }

    setState(() {
      _Markers = tempMarkers;
    });

  }





void createRideRequest(){

    rideRef = FirebaseDatabase.instance.reference().child('rideRequest').push();//creating the table ride request

    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination = Provider.of<AppData>(context, listen: false).destinationAddress;

    Map pickupMap = {
      'latitude': pickup.latitude.toString(),
      'longitude': pickup.longitude.toString(),
    };

    Map destinationMap = {
      'latitude': destination.latitude.toString(),
      'longitude': destination.longitude.toString(),
    };

    Map rideMap = {
      'created_at': DateTime.now().toString(),
      'rider_name': currentUserInfo.fullName,
      'rider_phone': currentUserInfo.phone,
      'pickup_address' : pickup.placeName,
      'destination_address': destination.placeName,
      'location': pickupMap,
      'destination': destinationMap,
      'payment_method': 'card',
      'driver_id': 'waiting',
    };

    rideRef.set(rideMap);

    /*rideSubscription = rideRef.onValue.listen((event) async {

      //check for null snapshot
      if(event.snapshot.value == null){
        return;
      }

      //get car details
      if(event.snapshot.value['car_details'] != null){
        setState(() {
          driverCarDetails = event.snapshot.value['car_details'].toString();
        });
      }

      // get driver name
      if(event.snapshot.value['driver_name'] != null){
        setState(() {
          driverFullName = event.snapshot.value['driver_name'].toString();
        });
      }

      // get driver phone number
      if(event.snapshot.value['driver_phone'] != null){
        setState(() {
          driverPhoneNumber = event.snapshot.value['driver_phone'].toString();
        });
      }


      //get and use driver location updates
      if(event.snapshot.value['driver_location'] != null){

        double driverLat = double.parse(event.snapshot.value['driver_location']['latitude'].toString());
        double driverLng = double.parse(event.snapshot.value['driver_location']['longitude'].toString());
        LatLng driverLocation = LatLng(driverLat, driverLng);

        if(status == 'accepted'){
          updateToPickup(driverLocation);
        }
        else if(status == 'ontrip'){
          updateToDestination(driverLocation);
        }
        else if(status == 'arrived'){
          setState(() {
            tripStatusDisplay = 'Driver has arrived';
          });
        }

      }


      if(event.snapshot.value['status'] != null){
        status = event.snapshot.value['status'].toString();
      }

      if(status == 'accepted'){
        showTripSheet();
        Geofire.stopListener();
        removeGeofireMarkers();
      }

      if(status == 'ended'){

        if(event.snapshot.value['fares'] != null) {

          int fares = int.parse(event.snapshot.value['fares'].toString());

          var response = await showDialog(
              context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => CollectPayment(paymentMethod: 'cash', fares: fares,),
          );

          if(response == 'close'){
            rideRef.onDisconnect();
            rideRef = null;
            rideSubscription.cancel();
            rideSubscription = null;
            resetApp();
          }

        }
      }

    });*/

  }
   void cancelRequest(){
    rideRef.remove();

    //setState(() {
      //appState = 'NORMAL';
    //});
  }



resetApp(){

    setState(() {

      polylineCoordinates.clear();
      _polylines.clear();
      _Markers.clear();
      _Circles.clear();
      rideDetailsSheetHeight = 0;
      requestSheetHeight = 0;
      //tripSheetHeight = 0;
      searchSheetHeight = (Platform.isAndroid) ? 275 : 300;
      mapBottomPadding = (Platform.isAndroid) ? 280 : 270;
      drawerCanOpen = true;

     /* status = '';
      driverFullName = '';
      driverPhoneNumber = '';
      driverCarDetails = '';
      tripStatusDisplay = 'Driver is Arriving';*/

    });

   setupPositionLocator();

  }

}
