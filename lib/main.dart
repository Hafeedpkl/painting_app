import 'package:flutter/material.dart';
import 'package:painting_app/core/app_theme.dart';
import 'package:painting_app/views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Drawing App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const MyHomePage(),
    );
  }
}
