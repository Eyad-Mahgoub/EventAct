import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project5/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _acctypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          const Text("EventAct", style: TextStyle(
            color: Colors.black,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),),
          const Text("Create account", style: TextStyle(
            color: Colors.black,
            fontSize: 44.0,
            fontWeight: FontWeight.bold,
          ),),
          const SizedBox(
            height: 44.0,
          ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "User Email",
              prefixIcon: Icon(Icons.mail, color: Colors.black,),
            ),
          ),
          const SizedBox(height: 26.0,),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(Icons.lock, color: Colors.black,),
            ),
          ),
          const SizedBox(height: 26.0,),
          TextField(
            controller: _acctypeController,
            decoration: const InputDecoration(
              hintText: "Account Type",
              prefixIcon: Icon(Icons.lock, color: Colors.black,),
            ),
          ),
          
          
          /*DropdownButton(
            items: const [
              DropdownMenuItem(child: Text("Student"), value: "1"),
              DropdownMenuItem(child: Text("OrgCom"), value: "2"),
            ] ,
            value: _acctype,
            onChanged: (String? newval) {
              if (newval is String){
                setState(() {_acctype = newval;});
              }
            }
          ),*/
          const SizedBox(height: 88.0,),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: const Color(0xFF0069FE),
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                try{
                  final newUser = auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
                  if (newUser != null) {
                    FirebaseFirestore.instance.collection('Users').doc(_emailController.text).set({
                      "type": _acctypeController.text,
                      "saved": ["Coding Bootcamp", "An Event"],
                    });
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));

                  }
                } catch (e) {
                  //print(e);
                }
              }, 
              child: const Text("Register", style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),),
            ),
          ),
        ],
      ),
    );
    
  }
}