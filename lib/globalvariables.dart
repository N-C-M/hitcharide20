//String mapkey="AIzaSyAzLpKCifErLVEp69BQvV2y2morxyM3lms";

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workavane/datamodels/user.dart';

String mapkey="AIzaSyCGDOgE33dc-6UHtIAptXSAVZRogFvV8Hs";

  final CameraPosition googlePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


   FirebaseUser currentFirebaseUser;

   User currentUserInfo;