import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trust/screens/dashboard.dart';
import 'package:trust/screens/onboarding_screen.dart';
import 'package:trust/screens/authentication/user_login.dart';
import 'package:trust/screens/sign_up.dart';
import 'package:trust/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _themeColor = Colors.yellow;
  String _fontStyle = 'Sans';
  double _fontSize = 16.0;

  // Add profile data
  String _name = '';
  String _email = '';
  String _location = '';
  String _address = '';
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
          debugShowCheckedModeBanner: false,
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
                  name: _name,
                  email: _email,
                  location: _location,
                  address: _address,
                  profileImage: _profileImage,
                  updateTheme: _updateTheme,
                  updateLanguage: _updateLanguage,
                  updateFontStyle: _updateFontStyle,
                  updateFontSize: _updateFontSize,
                  themeColor: _themeColor,
                  updateProfile: _updateProfile, // Add this line
                ),
            '/settings': (context) => SettingsScreen(
                  themeColor: _themeColor,
                  updateTheme: _updateTheme,
                  updateLanguage: _updateLanguage,
                  updateFontStyle: _updateFontStyle,
                  updateFontSize: _updateFontSize,
                ),
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
