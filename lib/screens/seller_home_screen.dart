import 'package:flutter/material.dart';

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
    final List<Widget> _pages = [
      const SellerProductsPage(),
      const Center(child: Text("Статистика жақында қосылады", style: TextStyle(color: Colors.white))),
      SellerProfilePage(
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

// --- САТУШЫ ПРОФИЛІ (ТІЛ ЖӘНЕ ШЫҒУМЕН) ---
class SellerProfilePage extends StatelessWidget {
  final String lang;
  final Function(String) onLangChange;
  final String userName;
  final VoidCallback onLogout;

  const SellerProfilePage({
    super.key,
    required this.lang,
    required this.onLangChange,
    required this.userName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    // ТІЛДЕРГЕ АҒЫЛШЫН ТІЛІН ҚОСТЫҚ
    Map<String, dynamic> translations = {
      'KZ': {'title': 'ПРОФИЛЬ', 'logout': 'ЖҮЙЕДЕН ШЫҒУ', 'lang': 'Тіл таңдау'},
      'RU': {'title': 'ПРОФИЛЬ', 'logout': 'ВЫЙТИ ИЗ СИСТЕМЫ', 'lang': 'Выбор языка'},
      'EN': {'title': 'PROFILE', 'logout': 'LOGOUT', 'lang': 'Language'},
    };

    // Егер белгісіз тіл келіп қалса, қате бермес үшін KZ немесе EN-ді таңдайды
    var currentTranslation = translations[lang] ?? translations['EN'];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(currentTranslation['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.storefront, size: 50, color: Color(0xFF004D98)),
            ),
            const SizedBox(height: 15),
            Text(userName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Seller Account", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 30),

            // ТІЛ АЛМАСУ
            _buildSettingsCard(
              title: currentTranslation['lang'],
              trailing: DropdownButton<String>(
                value: lang,
                dropdownColor: const Color(0xFF004D98),
                underline: const SizedBox(),
                items: ['KZ', 'RU', 'EN'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newLang) => onLangChange(newLang!),
              ),
            ),

            const SizedBox(height: 10),
            _buildSettingsCard(title: lang == 'KZ' ? "Профильді өңдеу" : (lang == 'RU' ? "Редактировать профиль" : "Edit Profile"), icon: Icons.edit),
            _buildSettingsCard(title: lang == 'KZ' ? "Хабарламалар" : (lang == 'RU' ? "Уведомления" : "Notifications"), icon: Icons.notifications),

            const SizedBox(height: 30),

            // ШЫҒУ БАТЫРМАСЫ
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: onLogout,
                child: Text(currentTranslation['logout'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required String title, IconData? icon, Widget? trailing}) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: icon != null ? Icon(icon, color: Colors.white) : null,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      ),
    );
  }
}

// --- ТАУАРЛАР БЕТІ (РЕДАКЦИЯЛАУ МҮМКІНДІГІМЕН) ---
class SellerProductsPage extends StatefulWidget {
  const SellerProductsPage({super.key});

  @override
  State<SellerProductsPage> createState() => _SellerProductsPageState();
}

class _SellerProductsPageState extends State<SellerProductsPage> {
  List<Map<String, dynamic>> myProducts = [
    {"name": "Barça Jersey 2024", "price": "45000"},
  ];

  void _openProductModal({int? index}) {
    TextEditingController nameController = TextEditingController(text: index != null ? myProducts[index]['name'] : "");
    TextEditingController priceController = TextEditingController(text: index != null ? myProducts[index]['price'] : "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(index == null ? "Тауар қосу" : "Өңдеу", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Тауар аты")),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: "Бағасы"), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (index == null) {
                    myProducts.add({"name": nameController.text, "price": priceController.text});
                  } else {
                    myProducts[index] = {"name": nameController.text, "price": priceController.text};
                  }
                });
                Navigator.pop(context);
              },
              child: Text(index == null ? "Қосу" : "Сақтау"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text("МЕНІҢ ТАУАРЛАРЫМ"), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView.builder(
        itemCount: myProducts.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            title: Text(myProducts[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${myProducts[index]['price']} ₸"),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF004D98)),
              onPressed: () => _openProductModal(index: index), // РЕДАКЦИЯЛАУ
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => _openProductModal(),
        child: const Icon(Icons.add, color: Color(0xFFA50044)),
      ),
    );
  }
}