import 'package:flutter/material.dart';
import 'package:tugas16_flutter/auth/login.dart';
import 'package:tugas16_flutter/utils/shared_preference.dart';
import 'package:tugas16_flutter/views/button_navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const id = "/splash_screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    bool? isLogin = await PreferenceHandler.getLogin();

    Future.delayed(Duration(seconds: 3)).then((value) async {
      print(isLogin);
      if (isLogin == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ButtomNavbar()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF1A2A80),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.school, size: 60, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              "VEGAS APP",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2A80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
