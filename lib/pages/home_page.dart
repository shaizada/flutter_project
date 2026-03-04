import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcelona Home"),
        backgroundColor: Color(0xFF004D98),
      ),
      body: Center(
        child: Text(
          "Latest Matches & News",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}