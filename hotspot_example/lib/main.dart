import 'package:flutter/material.dart';
import 'package:hotspot_example/home_page.dart';
import 'package:hotspot_example/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Julie\'s Example App',
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}
