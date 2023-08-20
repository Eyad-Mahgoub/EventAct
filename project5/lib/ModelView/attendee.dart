import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project5/Models/account.dart';
import 'package:project5/Models/event.dart';
import 'package:project5/home_screen.dart';
import 'package:project5/signup_screen.dart';
import 'package:project5/Services/firecloud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:social_share/social_share.dart';


class AttendeesMVVM {
  Future sendEmail({required String email, required String message,}) async {
    final serviceid = "service_60tyz2e";
    final tempid = "template_g364f94";
    final userid = "rqyM4EaClAfpQzGoZ";

    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
        
      },
      body: json.encode({
        'service_id': serviceid,
        'template_id': tempid,
        'user_id': userid,
        'template_params': {
          "email": email,
          "message": message,
        }
      })
      );
      print("done");
  }
}