import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/seller/seller_main.dart'; // ЖАҢА: Сатушы бетінің импорты

void main() {
  runApp(const BarcaStoreApp());
}

// ГЛОБАЛЬНЫЕ ДАННЫЕ
List<Map<String, dynamic>> cartItems = [];
List<Map<String, dynamic>> favoriteItems = [];

// ПАЙДАЛАНУШЫ МӘЛІМЕТТЕРІ
String currentUserName = 'Culer №1';
String currentUserRole = 'Buyer'; 
bool isUserRegistered = false;

class BarcaStoreApp extends StatefulWidget {
  const BarcaStoreApp({super.key});

  @override
  State<BarcaStoreApp> createState() => _BarcaStoreAppState();
}

class _BarcaStoreAppState extends State<BarcaStoreApp> {
  String currentLang = 'KZ';

  void updateLanguage(String newLang) {
    setState(() {
      currentLang = newLang;
    });
  }

  void registerUser(String name, String role) {
    setState(() {
      currentUserName = name;
      currentUserRole = role; 
      isUserRegistered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barca Store',
      theme: ThemeData(
        primaryColor: const Color(0xFF004D98),
      ),
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF004D98), Color(0xFFA50044)],
            stops: [0.0, 0.7],
          ),
        ),
        // ЛОГИКА: Тіркелуге байланысты рөл бойынша бөлу
        // main.dart ішіндегі логика бөлімі:
child: isUserRegistered
    ? (currentUserRole == "Seller" 
        ? SellerNavigationScreen(
            currentLang: currentLang,
            onLangChange: updateLanguage,
            userName: currentUserName,
            onLogout: () => setState(() => isUserRegistered = false), // Шығу функциясы
          ) 
        : MainNavigationScreen(
            currentLang: currentLang,
            onLangChange: updateLanguage,
          ))
    : SplashOrRegistration(onRegisterSuccess: registerUser),
      ),
    );
  }
}

// -------------------------------------------------------------------
// САТЫП АЛУШЫНЫҢ БЕТІ (MainNavigationScreen өзгеріссіз)
// -------------------------------------------------------------------
class MainNavigationScreen extends StatefulWidget {
  final String currentLang;
  final Function(String) onLangChange;

  const MainNavigationScreen({
    super.key, 
    required this.currentLang, 
    required this.onLangChange
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(lang: widget.currentLang),
      FavoritesScreen(lang: widget.currentLang),
      CartScreen(lang: widget.currentLang),
      ProfileScreen(
        lang: widget.currentLang, 
        onLangChange: widget.onLangChange,
        userName: currentUserName,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFFA50044),
            unselectedItemColor: Colors.grey,
            items: _buildNavItems(),
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavItems() {
    Map<String, List<String>> navLabels = {
      'KZ': ['Дүкен', 'Таңдаулы', 'Себет', 'Профиль'],
      'RU': ['Магазин', 'Избранное', 'Корзина', 'Профиль'],
      'EN': ['Store', 'Favorites', 'Cart', 'Profile'],
    };
    List<String> labels = navLabels[widget.currentLang]!;

    return [
      BottomNavigationBarItem(icon: const Icon(Icons.store), label: labels[0]),
      BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: labels[1]),
      BottomNavigationBarItem(icon: const Icon(Icons.shopping_cart), label: labels[2]),
      BottomNavigationBarItem(icon: const Icon(Icons.person), label: labels[3]),
    ];
  }
}