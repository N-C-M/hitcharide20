import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workavane/brand_colors.dart';
import 'package:workavane/globalvariables.dart';
import 'package:workavane/widgets/AvailabilityButton.dart';
import 'package:workavane/widgets/TaxiButton.dart';
import 'package:workavane/widgets/confirmsheet.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Position currentPosition;

    var geoLocator = Geolocator();
      var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);
    String availabilityTitle = 'OFFER A RIDE';
  Color availabilityColor = BrandColors.colorGreen;

  bool isAvailable = false;


  void getCurrentPosition() async {

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
     currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));

  }


  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          padding: EdgeInsets.only(top: 135),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: googlePlex,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
            mapController = controller;

            getCurrentPosition();
          },
        ),
      Container(
          height: 135,
          width: double.infinity,
          color: Colors.white,
        
        ),
       
      /* Positioned(
         top:60,
         left:0,
         right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AvailabilityButton(
           title: 'OFFER A RIDE',
           color: Colors.green,
           onPressed: (){
            // GoOnline();
             //getLocationUpdates();

           },
         ),
                  ],
                ),
       ),*/
      Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AvailabilityButton(
                title: availabilityTitle,
                color: availabilityColor,
                onPressed: (){


                showModalBottomSheet(
                  isDismissible: false,
                    context: context,
                    builder: (BuildContext context) => ConfirmSheet(
                      title: (!isAvailable) ? 'OFFER A RIDE' : 'STOP ACCEPTING',
                      subtitle: (!isAvailable) ? 'You are about to become available to receive trip requests.Confirm to continue.': 'you will stop receiving new trip requests',

                      onPressed: (){

                        if(!isAvailable){
                          GoOnline();
                          getLocationUpdates();
                          Navigator.pop(context);

                          setState(() {
                            availabilityColor = Colors.red;
                            availabilityTitle = 'STOP ACCEPTING';
                            isAvailable = true;
                          });

                        }
                        else{

                          GoOffline();
                          Navigator.pop(context);
                          setState(() {
                            availabilityColor = BrandColors.colorGreen;
                            availabilityTitle = 'OFFER A RIDE';
                            isAvailable = false;
                          });
                        }

                      },
                    ),
                );

                },
              ),
            ],
          ),
        )

      ],
    );
  }

      
    

               

                /*showModalBottomSheet(
                  isDismissible: false,
                    context: context,
                    builder: (BuildContext context) => ConfirmSheet(
                      title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE',
                      subtitle: (!isAvailable) ? 'You are about to become available to receive trip requests': 'you will stop receiving new trip requests',

                      onPressed: (){

                        if(!isAvailable){
                          GoOnline();
                          getLocationUpdates();
                          Navigator.pop(context);

                          setState(() {
                            availabilityColor = BrandColors.colorGreen;
                            availabilityTitle = 'GO OFFLINE';
                            isAvailable = true;
                          });

                        }
                        else{

                          GoOffline();
                          Navigator.pop(context);
                          setState(() {
                            availabilityColor = BrandColors.colorOrange;
                            availabilityTitle = 'GO ONLINE';
                            isAvailable = false;
                          });
                        }

                      },
                    ),
                );*/

                
            
      

  
  void GoOnline(){
    Geofire.initialize('driversAvailable');
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

    tripRequestRef = FirebaseDatabase.instance.reference().child('users/${currentFirebaseUser.uid}/newtrip');
    tripRequestRef.set('waiting');

    tripRequestRef.onValue.listen((event) {//listen to value changes at the referece

    });

  }

  void GoOffline (){

    Geofire.removeLocation(currentFirebaseUser.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;

  }

  void getLocationUpdates(){

    homeTabPositionStream = geoLocator.getPositionStream(locationOptions).listen((Position position) {
      currentPosition = position;

      if(isAvailable){
        Geofire.setLocation(currentFirebaseUser.uid, position.latitude, position.longitude);
      }

      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));

    });

  }

  }