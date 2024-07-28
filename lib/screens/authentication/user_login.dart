import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // ignore: unused_local_variable
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Navigate to dashboard on successful login
        Navigator.pushReplacementNamed(context, '/dashboard');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful')),
        );
      } catch (e) {
        // Show error message if login fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to login. Please check your credentials.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/Klano.jpg', height: 150),
              SizedBox(height: 20),
              Text(
                "In LogiTrust we trust",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[800]),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.yellow[800])),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.yellow[800])),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[800]),
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text("No account? Register here",
                    style: TextStyle(color: Colors.yellow[800])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
