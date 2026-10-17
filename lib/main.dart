import 'package:flutter/material.dart';
import 'package:projeto_twitter_ryan_mateo/views/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter Style App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'ClashGrotesk-Variable',
            fontSize: 60,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontFamily: 'ClashGrotesk-Variable',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          surface: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}
