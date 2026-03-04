import 'package:flutter/material.dart';
import 'login_page.dart'; // Сізде бұрынғы login_page.dart файлы

// Тест беттер (MyOrdersPage, WishlistPage) үшін қарапайым Scaffold
class MyOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Orders"), backgroundColor: Color(0xFF004D98)),
      body: Center(child: Text("Your Orders will appear here")),
    );
  }
}

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wishlist"), backgroundColor: Color(0xFF004D98)),
      body: Center(child: Text("Your Wishlist items will appear here")),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController(text: "John Doe");
  TextEditingController emailController = TextEditingController(text: "john@example.com");

  String selectedLanguage = "English";
  List<String> languages = ["English", "Spanish", "Kazakh", "French"];

  Map<String, Map<String, String>> texts = {
    "English": {
      "fullName": "Full Name",
      "email": "Email",
      "language": "Language",
      "myOrders": "My Orders",
      "wishlist": "Wishlist",
      "logout": "Logout",
    },
    "Spanish": {
      "fullName": "Nombre Completo",
      "email": "Correo Electrónico",
      "language": "Idioma",
      "myOrders": "Mis Pedidos",
      "wishlist": "Lista de Deseos",
      "logout": "Cerrar Sesión",
    },
    "Kazakh": {
      "fullName": "Толық Аты",
      "email": "Электрондық пошта",
      "language": "Тіл",
      "myOrders": "Менің тапсырыстарым",
      "wishlist": "Таңдаулылар",
      "logout": "Шығу",
    },
    "French": {
      "fullName": "Nom Complet",
      "email": "Email",
      "language": "Langue",
      "myOrders": "Mes Commandes",
      "wishlist": "Liste de Souhaits",
      "logout": "Déconnexion",
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), backgroundColor: Color(0xFF004D98)),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004D98), Color(0xFFA50044)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFF004D98)),
              ),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3))
                  ],
                ),
                child: Column(
                  children: [
                    // Full Name редактируемый
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: texts[selectedLanguage]!["fullName"],
                        prefixIcon: Icon(Icons.person),
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 15),
                    // Email редактируемый
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: texts[selectedLanguage]!["email"],
                        prefixIcon: Icon(Icons.email),
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 15),
                    // Language Dropdown
                    Row(
                      children: [
                        Icon(Icons.language, color: Color(0xFF004D98)),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedLanguage,
                            items: languages
                                .map((lang) => DropdownMenuItem(
                                      value: lang,
                                      child: Text(lang),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedLanguage = value!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: texts[selectedLanguage]!["language"],
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // My Orders
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: Icon(Icons.shopping_bag, color: Color(0xFF004D98)),
                  title: Text(texts[selectedLanguage]!["myOrders"]!),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => MyOrdersPage()));
                  },
                ),
              ),
              // Wishlist
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: Icon(Icons.favorite, color: Color(0xFF004D98)),
                  title: Text(texts[selectedLanguage]!["wishlist"]!),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => WishlistPage()));
                  },
                ),
              ),
              SizedBox(height: 20),
              // Logout
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA50044),
                  minimumSize: Size(150, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                      (route) => false);
                },
                child: Text(texts[selectedLanguage]!["logout"]!,
                    style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}