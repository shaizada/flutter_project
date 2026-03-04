import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcelona Shop"),
        backgroundColor: Color(0xFF004D98),
      ),
      body: Center(
        child: Text(
          "Barcelona Merchandise",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}