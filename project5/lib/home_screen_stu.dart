import 'package:project5/Services/FireAuth.dart';
import 'package:project5/Services/firecloud.dart';
import 'package:project5/add_event_screen.dart';
import 'package:project5/edit_student_profile.dart';
import 'Models/event.dart';
import 'Models/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project5/edit_event_screen.dart';
import 'package:project5/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project5/ModelView/HomeScreenStu.dart';


class StuHomeScreen extends StatefulWidget {
  const StuHomeScreen({Key? key, required this.user}) : super(key: key);
  final Account user;

  @override
  State<StuHomeScreen> createState() => _StuHomeScreenState(this.user);
}

class _StuHomeScreenState extends State<StuHomeScreen> {
  final _auth = FirebaseAuth.instance;
  var events = StuMVVM.getEvents();
  
  final Account user;
  _StuHomeScreenState(this.user);
  var criteria = ["Date", "Club"];
  String ddvalue = "Date";

  @override
  Widget build(BuildContext context) {
    final savedevents = StuMVVM.getSavedEventsByDate(user.saved);
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
            onPressed: (){
              //-----------------------//
              //      Profile icon     //
              //-----------------------//
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>EditStudentProfile(user: user,)));
            }, 
            icon: const Icon(Icons.account_circle)),
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _auth.signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));

                  //Implement logout functionality
                }),
          ],
          title: const Text('Student Home Page'),
          backgroundColor: Colors.lightBlueAccent,
          bottom: const TabBar(tabs: [
            Tab(text: 'Saved Events',icon: Icon(Icons.call)),
            Tab(text: 'All Events',icon: Icon(Icons.chat)),
          ]),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: savedevents.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError){
                    return const Text("Something went wrong");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting){
                    return const Text("Loading");
                  }

                  return ListView( 
                    scrollDirection: Axis.vertical,
                    
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return Card( child: ListTile(
                          title: Text(data["Name"]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 12.0,),
                              Text("Event Date: " + data["Date"]),
                              const SizedBox(height: 8.0,),
                              Text(data["Description"]),
                              const SizedBox(height: 12.0,),
                              RawMaterialButton(
                                fillColor: const Color(0xFF0069FE),
                                onPressed: () {
                                  setState(() {
                                    user.saved.remove(data["Name"]);
                                    StuMVVM.addSaved(user.saved, user.email);
                                  });
                                  
                                },
                                child: const Text("Remove From Saved Events",
                                    style: TextStyle(
                                    color: Colors.white,
                                  )
                                ),
                              ),
                              const SizedBox(height: 20.0,),
                            ]),
                        ));
                    }).toList(),
                    
                  );
                } ,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:ListView( 
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: [
                  
                  DropdownButton(
                    isExpanded: true,
                    value: ddvalue,
                    
                    items: criteria.map((String items){
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                        );
                    }).toList(), 
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == "Date"){
                          events = StuMVVM.getSavedEventsByDate(user.saved);
                          ddvalue = "Date";
                        } else {
                          events = StuMVVM.getSavedEventsByClub(user.saved);
                          ddvalue = "Club";
                        }
                      });  
                        
                    }
                    ),


                  StreamBuilder<QuerySnapshot>(
                  stream: events.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError){
                      return Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.waiting){
                      return Text("Loading");
                    }

                    return ListView( 
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          return Card( child: ListTile(
                            title: Text(data["Name"]),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 12.0,),
                                Text("Event Date: " + data["Date"]),
                                const SizedBox(height: 8.0,),
                                Text(data["Description"]),
                                const SizedBox(height: 12.0,),
                                RawMaterialButton(
                                  fillColor: const Color(0xFF0069FE),
                                  onPressed: () {                
                                    if (user.saved.contains(data["Name"])){
                                      
                                    } else {
                                      setState(() {
                                        user.saved.add(data["Name"]);
                                        StuMVVM.remSaved(user.saved, user.email);
                                      });
                                      
                                    }                                  
                                  },
                                  child: const Text("Add to Saved Events",
                                      style: TextStyle(
                                      color: Colors.white,
                                    )
                                  ),
                                ),
                                const SizedBox(height: 20.0,),
                              ]),
                          ));
                      }).toList(),
                      
                    );
                    
                  } ,
                ),
          

                ]
              )
            )
          ],
        )
        

    ));
  }
}