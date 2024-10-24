import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/constants/colors.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool isLoading;

  const RoundButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(40)),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
        ),
      ),
    );
  }
}
