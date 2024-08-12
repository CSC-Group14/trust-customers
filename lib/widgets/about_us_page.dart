import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/logo.png'), // Add a logo image
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Welcome to Our Logistics App!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'About Us',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const Divider(color: Colors.teal),
            const SizedBox(height: 8),
            const Text(
              'We aim to provide the best logistics services with a focus on '
              'reliability, efficiency, and customer satisfaction. Our innovative '
              'solutions ensure that your logistics needs are met with the utmost '
              'care and professionalism.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our Team',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const Divider(color: Colors.teal),
            const SizedBox(height: 8),
            const Text(
              'Our team is composed of dedicated professionals who are passionate about '
              'delivering exceptional logistics solutions. With years of experience '
              'in the industry, we are committed to providing outstanding service and '
              'ensuring customer satisfaction.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 32),
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const Divider(color: Colors.teal),
            const SizedBox(height: 8),
            const Text(
              'Phone: +256 706 576 928\n'
              'Email: logitrust42@gmail.com',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
                        const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.local_shipping, color: Colors.teal, size: 40),
                SizedBox(width: 16),
                Icon(Icons.support_agent, color: Colors.teal, size: 40),
                SizedBox(width: 16),
                Icon(Icons.thumb_up, color: Colors.teal, size: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
