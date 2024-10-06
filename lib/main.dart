import 'package:club8_dev/screens/experienceScreen.dart';
import 'package:club8_dev/screens/onboardingScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black, // Set background to black
      ),
      home: RecordingScreen(),
    );
  }
}
