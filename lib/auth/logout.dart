import 'package:flutter/material.dart';
import 'package:tugas16_flutter/auth/login.dart';
import 'package:tugas16_flutter/utils/shared_preference.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  static void handleLogout(BuildContext context) {
    PreferenceHandler.removeLogin();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => handleLogout(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A2A80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 4,
      ),
      child: const Text(
        "Keluar",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
