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
    // Тілдер бойынша мәтіндер жинағы
    Map<String, dynamic> translations = {
      'KZ': {
        'profile': 'ПРОФИЛЬ',
        'edit': 'Деректерді өңдеу',
        'lang_text': 'Тілді өзгерту',
        'help': 'Көмек орталығы',
        'security': 'Қауіпсіздік',
        'logout': 'ЖҮЙЕДЕН ШЫҒУ',
        'role': 'Ресми сатушы',
        'choose_lang': 'Тілді таңдаңыз'
      },
      'RU': {
        'profile': 'ПРОФИЛЬ',
        'edit': 'Редактировать данные',
        'lang_text': 'Изменить язык',
        'help': 'Центр помощи',
        'security': 'Безопасность',
        'logout': 'ВЫЙТИ ИЗ СИСТЕМЫ',
        'role': 'Официальный продавец',
        'choose_lang': 'Выберите язык'
      },
      'EN': {
        'profile': 'PROFILE',
        'edit': 'Edit Data',
        'lang_text': 'Change Language',
        'help': 'Help Center',
        'security': 'Security',
        'logout': 'LOGOUT',
        'role': 'Official Seller',
        'choose_lang': 'Choose Language'
      },
    };

    var t = translations[lang] ?? translations['EN'];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(t['profile'], style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Аватар және Есім
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.store, size: 50, color: Color(0xFF004D98)),
            ),
            const SizedBox(height: 15),
            Text(userName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            Text(t['role'], style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 30),

            // МӘЗІР БАТЫРМАЛАРЫ
            _buildMenuTile(Icons.edit, t['edit'], () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${t['edit']}...")));
            }),

            _buildMenuTile(Icons.language, "${t['lang_text']} ($lang)", () {
              _showLanguageDialog(context, t['choose_lang']);
            }),

            _buildMenuTile(Icons.help_outline, t['help'], () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${t['help']}...")));
            }),

            _buildMenuTile(Icons.security, t['security'], () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${t['security']}...")));
            }),
            
            const SizedBox(height: 40),

            // ШЫҒУ БАТЫРМАСЫ
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout),
                label: Text(t['logout']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromARGB(255, 129, 9, 0),
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
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap, // ЕНДІ БАСЫЛАДЫ
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _langOption(context, 'KZ', 'Қазақ тілі'),
            _langOption(context, 'RU', 'Русский язык'),
            _langOption(context, 'EN', 'English'),
          ],
        ),
      ),
    );
  }

  Widget _langOption(BuildContext context, String code, String label) {
    return ListTile(
      title: Text(label),
      onTap: () {
        onLangChange(code);
        Navigator.pop(context);
      },
    );
  }
}