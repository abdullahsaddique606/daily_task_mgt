import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart ';
import 'package:flutter_firebase_connection/constants/utils.dart';
import 'package:flutter_firebase_connection/services/splash_services.dart';
import 'package:flutter_firebase_connection/screens/auth/login_screen.dart';
import 'package:flutter_firebase_connection/screens/landing/landing_page.dart';
import 'package:flutter_firebase_connection/widgets/round_button.dart';

class SplashScreenThree extends StatefulWidget {
  final PageController controller;
  const SplashScreenThree(this.controller, {super.key});
  @override
  State<SplashScreenThree> createState() => _SplashScreenThreeState();
}

class _SplashScreenThreeState extends State<SplashScreenThree> {
  SplashServices splashScreen = SplashServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final isUserLoggedIn = _auth.currentUser;

  void _handleSubmit() {
    if (isUserLoggedIn != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LandingPage()));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          height: Utils.height(0.4, context),
                          width: 360,
                          child: Image.asset(
                            "${Utils.baseImagePath}splash-img-two.png",
                            height: Utils.height(0.9, context),
                            fit: BoxFit.cover,
                          )),
                      const Text(
                        "Proactive Mind",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Your stress-free companion for staying focused on goals, projects, and tasks. Tailored for seamless productivity, Proactive Mind helps you conquer distractions and achieve your objectives effortlessly",
                        style: TextStyle(fontSize: 17, color: Colors.black54),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      RoundButton(
                          title: "Get Started", onPressed: _handleSubmit),
                    ]))));
  }
}
