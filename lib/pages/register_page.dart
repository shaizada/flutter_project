import 'package:flutter/material.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Color(0xFF004D98),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004D98), Color(0xFFA50044)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0,5))],
              ),
              child: Column(
                children: [
                  Icon(Icons.sports_soccer, size: 70, color: Color(0xFF004D98)),
                  SizedBox(height: 20),
                  TextField(decoration: InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                  SizedBox(height: 15),
                  TextField(decoration: InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                  SizedBox(height: 15),
                  TextField(obscureText: true, decoration: InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                  SizedBox(height: 15),
                  TextField(obscureText: true, decoration: InputDecoration(labelText: "Confirm Password", prefixIcon: Icon(Icons.lock), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                  SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA50044),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage())); },
                    child: Text("Register", style: TextStyle(fontSize: 18)),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage())); },
                    child: Text("Already have account? Login", style: TextStyle(color: Colors.black87)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}