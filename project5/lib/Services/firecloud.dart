import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project5/Models/account.dart';
import 'package:project5/home_screen.dart';
import 'package:project5/signup_screen.dart';

class FireCloud {
  static Future EditEvent(String date, String desc, String name) async {
    FirebaseFirestore.instance.collection('Events').doc(name).update({
      "Date" : date,
      "Description": desc,
      "Name": name, 
    });
   
  }

  static Future DeleteEvent(String name) async {

    FirebaseFirestore.instance.collection('Events').doc(name).delete();
    
  }

  static Future createEvent(String name, String date, String desc) async {
    FirebaseFirestore.instance.collection("Events").doc(name).set({
      "Name": name,
      "Date": date,
      "Description": desc
    });
  }

  static Query<Map<String, dynamic>> getEvents() {
    return FirebaseFirestore.instance.collection('Events').orderBy("Date");
  }
  
  static Query<Map<String, dynamic>> getSavedEventsByDate(List<String> user)  {
    return FirebaseFirestore.instance.collection("Events").where("Name", whereIn: user).orderBy("Date") ; 
  }

  static Query<Map<String, dynamic>> getSavedEventsByClub(List<String> user)  {
    return FirebaseFirestore.instance.collection("Events").where("Name", whereIn: user).orderBy("Name") ; 
  }

  static addtoSaved(List<String> saved, String email) async {
    FirebaseFirestore.instance.collection("Users").doc(email).update({"saved": saved});
  }

  static remfromSaved(List<String> saved, String email) async {
    FirebaseFirestore.instance.collection("Users").doc(email).update({"saved": saved});
  }

  static Future<String?> EditOrgProfile(
    String fn,
    String ln,
    String age,
    String email,
  ) async {
    FirebaseFirestore.instance.collection('Users').doc(email).update({
      "first name": fn,
      "last name": ln,
      "age": age,
    });
    String? str = "1";
    return str;
  }

  static Future<String?> EditStudentProfile(
    String fn,
    String ln,
    String age,
    String email,
  ) async {
    FirebaseFirestore.instance.collection('Users').doc(email).update({
      "first name": fn,
      "last name": ln,
      "age": age,
    });
    String? str = "1";
    return str;
  }


}