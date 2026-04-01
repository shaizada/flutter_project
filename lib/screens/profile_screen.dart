import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String lang;
  final Function(String) onLangChange;
  final String userName;

  const ProfileScreen({
    super.key,
    required this.lang,
    required this.onLangChange,
    required this.userName,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Осы жерде локальный айнымалылар сақталады
  late String currentName;
  String currentEmail = "viscaelbarca@example.com";

  @override
  void initState() {
    super.initState();
    currentName = widget.userName; // Бастапқы есімді регистрациядан аламыз
  }

  // Өңдеу бетіне барып, деректерді алып келу функциясы
  Future<void> _goToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => EditProfileScreen(
  lang: widget.lang,
  initialName: currentName,    // Осыны қосу керек
  initialEmail: currentEmail,  // Және осыны
),
      ),
    );

    // Егер деректер қайтарылса, экранды жаңартамыз
    if (result != null && result is Map<String, String>) {
      setState(() {
        currentName = result['name']!;
        currentEmail = result['email']!;
      });
    }
  }

  void _showDummyPage(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$title беті дайындалуда...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, String>> t = {
      'KZ': {
        'title': 'ПРОФИЛЬ',
        'orders': 'Менің тапсырыстарым',
        'address': 'Жеткізу мекен-жайы',
        'payment': 'Төлем әдістері',
        'notifications': 'Хабарламалар',
        'settings': 'Баптаулар',
        'exit': 'Шығу',
        'select_lang': 'Тілді таңдау',
      },
      'RU': {
        'title': 'ПРОФИЛЬ',
        'orders': 'Мои заказы',
        'address': 'Адрес доставки',
        'payment': 'Методы оплаты',
        'notifications': 'Уведомления',
        'settings': 'Настройки',
        'exit': 'Выход',
        'select_lang': 'Выбор языка',
      },
      'EN': {
        'title': 'PROFILE',
        'orders': 'My Orders',
        'address': 'Delivery Address',
        'payment': 'Payment Methods',
        'notifications': 'Notifications',
        'settings': 'Settings',
        'exit': 'Logout',
        'select_lang': 'Select Language',
      },
    };

    final words = t[widget.lang]!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(words['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    currentName, // Өзгертілген есім осы жерде көрінеді
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    currentEmail, // Өзгертілген email
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(words['select_lang']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _langButton('KZ'),
                      _langButton('RU'),
                      _langButton('EN'),
                    ],
                  ),
                  const Divider(height: 40),

                  // Енді барлық батырмаларға функция қосылды
                  _buildMenuItem(Icons.shopping_bag_outlined, words['orders']!, () => _showDummyPage(words['orders']!)),
                  _buildMenuItem(Icons.location_on_outlined, words['address']!, () => _showDummyPage(words['address']!)),
                  _buildMenuItem(Icons.payment_outlined, words['payment']!, () => _showDummyPage(words['payment']!)),
                  _buildMenuItem(Icons.notifications_none, words['notifications']!, () => _showDummyPage(words['notifications']!)),
                  _buildMenuItem(Icons.settings_outlined, words['settings']!, _goToEditProfile),

                  const Divider(height: 30),
                  _buildMenuItem(Icons.logout, words['exit']!, () => Navigator.pop(context), isExit: true),
                  
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _langButton(String label) {
    bool isSelected = widget.lang == label;
    return GestureDetector(
      onTap: () => widget.onLangChange(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF004D98) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isExit = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: isExit ? Colors.red : const Color(0xFFA50044)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isExit ? Colors.red : Colors.black,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}