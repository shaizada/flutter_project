import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/auth_screen.dart'; // Не забудь про импорт!

void main() {
  runApp(const BarcaStoreApp());
}

// ГЛОБАЛЬНЫЕ ДАННЫЕ (не трогаем списки)
List<Map<String, dynamic>> cartItems = [];
List<Map<String, dynamic>> favoriteItems = [];

// НОВАЯ ПЕРЕМЕННАЯ ДЛЯ ИМЕНИ ПОЛЬЗОВАТЕЛЯ
String currentUserName = 'Culer №1'; // Стандартное имя
bool isUserRegistered = false; // Флаг регистрации

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

  // Функция для сохранения имени при регистрации
  void registerUser(String name) {
    setState(() {
      currentUserName = name;
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
      // ОБОРАЧИВАЕМ ВСЁ В ГРАДИЕНТ
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF004D98), // Синий
              Color(0xFFA50044), // Гранатовый
            ],
            stops: [0.0, 0.7],
          ),
        ),
        // ЛОГИКА ЗАПУСКА
        child: isUserRegistered
            ? MainNavigationScreen(
                currentLang: currentLang,
                onLangChange: updateLanguage,
              )
            : SplashOrRegistration(onRegisterSuccess: registerUser),
      ),
    );
  }
}

// (MainNavigationScreen и остальные классы остаются без изменений в main.dart)
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
    // Список экранов (в ProfileScreen передаем имя пользователя)
    final List<Widget> screens = [
      HomeScreen(lang: widget.currentLang),
      FavoritesScreen(lang: widget.currentLang),
      CartScreen(lang: widget.currentLang),
      ProfileScreen(
        lang: widget.currentLang, 
        onLangChange: widget.onLangChange,
        userName: currentUserName, // ПЕРЕДАЕМ ИМЯ!
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