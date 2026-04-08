import 'package:flutter/material.dart';
import 'products_screen.dart';
import 'profile_screen.dart';

class SellerNavigationScreen extends StatefulWidget {
  final String currentLang;
  final Function(String) onLangChange;
  final String userName;
  final VoidCallback onLogout;

  const SellerNavigationScreen({
    super.key,
    required this.currentLang,
    required this.onLangChange,
    required this.userName,
    required this.onLogout,
  });

  @override
  State<SellerNavigationScreen> createState() => _SellerNavigationScreenState();
}

class _SellerNavigationScreenState extends State<SellerNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Беттер тізімі
    final List<Widget> _pages = [
      const SellerProductsScreen(),
      const Center(child: Text("Статистика жақында қосылады", style: TextStyle(color: Colors.white))),
      SellerProfileScreen(
        lang: widget.currentLang,
        onLangChange: widget.onLangChange,
        userName: widget.userName,
        onLogout: widget.onLogout,
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF004D98), Color(0xFFA50044)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(index: _selectedIndex, children: _pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFA50044),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Тауарлар'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Статистика'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
          ],
        ),
      ),
    );
  }
}