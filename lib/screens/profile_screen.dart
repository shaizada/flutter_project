import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String lang;
  final Function(String) onLangChange;
  final String userName; // Принимаем имя пользователя из регистрации

  const ProfileScreen({
    super.key,
    required this.lang,
    required this.onLangChange,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    // Словарь для перевода профиля
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

    final words = t[lang]!;

    return Scaffold(
      backgroundColor: Colors.transparent, // Для общего градиента
      appBar: AppBar(
        title: Text(words['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- ВЕРХНЯЯ КАРТОЧКА ПРОФИЛЯ ---
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
                    userName, // ТУТ ТЕПЕРЬ ОТОБРАЖАЕТСЯ ИМЯ ИЗ РЕГИСТРАЦИИ
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const Text(
                    'viscaelbarca@example.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // --- БЕЛАЯ ПАНЕЛЬ С НАСТРОЙКАМИ ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ВЫБОР ЯЗЫКА
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

                  // ПУНКТЫ МЕНЮ
                  _buildMenuItem(Icons.shopping_bag_outlined, words['orders']!),
                  _buildMenuItem(Icons.location_on_outlined, words['address']!),
                  _buildMenuItem(Icons.payment_outlined, words['payment']!),
                  _buildMenuItem(Icons.notifications_none, words['notifications']!),
                  _buildMenuItem(Icons.settings_outlined, words['settings']!),
                  const Divider(height: 30),
                  _buildMenuItem(Icons.logout, words['exit']!, isExit: true),
                  
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Кнопка выбора языка
  Widget _langButton(String label) {
    bool isSelected = lang == label;
    return GestureDetector(
      onTap: () => onLangChange(label),
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

  Widget _buildMenuItem(IconData icon, String title, {bool isExit = false}) {
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
        onTap: () {},
      ),
    );
  }
}