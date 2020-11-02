
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workavane/screens/driverrider.dart';
import 'package:workavane/screens/mainpage.dart';
import 'package:workavane/screens/register.dart';
import 'package:workavane/widgets/TaxiButton.dart';

class LoginPage extends StatefulWidget {

  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void login() async {

    //show please wait dialog

    /*showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Logging you in',),
    );*/
   

    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(//User akkanm
      email: emailController.text,
      password: passwordController.text,
    ).catchError((ex){

      //check error and display message
      //Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);

    })).user;
     

    if(user != null){
      // verify login
      DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/${user.uid}');
      userRef.once().then((DataSnapshot snapshot) {

        if(snapshot.value != null){     

          //Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, DriverRider.id, (route) => false);
        }
      });

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
                SizedBox(height: 70,),
                Image(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('images/login_icon.png'),
                ),

                SizedBox(height: 40,),

                Text('Sign In',
                textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[

                      TextField(
                        controller: emailController,
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

                      TextField(
                        controller: passwordController,
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
                        title: 'LOGIN',
                 color: Colors.blueGrey,
                 onPressed: ()async{
                   // net undo?

                  var connectivityResult = await Connectivity().checkConnectivity();
                  if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi)
                  {
                      showSnackBar('No internet connectivity');
                            return;
                          }
                  if(!emailController.text.contains('@')){
                            showSnackBar('Please provide a valid email address');
                            return;
                          }

                   if(passwordController.text.length < 8){
                            showSnackBar('password must be at least 8 characters');
                            return;
                          }
                  login();
                   
                 },
               )

                    ],
                  ),
                ),

                FlatButton(
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, Register.id, (route) => false);
                  },
                    child: Text('Don\'t have an account, sign up here')
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}








