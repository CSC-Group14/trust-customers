// ignore_for_file: body_might_complete_normally_catch_error, prefer_interpolation_to_compose_strings, use_build_context_synchronously, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void loginUser() {
    // Show "Please wait" toast
    Fluttertoast.showToast(msg: "Please wait, logging in...");

    // Delay for 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      // After delay, show "Login Successful" toast
      Fluttertoast.showToast(msg: "Login Successful.");

      // Navigate to the main screen
      Navigator.pushReplacementNamed(context, '/main_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset("images/icon.png"),
                  const Text(
                    "Login as a User",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email Field
                  TextFormField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "The field is empty";
                      } else if (!value.contains('@')) {
                        return "Invalid Email Address";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  // Password Field
                  TextFormField(
                    controller: passwordTextEditingController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "The field is empty";
                      } else if (value.length < 6) {
                        return "Password too short";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginUser();
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register_screen');
                    },
                    child: const Text(
                      "Don't have an account? Register Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
