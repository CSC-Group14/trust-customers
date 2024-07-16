import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:trust/screens/dashboard.dart';
import 'package:trust/screens/onboarding_screen.dart';
import 'package:trust/screens/authentication/user_login.dart';
import 'package:trust/screens/sign_up.dart';
import 'package:trust/screens/map_screen.dart'; // Import the MapScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _themeColor = Colors.blueAccent;
  String _fontStyle = 'Sans';
  double _fontSize = 16.0;

  // Add profile data
  String _name = 'Kashara Alvin';
  String _email = 'kashcode@gmail.com';
  String _location = 'City Center';
  String _address = 'Kampala Uganda';
  String _profileImage = '';

  void _updateTheme(Color color) {
    setState(() {
      _themeColor = color;
    });
  }

  void _updateLanguage(String language) {
    setState(() {});
  }

  void _updateFontStyle(String fontStyle) {
    setState(() {
      _fontStyle = fontStyle;
    });
  }

  void _updateFontSize(double fontSize) {
    setState(() {
      _fontSize = fontSize;
    });
  }

  // Add profile update functions
  void _updateProfile(String name, String email, String location,
      String address, String profileImage) {
    setState(() {
      _name = name;
      _email = email;
      _location = location;
      _address = address;
      _profileImage = profileImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: _createMaterialColor(_themeColor)),
            textTheme: TextTheme(
              bodyMedium: TextStyle(
                fontFamily: _fontStyle,
                fontSize: _fontSize,
              ),
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const OnboardingScreen(),
            '/login': (context) => const LoginPage(),
            '/signup': (context) => SignUpPage(),
            '/dashboard': (context) => CustomerDashboard(
                  themeColor: _themeColor,
                  updateTheme: _updateTheme,
                  updateLanguage: _updateLanguage,
                  updateFontStyle: _updateFontStyle,
                  updateFontSize: _updateFontSize,
                  name: _name,
                  email: _email,
                  location: _location,
                  address: _address,
                  profileImage: _profileImage,
                  updateProfile: _updateProfile,
                ),
            '/map': (context) => HomeTabPage(), // Added route to MapScreen
          },
        );
      },
    );
  }

  MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
