import 'package:flutter/material.dart';
import 'package:tugas16_flutter/auth/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),

      // initialRoute: '/',
      // routes: {
      //   '/splash_screen': (context) => const SplashScreen(),
      //   '/Home': (context) => const Home(),
      //   // '/ButtonNavbar': (context) => const ButtonNavbar(),
      // },
      home: SplashScreen(),
    );
  }
}
