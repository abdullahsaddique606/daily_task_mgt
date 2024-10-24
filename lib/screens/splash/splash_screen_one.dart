import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/constants/utils.dart';
import 'package:flutter_firebase_connection/widgets/round_button.dart';

class SplashScreenOne extends StatelessWidget {
  final PageController controller;
  const SplashScreenOne(this.controller, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        height: Utils.height(1, context),
        width: Utils.width(1, context),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset(
            '${Utils.baseImagePath}splash_3.png',
            height: Utils.height(0.6, context),
            width: Utils.width(1, context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 27.0),
                child: Text(
                  "Proactive Mind",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 27.0),
                child: Text(
                  'Organize your tasks efficiently!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 27.0, right: 27.0),
                child: RoundButton(
                  title: "Next",
                  onPressed: () => controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
