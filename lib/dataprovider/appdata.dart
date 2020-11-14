import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workavane/datamodels/address.dart';
import 'package:workavane/globalvariables.dart';

class AppData extends ChangeNotifier{

  Address pickupAddress;

  Address destinationAddress;
  String fullname='Hello';
  String mailvalue='edef';

  void updatePickupAddress(Address pickup){
    
    pickupAddress=pickup;
    notifyListeners();

  }
  void updateDestinationAddress(Address destination){
    
    destinationAddress=destination;
    notifyListeners();

  }

    void updateName(String dname){
    fullname=dname;
    notifyListeners();
  }

  void updateMail(String mailval){
    mailvalue=mailval;
    notifyListeners();
  }
}