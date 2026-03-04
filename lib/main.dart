import 'package:flutter/material.dart';
import 'pages/register_page.dart';

void main() {
  runApp(BarcelonaApp());
}

class BarcelonaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barcelona Fan App',
      theme: ThemeData(
        primaryColor: Color(0xFF004D98),
        fontFamily: 'Roboto',
      ),
      home: RegisterPage(),
    );
  }
}