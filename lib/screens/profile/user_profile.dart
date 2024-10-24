import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/constants/colors.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Completed",
            style: TextStyle(color: Colors.black,fontSize: 16),
          ),
        ));
  }
}
