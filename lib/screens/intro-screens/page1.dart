import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to LogiTrust',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          SizedBox(height: 20),
          Image.asset(
            'assets/images/onboarding1.png',
            fit: BoxFit.contain, // Adjust the fit as needed
            height: 300, // Set height as needed
          ),
        ],
      ),
    );
  }
}
