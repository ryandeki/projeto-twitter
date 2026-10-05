import 'package:flutter/material.dart';
import 'package:projeto_twitter_ryan_mateo/views/feed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Style App',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.black, surface: Colors.black),
        useMaterial3: true,
      ),
      home: const Feed(),
    );
  }
}
