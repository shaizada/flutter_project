import 'package:flutter/material.dart';

class SellerProfileScreen extends StatelessWidget {
  final String lang;
  final Function(String) onLangChange;
  final String userName;
  final VoidCallback onLogout;

  const SellerProfileScreen({
    super.key,
    required this.lang,
    required this.onLangChange,
    required this.userName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text("ПРОФИЛЬ"), backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.store, size: 80, color: Colors.white),
            Text(userName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onLogout,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text("ЖҮЙЕДЕН ШЫҒУ", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}