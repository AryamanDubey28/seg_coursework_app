import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Admin {
  final User? user;
  String class_pin;
  final bool mock;

  Admin({this.user, this.class_pin = "0000", this.mock = false});

  Future<String?> getCurrentUserId() async {
    //var user = await auth.currentUser;
    if (!mock) {
      var my_user = user;
      if (my_user != null) {
        return my_user.uid;
      } else {
        return null;
      }
    } else {
      return "123456"; //mock userId
    }
  }

  void createUserPIN(String pin) {
    class_pin = pin;
  }

  Future<String> getCurrentUserPIN() async {
    return class_pin;
  }

  void editCurrentUserPIN(String newPIN) async {
    class_pin = newPIN;
  }
}
