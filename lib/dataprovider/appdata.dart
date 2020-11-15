import 'package:flutter/material.dart';
import 'package:workavane/datamodels/address.dart';
import 'package:workavane/datamodels/user.dart';

class AppData extends ChangeNotifier{

  Address pickupAddress;

  Address destinationAddress;
  User userinfo;
  String fullname='Hello';
  String mailvalue= 'hello@gmail.com';
  String phone='956121425';

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
  void updatePhn(String phonenum){
    phone=phonenum;
    notifyListeners();

  }
}