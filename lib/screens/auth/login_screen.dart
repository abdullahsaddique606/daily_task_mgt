import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/constants/colors.dart';
import 'package:flutter_firebase_connection/screens/auth/register_user_screen.dart';
import 'package:flutter_firebase_connection/screens/landing/landing_page.dart';
import 'package:flutter_firebase_connection/widgets/input_feild.dart';
import 'package:flutter_firebase_connection/widgets/round_button.dart';

import '../../constants/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool _obscureText = true;

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _auth
          .signInWithEmailAndPassword(
              email: _email.text.toString(),
              password: _password.text.toString())
          .then((value) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LandingPage()));
        Utils.showToastMessage("Successfully loggedin");
        setState(() {
          isLoading = false;
        });
      }).onError((error, stackTrace) {
        String errorMessage = error.toString();
        int index = errorMessage.indexOf("] ");
        if (index > 0) {
          errorMessage = errorMessage.substring(index + 2);
        }
        setState(() {
          isLoading = false;
        });
        Utils.showToastMessage(errorMessage.toString());
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Login",
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
                    width: Utils.width(0.4, context),
                  ),
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputFeild(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          validator: (value) =>
                              Utils.isValidEmail(_email.toString()),
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
                            validator: (value) => Utils.isValidPassword(value)),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.blue),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistrationScreen())),
                              child: const Text(
                                "Dont have a account? Sign up",
                                style: TextStyle(color: Colors.indigo),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RoundButton(
                          title: "Login",
                          onPressed: _handleSubmit,
                          isLoading: isLoading,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

// void _signUp() async {
//   String email = _email.text;
//   String password = _password.text;
//   String phoneNumber = _phoneNumber.text;
//   User? user = await _auth.signupWithEmailAndPassword(email, password);
//   if (user != null) {
//     print("user created navigate to home");
//   } else {
//     print("Error occured");
//   }
// }
}
