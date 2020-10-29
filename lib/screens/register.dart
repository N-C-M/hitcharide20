import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workavane/widgets/TaxiButton.dart';

import 'loginpage.dart';

class Register extends StatelessWidget {
    static const String id='register';

 final FirebaseAuth _auth= FirebaseAuth.instance;

 var fullname=new TextEditingController();
 var email =new TextEditingController();
 var phno=new TextEditingController();
 var password=new TextEditingController();

 final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }
 
 void registerUser() async{

final User user = (await _auth.createUserWithEmailAndPassword(  // auth aan monei correct aaitokke fill cheyne testingnu
      email: email.text,
      password: password.text,
    )

    ).user;
    if(user != null){
      print('regsitration successful');
    }
 }
 


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:<Widget>[
              SizedBox(
                height:70,
              ),
              Image(
                alignment: Alignment.center,
                height: 100.0,
                width: 100.0,
                image: AssetImage('images/login_icon.png'),
                ),
              SizedBox(
                height:40,
              ),
             Text('Create an Account', // 

             textAlign:TextAlign.center,
             style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
             ),
             
            Padding(
              padding: EdgeInsets.all(20.0),
              child:Column(
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
                                    color: Colors.grey,
                                    fontSize: 10.0
                                )
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height:10,),


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
                                    color: Colors.grey,
                                    fontSize: 10.0
                                )
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
              SizedBox(
                height:10,
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
                                    color: Colors.grey,
                                    fontSize: 10.0
                                )
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
              SizedBox(
                height:10,
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
                 onPressed: (){
                   // korch data validation edkatte

                   
                   if(fullname.text.length<3){
                     showSnackBar('Provide a valid FullName');
                     return;

                   }
                   if(phno.text.length<10){
                   showSnackBar('Enter a valid Mobile Number');}

                   if(!email.text.contains('@')){
                            showSnackBar('Please provide a valid email address');
                            return;
                          }

                   if(password.text.length < 8){
                            showSnackBar('password must be at least 8 characters');
                            return;
                          }
// net undo?

                   //
                   registerUser();
                   
                 },
               )


                ],
              ) 
            ),

            FlatButton(
                      onPressed: (){
                        Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
                      },
                        child: Text('Already have an account? Log In here')
                    ),

             

            ],
          ),
        ),
      )
      
    );
  }
}

