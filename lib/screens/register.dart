import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workavane/screens/driverrider.dart';
import 'package:workavane/widgets/TaxiButton.dart';

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
          context, DriverRider.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFB0BEC5), Color(0xFFECEFF1)])),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Image(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('images/login_icon.png'),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Create an Account', //

                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          // Full Name
                          controller: fullname,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Full Name',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 10.0)),
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          // The Email Field
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email address',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 10.0)),
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          // Phone Number
                          controller: phno,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 10.0)),
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          //The Password Field
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 10.0)),
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TaxiButton(
                          title: 'REGISTER',
                          color: Colors.blueGrey,
                          onPressed: () async {
                            // korch data validation edkatte

                            if (fullname.text.length < 3) {
                              showSnackBar('Provide a valid FullName');
                              return;
                            }
                            if (phno.text.length < 10) {
                              showSnackBar('Enter a valid Mobile Number');
                            }

                            if (!email.text.contains('@')) {
                              showSnackBar(
                                  'Please provide a valid email address');
                              return;
                            }

                            if (password.text.length < 8) {
                              showSnackBar(
                                  'password must be at least 8 characters');
                              return;
                            }
                            // net undo?

                            var connectivityResult =
                                await Connectivity().checkConnectivity();
                            if (connectivityResult !=
                                    ConnectivityResult.mobile &&
                                connectivityResult != ConnectivityResult.wifi) {
                              showSnackBar('No internet connectivity');
                              return;
                            }

                            //
                            registerUser();
                          },
                        )
                      ],
                    )),
                FlatButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.id, (route) => false);
                    },
                    child: Text('Already have an account? Log In here')),
              ],
            ),
          ),
        ));
  }
}
