import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';


class Scheduled extends StatefulWidget {
  @override
  _ScheduledState createState() => _ScheduledState ();
}

class _ScheduledState extends State<Scheduled> {
  Query _ref;

  @override
  void initState() {
    
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('schedule')
        .orderByChild('drivername');
  }

  Widget _buildContactItem({Map contact}) {
    //Color typeColor = getTypeColor(contact['type']);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      height: 100,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.blueGrey,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['drivername'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.phone_iphone,
                color: Colors.green,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['driverphone'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 15),
              Icon(
                Icons.date_range,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['date'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 6,
              ),
              Icon(
                Icons.timer,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['time'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height:5),
          Row(
            children: [
              Icon(
                Icons.location_city,
                color: Colors.blue,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                'Start:${contact['pickpt']}',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 15),
              Icon(
                Icons.location_city_rounded,
                color: Colors.orange,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                'End: ${contact['droppt']}',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Available Rides'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map contact = snapshot.value;
            return _buildContactItem(contact: contact);
          },
        ),
      ),
     /* floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return AddContacts();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),*/
    );
  }

  Color getTypeColor(String type) {
    Color color = Theme.of(context).accentColor;

    if (type == 'Work') {
      color = Colors.brown;
    }

    if (type == 'Family') {
      color = Colors.green;
    }

    if (type == 'Friends') {
      color = Colors.teal;
    }
    return color;
  }
}