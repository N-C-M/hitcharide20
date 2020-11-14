import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workavane/brand_colors.dart';

class contactPage extends StatefulWidget {
  @override
  _contactPageState createState() => _contactPageState();
}

class _contactPageState extends State<contactPage> {

  TextEditingController subject = new TextEditingController();
    TextEditingController content = new TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.colorLightGray,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 37, 10, 0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height:40),
              Text(
                "Contact Us",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              Text(
                  "Get in touch with us using the form below, or contact us directly using the give address"),
              Text(''),
              Text(
                'The Studio, 49 Laleham Road',
                textAlign: TextAlign.left,
              ),
              Text('Near LULU complex'),
              Text(''),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: <Widget>[
                    /*TextField(
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: 'Developers Email'),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),*/
                    TextField(
                      controller: subject,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: 'Subject'),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    TextField(
                      controller: content,
                      maxLines: 7,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: 'Write to us'),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    MaterialButton(
                      height: 60.0,
                      minWidth: double.infinity,
                      color: Color(0xff333333),
                      onPressed: () { 
                        _launchURL('Rog000@protonmail.com',
                          subject.text, content.text);
                          
                          subject.clear();
                          content.clear();
                          },
                          
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
