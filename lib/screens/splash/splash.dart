import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/screens/splash/splash_screen_one.dart';
import 'package:flutter_firebase_connection/screens/splash/splash_screen_three.dart';
import 'package:flutter_firebase_connection/screens/splash/splash_screen_two.dart';
class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold( body:
      PageView(
        controller: _pageController,
        children: [
          SplashScreenOne(_pageController),
          SplashScreenTwo(_pageController),
          SplashScreenThree(_pageController)
        ],
      ),
    );
  }
}
