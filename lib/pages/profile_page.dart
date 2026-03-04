import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), backgroundColor: Color(0xFF004D98)),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF004D98), Color(0xFFA50044)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius:50, backgroundColor: Colors.white, child: Icon(Icons.person, size:50, color: Color(0xFF004D98))),
              SizedBox(height:15),
              Text("John Doe", style: TextStyle(fontSize:22, fontWeight: FontWeight.bold, color: Colors.white)),
              Text("john@example.com", style: TextStyle(fontSize:16, color: Colors.white70)),
              SizedBox(height:20),
              Card(
                margin: EdgeInsets.symmetric(horizontal:20, vertical:5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: Icon(Icons.shopping_bag, color: Color(0xFF004D98)),
                  title: Text("My Orders"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){},
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal:20, vertical:5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: Icon(Icons.favorite, color: Color(0xFF004D98)),
                  title: Text("Wishlist"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){},
                ),
              ),
              SizedBox(height:20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA50044),
                  minimumSize: Size(150, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: (){},
                child: Text("Logout", style: TextStyle(fontSize:16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}