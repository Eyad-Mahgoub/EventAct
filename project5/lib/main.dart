import 'dart:convert';
import 'Services/FireAuth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project5/Models/account.dart';
import 'package:project5/home_screen.dart';
import 'package:project5/home_screen_stu.dart';
import 'package:project5/signup_screen.dart';


void main() async {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==  ConnectionState.done){
            return LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );

  }
}

class LoginScreen extends StatefulWidget{
  const LoginScreen({Key? key,}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  @override
  Widget build(BuildContext context){
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          const Text("EventAct Login", style: TextStyle(
            color: Colors.black,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),),
          const Text("Login", style: TextStyle(
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
          const SizedBox(height: 12.0,),
          const Text("Don't Remember your Password", style: TextStyle(
            color: Colors.blue,
          ),),
          
          const SizedBox(height: 88.0,),
          
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: const Color(0xFF0069FE),
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              onPressed: () async {
                User? user = await FireAuth.loginUsingEmailPassword(email: _emailController.text, password: _passwordController.text, context: context);            
                //print(user);
                if (user != null){
                  FirebaseFirestore.instance.collection("Users").doc(_emailController.text).get()
                  .then((value) {
                    // acc =  FireAuth.getUserType(_emailController.text);
                    FirebaseFirestore.instance.collection("Users").doc(_emailController.text).get()
                    .then((value){
                      Account acc = Account(value['first name'], value['last name'], value['age'], value['type'], _emailController.text, List.from(value['saved']));
                      if (acc.acctype == '1'){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>OrgHomeScreen(user: acc,)));
                      }else if (acc.acctype == '2'){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>StuHomeScreen(user: acc)));
                      }
                    });
                    
                  });                 
                }  
              },
              child: const Text("Login", style: TextStyle(
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
              onPressed: () async {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Signup()));
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