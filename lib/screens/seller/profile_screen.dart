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
      appBar: AppBar(
        title: const Text("ПРОФИЛЬ", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.store, size: 50, color: Color(0xFF004D98)),
            ),
            const SizedBox(height: 15),
            Text(userName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Official Barça Store Seller", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 30),

            // Баптаулар мәзірі
            _buildMenuTile(Icons.edit, "Деректерді өңдеу", () {}),
            _buildMenuTile(Icons.language, "Тілді өзгерту (${lang})", () {
              // Тіл таңдау диалогы
              _showLanguageDialog(context);
            }),
            _buildMenuTile(Icons.help_outline, "Көмек орталығы", () {}),
            _buildMenuTile(Icons.security, "Қауіпсіздік", () {}),
            
            const SizedBox(height: 40),

            // Шығу батырмасы
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout),
                label: const Text("ЖҮЙЕДЕН ШЫҒУ"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Тіл таңдаңыз"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['KZ', 'RU', 'EN'].map((l) => ListTile(
            title: Text(l),
            onTap: () {
              onLangChange(l);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }
}