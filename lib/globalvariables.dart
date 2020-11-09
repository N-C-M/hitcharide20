//String mapkey="AIzaSyAzLpKCifErLVEp69BQvV2y2morxyM3lms";

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workavane/datamodels/user.dart';

String serverKey="key=AAAAI172Nds:APA91bHyxvd3Xa_V6mnr_pqpTtFkPcFNLgp-oLW_0MhCD4TjLjzyEaJFSAn-Hg_cH8qcmDrpOwgg3NhDEWKH5VBFLQAh8MZ_8OWUrdlSpGZyk5tZMl-kE0ZHAha4gd6a0QtDjc0_ga_p";

String mapkey="AIzaSyCGDOgE33dc-6UHtIAptXSAVZRogFvV8Hs";

  final CameraPosition googlePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


   FirebaseUser currentFirebaseUser;

   User currentUserInfo;

     DatabaseReference tripRequestRef;
     StreamSubscription<Position> homeTabPositionStream;

  String driverIndest='h';
