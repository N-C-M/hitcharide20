import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workavane/widgets/TaxiButton.dart';
import 'package:workavane/screens/mainpage.dart';

import 'loginpage.dart';

class Register extends StatefulWidget {
  static const String id = 'register';

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullname = new TextEditingController();

  var email = new TextEditingController();

  var phno = new TextEditingController();

  var password = new TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void registerUser() async {
    /* showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Registering you in',),
    );*/
//hi
    final FirebaseUser user = (await _auth
            .createUserWithEmailAndPassword(
      // auth aan monei correct aaitokke fill cheyne testingnu
      email: email.text,
      password: password.text,
    )
            .catchError((ex) {
      //Navigator.pop(context);

      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);
    }) // handling error like non existing emails etc

        )
        .user;
    // Navigator.pop(context);

    if (user != null) {
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.reference().child('users/${user.uid}');

      //Prepare data to be saved on users table
      Map userMap = {
        'fullname': fullname.text,
        'email': email.text,
        'phone': phno.text,
        'pass': password.text, //comment it out
      };

      newUserRef.set(userMap);

      //Take the user to the mainPage
      Navigator.pushNamedAndRemoveUntil(
          context, MainPage.id, (route) => false);
    }
  
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
      
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 40,),
                Image(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('images/login_icon.png'),
                ),

                SizedBox(height: 40,),

                Text('Create a Rider\'s Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[

                      // Fullname
                      TextField(
                        controller: fullname,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Full name',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10,),

                      // Email Address
                      TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email address',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10,),


                      // Phone
                      TextField(
                        controller: phno,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'Phone number',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10,),

                      // Password
                      TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 40,),

                      TaxiButton(
                        title: 'REGISTER',
                        color: Colors.blueGrey,
                        onPressed: () async{

                          //check network availability

                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                            showSnackBar('No internet connectivity');
                            return;
                          }

                          if(fullname.text.length < 3){
                            showSnackBar('Please provide a valid fullname');
                            return;
                          }

                          if(phno.text.length < 10){
                            showSnackBar('Please provide a valid phone number');
                            return;
                          }

                          if(!email.text.contains('@')){
                            showSnackBar('Please provide a valid email address');
                            return;
                          }

                          if(password.text.length < 8){
                            showSnackBar('password must be at least 8 characters');
                            return;
                          }

                          registerUser();

                        },
                      ),

                    ],
                  ),
                ),

                FlatButton(
                    onPressed: (){
                      Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
                    },
                    child: Text('Already have an account? Log in')
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
