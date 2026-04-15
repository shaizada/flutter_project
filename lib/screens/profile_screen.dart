import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'address_screen.dart';
import 'payment_screen.dart';
import 'orders_screen.dart'; // ЖАҢА: Тапсырыстар бетін импорттау

class ProfileScreen extends StatefulWidget {
  final String lang;
  final Function(String) onLangChange;
  final String userName;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.lang,
    required this.onLangChange,
    required this.userName,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String currentName;
  String currentEmail = "viscaelbarca@example.com";
  String currentAddress = "Алматы, Абай даңғылы, 10";

  Map<String, String> userCard = {
    'number': '4444 5555 6666 7777',
    'holder': 'VISCA EL BARCA',
    'expiry': '12/28',
  };

  @override
  void initState() {
    super.initState();
    currentName = widget.userName;
  }

  // --- НАВИГАЦИЯ ---
  
  // ТҮЗЕТІЛДІ: Енді Placeholder емес, нағыз OrdersScreen-ге барады
  void _goToOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrdersScreen(lang: widget.lang),
      ),
    );
  }

  Future<void> _goToAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressScreen(lang: widget.lang, initialAddress: currentAddress),
      ),
    );
    if (result != null && result is String) setState(() => currentAddress = result);
  }

  Future<void> _goToPayment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(lang: widget.lang, cardData: userCard),
      ),
    );
    if (result != null && result is Map<String, String>) setState(() => userCard = result);
  }

  void _goToNotifications() => _showPlaceholder(widget.lang == 'KZ' ? "Хабарламалар" : "Уведомления");

  Future<void> _goToSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          lang: widget.lang,
          initialName: currentName,
          initialEmail: currentEmail,
        ),
      ),
    );
    if (result != null && result is Map<String, String>) {
      setState(() {
        currentName = result['name']!;
        currentEmail = result['email']!;
      });
    }
  }

  void _showPlaceholder(String title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title беті жақында дайын болады!")));
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
            // Аватар бөлімі
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
                  Text(currentName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(currentEmail, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Ақ меню бөлімі
            Container(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
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
                  _buildMenuItem(Icons.shopping_bag_outlined, words['orders']!, _goToOrders),
                  _buildMenuItem(Icons.location_on_outlined, words['address']!, _goToAddress),
                  _buildMenuItem(Icons.payment_outlined, words['payment']!, _goToPayment),
                  _buildMenuItem(Icons.notifications_none, words['notifications']!, _goToNotifications),
                  _buildMenuItem(Icons.settings_outlined, words['settings']!, _goToSettings),
                  const Divider(height: 30),
                  
                  _buildMenuItem(
                    Icons.logout, 
                    words['exit']!, 
                    widget.onLogout, 
                    isExit: true
                  ),
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
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isExit = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: isExit ? Colors.red : const Color(0xFFA50044)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: isExit ? Colors.red : Colors.black)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}