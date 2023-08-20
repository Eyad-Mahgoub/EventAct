import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project5/Models/account.dart';
import 'package:project5/home_screen.dart';
import 'package:project5/signup_screen.dart';
import 'package:project5/Services/firecloud.dart';

class StuMVVM {
  static Query<Map<String, dynamic>> getEvents()  {
    return FireCloud.getEvents();
  }

  static Query<Map<String, dynamic>> getSavedEventsByDate(List<String> user)  {
    return FireCloud.getSavedEventsByDate(user);
  }

  static Query<Map<String, dynamic>> getSavedEventsByClub(List<String> user)  {
    return FireCloud.getSavedEventsByClub(user);
  }

  static addSaved(List<String> saved, String email) async {
    FireCloud.addtoSaved(saved, email);
  }

  static remSaved(List<String> saved, String email) async {
    FireCloud.remfromSaved(saved, email);
  }

}