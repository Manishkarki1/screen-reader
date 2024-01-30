import 'package:flutter/material.dart';
import 'package:screenreader/screen_reader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScreenReader',
      debugShowCheckedModeBanner: false,
      home: ScreenReader(),
      theme: ThemeData.light(),
    );
  }
}
