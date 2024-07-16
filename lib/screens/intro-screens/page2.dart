import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Lets have your goods delivered anywhere in Kampala',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          SizedBox(height: 20),
          Image.asset(
            'assets/images/onboarding2.png',
            fit: BoxFit.contain, // Adjust the fit as needed
            height: 300, // Set height as needed
          ),
        ],
      ),
    );
  }
}
