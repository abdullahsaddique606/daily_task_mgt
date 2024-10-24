import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_connection/constants/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static const String baseImagePath = "assets/images/";

  static double height(double percentage, BuildContext context) {
    double height = MediaQuery.of(context).size.height * 1;
    return height * percentage;
  }

  static double width(double percentage, BuildContext context) {
    double width = MediaQuery.of(context).size.width * 1;
    return width * percentage;
  }

  static Future<String> getUserName(String id) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userID);
    final userSnapshot = await userDoc.get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      return userData['name'] as String;
    } else {
      throw Exception('User not found');
    }
  }

  static void showToastMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.primaryColor,
        textColor: Colors.white);
  }

  static String? isValidEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Please enter email";
    }
    // Updated regular expression for email validation
    // RegExp regex = RegExp(
    //     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    // );
    // if (!regex.hasMatch(email)) {
    //   return "Invalid Email";
    // }
    return null;
  }

  static String? isValidPhoneNumber(String? number) {
    if (number!.isEmpty) {
      return "Enter Phone Number";
    } else if (!RegExp(r'^[0-9+\-() ]+$').hasMatch(number)) {
      return "Invalid Phone Number. Only numbers and symbols are allowed."; // (+, -, (), space) are allowed
    } else {
      return null;
    }
  }

  static String? isValidPassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Please enter a password";
    }
    if (password.length < 8) {
      return "Password must be at least 8 characters long";
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return "Password must contain at least one capital letter";
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Password must contain at least one special character";
    }
    return null;
  }
}
