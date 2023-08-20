import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project5/ModelView/attendee.dart';
import 'package:project5/Models/account.dart';
import 'package:project5/Models/event.dart';
import 'package:project5/edit_event_screen.dart';
import 'package:project5/home_screen.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;

class View_Attendees extends StatefulWidget {
  const View_Attendees({Key? key, required this.user, required this.event}) : super(key: key);

  final Event event;
  final Account user;

  @override
  State<View_Attendees> createState() => _View_AttendeesState(this.user, this.event);
}

class _View_AttendeesState extends State<View_Attendees> {
  
  final Account user;
  final Event event;
  

  _View_AttendeesState(this.user, this.event);
  final _auth = FirebaseAuth.instance;
  late CollectionReference events = FirebaseFirestore.instance.collection('Events/'+ event.name + '/Attendees');
  List<String> emails = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.keyboard_return),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>OrgHomeScreen(user: user)));
              }),
        ],
        title: Text('Attendees List'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: events.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError){
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting){
              return Text("Loading");
            }

            return ListView( 
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  //emails.add(data["email"]);
                  return Card( child: ListTile(
                    title: Text(data["first name"]+ " " + data["last name"]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12.0,),
                        RawMaterialButton(
                              fillColor: const Color(0xFF0069FE),
                              onPressed: () async {
                                final message = "This is a reminder regarding the " +event.name +" that will be held on "+event.date;
                                AttendeesMVVM().sendEmail(email: data["email"], message: message);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>OrgHomeScreen(user: user)));
                              },
                              child: const Text("Send Reminder", style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),),
                        ),
                        const SizedBox(height: 12.0,),
                      ]),
                  ));
              }).toList(),
              
            );
          } ,
        ),
        
        
          
        
        
    ); 
  }
}