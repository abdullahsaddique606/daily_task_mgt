import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/constants/colors.dart';
import 'package:flutter_firebase_connection/screens/auth/login_screen.dart';
import 'package:flutter_firebase_connection/screens/landing/landing_page.dart';
import 'package:flutter_firebase_connection/widgets/round_button.dart';

import '../../constants/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _nameOfUser = TextEditingController();
  final _phoneNumber = TextEditingController();
  bool isloading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
            email: _email.text.toString(), password: _password.text.toString());
        User? user = userCredential.user;
        final data = {
          'userID':user!.uid,
          'displayName':_nameOfUser.text,
          'email':_email.text,
          'phoneNumber':_phoneNumber.text,
          'createdAt' : DateTime.now()
        };
        if (user != null) {
          await _fireStore.collection('users').doc(user.uid).set(data);
          setState(() {
            isloading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LandingPage()),
          );

          Utils.showToastMessage("User created successfully");
        }
      } catch (error){
        String errorMessage = error.toString();
        int index = errorMessage.indexOf("] ");
        if (index > 0) {
          errorMessage = errorMessage.substring(index + 2);
        }

        setState(() {
          isloading = false;
        });

        Utils.showToastMessage(errorMessage);
      }
      };
    }



  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    '${Utils.baseImagePath}actor.png',
                    height: Utils.height(0.2, context),
                    width: 150,
                  ),
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _nameOfUser,
                          decoration: const InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.verified_user),
                          ),
                          validator: (value) {
                            return value!.isEmpty ? "Enter Name" : null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) => Utils.isValidEmail(_email.toString()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: _obscureText,
                          controller: _password,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: GestureDetector(
                              child: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          validator: (value) => Utils.isValidPassword(value),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _phoneNumber,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: "Phone Number",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone_android)),
                          validator: (value) => Utils.isValidPhoneNumber(value),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen())),
                          child: Center(
                            child: const Text(
                              "Already has account? Login",
                              style: TextStyle(color: Colors.indigo),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RoundButton(
                          title: "Sign up",
                          onPressed: _handleSubmit,
                          isLoading: isloading,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
