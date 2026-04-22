import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart'; // 🔥 ҚОСЫЛДЫ
import 'firebase_options.dart'; // 🔥 ҚОСЫЛДЫ (бұл файл сенде бар)
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/seller/seller_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase-ті нақты параметрлермен (options) іске қосамыз:
 await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "AIzaSyATtpMpDcHO5k-fAVDjE-ZsN-OU3M7t2LA",
    appId: "1:845203405278:android:4a0908ca13b9b8e53c054f", // Скриншоттағы App ID
    messagingSenderId: "845203405278",
    projectId: "barca-store-final-2026",
    storageBucket: "barca-store-final-2026.firebasestorage.app",
  ),
);
  
  final prefs = await SharedPreferences.getInstance();
  
  bool isRegistered = prefs.getBool('is_logged_in') ?? false;
  String savedName = prefs.getString('user_name') ?? 'Culer №1';
  String savedRole = prefs.getString('user_role') ?? 'Buyer';

  runApp(BarcaStoreApp(
    isInitialRegistered: isRegistered,
    initialName: savedName,
    initialRole: savedRole,
  ));
}

// Себет пен таңдаулылар тізімі (Олар өзгеріссіз қалады)
List<Map<String, dynamic>> cartItems = [];
List<Map<String, dynamic>> favoriteItems = [];
List<Map<String, dynamic>> myOrders = [];

class BarcaStoreApp extends StatefulWidget {
  final bool isInitialRegistered;
  final String initialName;
  final String initialRole;

  const BarcaStoreApp({
    super.key, 
    required this.isInitialRegistered,
    required this.initialName,
    required this.initialRole,
  });

  @override
  State<BarcaStoreApp> createState() => _BarcaStoreAppState();
}

class _BarcaStoreAppState extends State<BarcaStoreApp> {
  String currentLang = 'KZ';
  late bool isUserRegistered;
  late String currentUserName;
  late String currentUserRole;

  @override
  void initState() {
    super.initState();
    isUserRegistered = widget.isInitialRegistered;
    currentUserName = widget.initialName;
    currentUserRole = widget.initialRole;
  }

  void updateLanguage(String newLang) {
    setState(() {
      currentLang = newLang;
    });
  }

  void registerUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isUserRegistered = true;
      currentUserName = prefs.getString('user_name') ?? 'User';
      currentUserRole = prefs.getString('user_role') ?? 'Buyer';
    });
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      isUserRegistered = false;
      currentUserRole = 'Buyer';
      currentUserName = 'Culer №1';
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
      home: Scaffold(
        // Мұндағы ақ экранды болдырмау үшін backgroundColor-ды мөлдір қыламыз
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF004D98), Color(0xFFA50044)],
              stops: [0.0, 0.7],
            ),
          ),
          child: isUserRegistered
              ? (currentUserRole == "Seller" 
                  ? SellerNavigationScreen(
                      currentLang: currentLang,
                      onLangChange: updateLanguage,
                      userName: currentUserName,
                      onLogout: logout,
                    ) 
                  : MainNavigationScreen(
                      currentLang: currentLang,
                      onLangChange: updateLanguage,
                      userName: currentUserName,
                      onLogout: logout,
                    ))
              : SplashOrRegistration(onRegisterSuccess: registerUser),
        ),
      ),
    );
  }
}

// Төмендегі MainNavigationScreen кодын да өзің жібергендей қалдырдым, ол дұрыс жазылған.
class MainNavigationScreen extends StatefulWidget {
  final String currentLang;
  final Function(String) onLangChange;
  final String userName;
  final VoidCallback onLogout;

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
    final List<Widget> screens = [
      HomeScreen(lang: widget.currentLang),
      FavoritesScreen(lang: widget.currentLang),
      CartScreen(lang: widget.currentLang),
      ProfileScreen(
        lang: widget.currentLang, 
        onLangChange: widget.onLangChange,
        userName: widget.userName,
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
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