import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project5/Services/firecloud.dart';
import 'package:project5/home_screen.dart';
import 'Models/event.dart';
import 'Models/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ModelView/editevent.dart';


class EditEvent extends StatefulWidget {
  const EditEvent({Key? key, required this.event, required this.user}) : super(key: key);

  final Account user;
  final Event event;

  @override
  State<EditEvent> createState() {
    return _EditEventState(this.event, this.user);
  }
}

class _EditEventState extends State<EditEvent> {
  final Event event;
  final Account user;
  final ev = EditEventMVVM();
  _EditEventState(this.event, this.user);

  String? mtoken = " ";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
    });
  }
  void initState() {
    super.initState();
    getToken();
    ev.requestPermission();
    ev.loadFCM();
    ev.listenFCM();
  }
  


  late TextEditingController _dateController = TextEditingController(text: event.date);
  late TextEditingController _descController = TextEditingController(text: event.desc);



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
        title: Text('Edit Events'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(event.name, style: const TextStyle(
            color: Colors.black,
            fontSize: 44.0,
            fontWeight: FontWeight.bold,
          ),),
          const SizedBox(
            height: 44.0,
          ),
          TextField(
            controller: _dateController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Date of Event",
              prefixIcon: Icon(Icons.calendar_month, color: Colors.black,),
            ),
          ),
          const SizedBox(height: 26.0,),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              hintText: "Description",
              prefixIcon: Icon(Icons.badge, color: Colors.black,),
            ),
          ),

          const SizedBox(height: 88.0,),
          
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: const Color(0xFF0069FE),
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              onPressed: () {
                ev.editEvent(event.name, _dateController.text, _descController.text, user, mtoken);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>OrgHomeScreen(user: user,)));
              },
              child: const Text("Save", style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),),
            ),
          ),
          const SizedBox(height: 12.0,),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: const Color(0xFF0069FE),
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              onPressed: () {
                ev.deleteEvent(event.name, user, mtoken);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>OrgHomeScreen(user: user,)));
              } ,
              child: const Text("Delete event", style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),),
            ),
          ),
          
          ],
        ),
        
        ),
        
    );
  }
}