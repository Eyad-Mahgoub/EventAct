import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project5/home_screen_stu.dart';
import 'Models/event.dart';
import 'Models/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project5/Services/firecloud.dart';

class EditStudentProfile extends StatefulWidget {
  const EditStudentProfile({Key? key, required this.user}) : super(key: key);

  final Account user;

  @override
  State<EditStudentProfile> createState() {
    return _EditStudentProfileState(this.user);
  }
}

class _EditStudentProfileState extends State<EditStudentProfile> {
  late TextEditingController _fnController =
      TextEditingController(text: user.fn);
  late TextEditingController _lnController =
      TextEditingController(text: user.ln);
  late TextEditingController _ageController =
      TextEditingController(text: user.age);

  final Account user;
  _EditStudentProfileState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.keyboard_return),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => StuHomeScreen(user: user)));
              }),
        ],
        title: Text('Student Profile'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Profile",
            style: TextStyle(
              color: Colors.black,
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 36.0,
          ),
          const SizedBox(
            height: 36.0,
          ),
          TextField(
            controller: _fnController,
            decoration: const InputDecoration(
              hintText: "First Name",
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: _lnController,
            decoration: const InputDecoration(
              hintText: "Last Name",
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: _ageController,
            decoration: const InputDecoration(
              hintText: "Age",
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const SizedBox(
            height: 40.0,
          ),
          Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: const Color(0xFF0069FE),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                onPressed: () async {
                  FireCloud.EditStudentProfile(_fnController.text,
                      _lnController.text, _ageController.text, user.email);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => StuHomeScreen(
                            user: user,
                          )));
                },
                child: const Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
