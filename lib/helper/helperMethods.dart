import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workavane/datamodels/address.dart';
import 'package:workavane/datamodels/directiondetails.dart';
import 'package:workavane/datamodels/user.dart';
import 'package:workavane/dataprovider/appdata.dart';
import 'package:workavane/helper/RequestHelper.dart';
import 'package:workavane/globalvariables.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;




/*class HelperMethods{

  static Future<String> findCordinateAddress(Position position, context )async{
    String placeAddress = '';

   var connectivityResult = await Connectivity().checkConnectivity();
   if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
     return placeAddress;
   }
     String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey';

       var response = await RequestHelper.getRequest(url);
       if(response != 'failed'){
     placeAddress = response['results'][0]['formatted_address'];
     Address pickupAddress = new Address();

     pickupAddress.longitude = position.longitude;
     pickupAddress.latitude = position.latitude;
     pickupAddress.placeName = placeAddress;

     Provider.of<AppData>(context, listen: false).updatePickupAddress(pickupAddress);

     

   }

   return placeAddress;


  }

  }*/
  class HelperMethods{

    static void getCurrentUserInfo() async{

    FirebaseUser currentFirebaseUser = await FirebaseAuth.instance.currentUser();// Firebaseuser or USer nokk
    String userid = currentFirebaseUser.uid;

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/$userid');
    userRef.once().then((DataSnapshot snapshot){

      if(snapshot.value != null){
        currentUserInfo = User.fromSnapshot(snapshot);
        print('my name is ${currentUserInfo.fullName}');
      }

    }
    );
  }
  

  

 static Future<String> findCordinateAddress(Position position,context) async {

   String placeAddress = '';

   var connectivityResult = await Connectivity().checkConnectivity();
   if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
     return placeAddress;
   }

   String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey';

   var response = await RequestHelper.getRequest(url);

   if(response != 'failed'){

     placeAddress = response['results'][0]['formatted_address'];

     Address pickupAddress=new Address();

     pickupAddress.longitude=position.longitude;
     pickupAddress.latitude=position.latitude;
     pickupAddress.placeName= placeAddress;
     //print('ooo');
     print(pickupAddress.placeName);
     
     Provider.of<AppData>(context, listen: false).updatePickupAddress(pickupAddress);


   }

   return placeAddress;

  }

  static Future<DirectionDetails> getDirectionDetails(LatLng startPosition, LatLng endPosition) async {

   String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapkey';

   var response = await RequestHelper.getRequest(url);

   if(response == 'failed'){
     return null;
   }

   DirectionDetails directionDetails = DirectionDetails();

   directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
   directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];

   directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
   directionDetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];

   directionDetails.encodedPoints = response['routes'][0]['overview_polyline']['points'];

   return directionDetails;

  }

  static int estimateFares (DirectionDetails details){
   // per km = 6rs,
    // per minute = 1.5 rs,
    // base fare = 12rs,

    double baseFare = 12;
    double distanceFare = (details.distanceValue/1000) * 6;
    //double timeFare = (details.durationValue / 60) * 1.5;

    double totalFare = baseFare + distanceFare ;

    return totalFare.truncate();
  }

  static double generateRandomNumber(int max){

    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }

  static sendNotification(String token, context, String ride_id) async {

    var destination = Provider.of<AppData>(context, listen: false).destinationAddress;

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverKey,
    };

    Map notificationMap = {
      'title': 'NEW TRIP REQUEST',
      'body': 'Destination, ${destination.placeName}'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_id' : ride_id,
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token
    };

    var response = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: headerMap,
      body: jsonEncode(bodyMap)
    );

    print(response.body);

  }

  static void getriderInfo(context){
    DatabaseReference ridernew= FirebaseDatabase.instance.reference().child('users/${currentFirebaseUser.uid}/fullname');
    



    ridernew.once().then((DataSnapshot snapshot){

      if(snapshot.value != null){
        String dname = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateName(dname);
      }
      
      });

     
  }

  static void getmail(context){
        DatabaseReference mail= FirebaseDatabase.instance.reference().child('users/${currentFirebaseUser.uid}/email');
         mail.once().then((DataSnapshot snapshot){

      if(snapshot.value != null){
        String mailval = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateMail(mailval);
      }
      
      });


  }

  static void getphone(context){

    DatabaseReference phonenum= FirebaseDatabase.instance.reference().child('users/${currentFirebaseUser.uid}/phone');         
    phonenum.once().then((DataSnapshot snapshot){

      if(snapshot.value != null){
        String phonenumber = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updatePhn(phonenumber);
      }
      
      });


  }


  }

