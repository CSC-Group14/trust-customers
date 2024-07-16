import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Fast,Trusted and Kashcode',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          SizedBox(height: 20),
          Image.asset(
            'assets/images/onboarding3.png',
            fit: BoxFit.contain, // Adjust the fit as needed
            height: 300, // Set height as needed
          ),
        ],
      ),
    );
  }
}
