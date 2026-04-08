import 'package:flutter/material.dart';
import 'products_screen.dart';
import 'profile_screen.dart';
import 'statistics_screen.dart'; // ЖАҢА ИМПОРТ

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
    // Беттер тізімін жаңа файлдармен жаңарттық
    final List<Widget> _pages = [
      const SellerProductsScreen(),
      const SellerStatisticsScreen(), // Енді бұл жерде нақты статистика беті
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
        // IndexedStack қолдану арқылы беттер ауысқанда тауарлар тізімі жоғалмайды
        body: IndexedStack(index: _selectedIndex, children: _pages),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFFA50044),
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed, // Батырмалар бір қалыпты тұруы үшін
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_outlined),
                  activeIcon: Icon(Icons.inventory_2),
                  label: 'Тауарлар',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  activeIcon: Icon(Icons.bar_chart),
                  label: 'Статистика',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Профиль',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}