import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/constants/colors.dart';

class Loading extends StatelessWidget {
  final bool isLoading;
  const Loading({Key? key, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator(
            color: AppColors.primaryColor,
          )
        : const SizedBox();
  }
}
