import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/constants/utils.dart';

class SplashScreenTwo extends StatelessWidget {
  final PageController controller;

  const SplashScreenTwo(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        height: Utils.height(1, context),
        width: Utils.width(1, context),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset(
            '${Utils.baseImagePath}splash_1.png',
            height: Utils.height(0.6, context),
            width: Utils.width(1, context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 27.0),
                child: Text(
                  'Easily Add Your Tasks',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 27.0),
                    child: GestureDetector(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.arrow_back),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Prev",
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ],
                        ),
                        onTap: () => controller.previousPage(
                            duration: const Duration(microseconds: 300),
                            curve: Curves.easeInOut)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 27.0),
                    child: GestureDetector(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Next",
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.arrow_forward)
                          ],
                        ),
                        onTap: () => controller.nextPage(
                            duration: const Duration(microseconds: 300),
                            curve: Curves.easeInOut)),
                  ),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
