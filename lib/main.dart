import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/seller/seller_main.dart';

void main() {
  runApp(const BarcaStoreApp());
}

// ГЛОБАЛЬНЫЕ ДАННЫЕ
List<Map<String, dynamic>> cartItems = [];
List<Map<String, dynamic>> favoriteItems = [];

// ПАЙДАЛАНУШЫ МӘЛІМЕТТЕРІ (Орталықтандырылған күй)
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

  // ШЫҒУ ФУНКЦИЯСЫ: Енді бұл ортақ
  void logout() {
    setState(() {
      isUserRegistered = false;
      // Мәліметтерді бастапқы күйге келтіру (опционально)
      currentUserRole = 'Buyer';
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
        // НЕГІЗГІ ЛОГИКА: Егер тіркелсе - рөліне қарай, тіркелмесе - AuthScreen
        child: isUserRegistered
            ? (currentUserRole == "Seller" 
                ? SellerNavigationScreen(
                    currentLang: currentLang,
                    onLangChange: updateLanguage,
                    userName: currentUserName,
                    onLogout: logout, // Сатушыға берілді
                  ) 
                : MainNavigationScreen(
                    currentLang: currentLang,
                    onLangChange: updateLanguage,
                    userName: currentUserName,
                    onLogout: logout, // ЕНДІ САТЫП АЛУШЫҒА ДА БЕРІЛДІ
                  ))
            : SplashOrRegistration(onRegisterSuccess: registerUser),
      ),
    );
  }
}

// -------------------------------------------------------------------
// САТЫП АЛУШЫНЫҢ БЕТІ (Навигация)
// -------------------------------------------------------------------
class MainNavigationScreen extends StatefulWidget {
  final String currentLang;
  final Function(String) onLangChange;
  final String userName;
  final VoidCallback onLogout; // ЖАҢА: Logout қосылды

  const MainNavigationScreen({
    super.key, 
    required this.currentLang, 
    required this.onLangChange,
    required this.userName,
    required this.onLogout,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Профиль бетіне барлық қажетті параметрлерді өткіземіз
    final List<Widget> screens = [
      HomeScreen(lang: widget.currentLang),
      FavoritesScreen(lang: widget.currentLang),
      CartScreen(lang: widget.currentLang),
      ProfileScreen(
        lang: widget.currentLang, 
        onLangChange: widget.onLangChange,
        userName: widget.userName,
        onLogout: widget.onLogout, // МІНЕ ОСЫ ЖЕРДЕ ҚАТЕ БОЛҒАН, ЕНДІ ТҮЗЕЛДІ
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