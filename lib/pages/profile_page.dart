import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController(text: "John Doe");
  TextEditingController emailController = TextEditingController(text: "john@example.com");

  String selectedLanguage = "English";
  List<String> languages = ["English", "Spanish", "Kazakh", "French"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), backgroundColor: Color(0xFF004D98)),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF004D98), Color(0xFFA50044)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:20),
              CircleAvatar(radius:50, backgroundColor: Colors.white, child: Icon(Icons.person, size:50, color: Color(0xFF004D98))),
              SizedBox(height:15),
              Container(
                margin: EdgeInsets.symmetric(horizontal:20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius:5, offset: Offset(0,3))],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height:15),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height:15),
                    Row(
                      children: [
                        Icon(Icons.language, color: Color(0xFF004D98)),
                        SizedBox(width:10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedLanguage,
                            items: languages.map((lang) => DropdownMenuItem(
                              value: lang,
                              child: Text(lang),
                            )).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedLanguage = value!;
                                // TODO: тут можно добавить локализацию
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Language",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                  minimumSize: Size(150,50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: (){},
                child: Text("Logout", style: TextStyle(fontSize:16)),
              ),
              SizedBox(height:20),
            ],
          ),
        ),
      ),
    );
  }
}