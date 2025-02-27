import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/screens/auth/login_screen.dart';
import 'package:flutter_firebase_connection/screens/landing/landing_page.dart';

class SplashServices {
  final auth = FirebaseAuth.instance;
  late final isUserLoggedIn = auth.currentUser;

  void isLogin(BuildContext context) {
    if (isUserLoggedIn == null) {
      Timer(
          const Duration(seconds: 13),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LandingPage())));
    }
  }
}
