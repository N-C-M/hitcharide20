import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

const email = 'Email-Id';
const phone = 'My phone nuber is 2244';

class Profile extends StatelessWidget {
  const Profile({
    Key key,
  }) : super(key: key);

  void _showDialog(BuildContext context, {String title, String msg}) {
    final dialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: <Widget>[
        RaisedButton(
          color: Colors.teal,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Close',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (x) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://prod.cdn.earlygame.com/uploads/images/_imageBlock/Valorant-Jett-artwork.jpg?mtime=20200527162418&focal=none&tmtime=20201005083153'),
            ),
            Text('Ivde Name Varanam',
                style: GoogleFonts.pacifico(
                    fontSize: 40,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold)),
            Text(
              'RIDER',
              style: GoogleFonts.sourceSansPro(
                  fontSize: 30,
                  color: Colors.teal[60],
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: Divider(
                color: Colors.teal.shade700,
              ),
            ),
            InfoCard(
              text: phone,
              icon: Icons.phone,
              onPressed: () {},
            ),
            InfoCard(
              text: email,
              icon: Icons.email,
              onPressed: () {},
            ),
            /*InfoCard(
              text: 'than aaruva?',
              icon: Icons.web,
              onPressed: () {},
            ),
            InfoCard(
              text: 'enthelum venel ida',
              icon: Icons.location_city,
              onPressed: null,
            ),*/
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard({
    @required this.text,
    @required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white60,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.blueGrey,
          ),
          title: Text(
            text,
            style: GoogleFonts.sourceSansPro(fontSize: 20, color: Colors.blueGrey),
          ),
        ),
      ),
    );
  }
}
