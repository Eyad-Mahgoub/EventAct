import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project5/home_screen.dart';
import 'Models/account.dart';
import 'Services/firecloud.dart';


class AddEvent extends StatefulWidget {
  const AddEvent({Key? key, required this.user}) : super(key: key);
  final Account user;
  @override
  State<AddEvent> createState() => _AddEventState(this.user);
}

class _AddEventState extends State<AddEvent> {
  final Account user;
  _AddEventState(this.user);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _descController = TextEditingController();

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
          TextField(
            controller: _nameController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Event Name",
              prefixIcon: Icon(Icons.badge, color: Colors.black,),
            ),
          ),  
          const SizedBox(height: 26.0,),
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
              onPressed: () async {
                
                FireCloud.createEvent(_nameController.text, _dateController.text, _descController.text);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>OrgHomeScreen(user: user,)));
                                
              },
              child: const Text("Create", style: TextStyle(
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