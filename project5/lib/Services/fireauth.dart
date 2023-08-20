import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project5/Models/account.dart';
import 'package:project5/home_screen.dart';
import 'package:project5/signup_screen.dart';

class FireAuth {
  
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }


  static FirebaseAuth getInstance()  {
    return FirebaseAuth.instance;
  }

  static Future<User?> loginUsingEmailPassword({required String email, required String password, required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;

    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found"){
        print("no user found for that email");
      }
    }

    return user;
  }

  static Future<Account?> getUserType(String email) async {

    
    await FirebaseFirestore.instance.collection("Users").doc(email).get()
    .then((value){
      Account? acc = Account(value['first name'], value['last name'], value['age'], value['type'], email, List.from(value["saved"]));
      return acc;
    });
  }


}