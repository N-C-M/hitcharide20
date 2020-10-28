import 'package:flutter/material.dart';

import 'loginpage.dart';

class Register extends StatelessWidget {

  static const String id='regsiter';
    @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                      TextField(      // Full Name
                            
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


                      TextField(      // The Email Field
                            
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

              TextField(      // Phone Number
                            
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
              TextField(                  //The Password Field
                            
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


               RaisedButton(   // The Register Button
                 shape: new RoundedRectangleBorder(
                   borderRadius: new BorderRadius.circular(25),
                 ),
                 color:Colors.blueGrey,
                 textColor: Colors.white,
                 child:Container(
                   height:50,
                   child: Center(
                     child: Text(
                       'REGISTER',
                       style: TextStyle(fontSize: 18,
                       fontFamily: 'Brand-Bold')
                     ),
                   ),
                 ),
                 
                 onPressed: (){

                 }),

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
