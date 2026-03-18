import 'package:flutter/material.dart';
import '../main.dart';

class FavoritesScreen extends StatefulWidget {
  final String lang; // Принимаем язык из main.dart

  const FavoritesScreen({super.key, required this.lang});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  
  // Словарь для перевода
  final Map<String, Map<String, String>> localizedText = {
    'KZ': {
      'title': 'ТАҢДАУЛЫ',
      'empty': 'Таңдаулы тізімі бос',
      'to_cart': 'Себетке',
      'added': 'Себетке қосылды!',
    },
    'RU': {
      'title': 'ИЗБРАННОЕ',
      'empty': 'Список избранного пуст',
      'to_cart': 'В корзину',
      'added': 'Добавлено в корзину!',
    },
    'EN': {
      'title': 'FAVORITES',
      'empty': 'Favorites list is empty',
      'to_cart': 'To Cart',
      'added': 'Added to cart!',
    },
  };

  @override
  Widget build(BuildContext context) {
    final t = localizedText[widget.lang]!;

    return Scaffold(
      backgroundColor: Colors.transparent, // Прозрачный фон для градиента
      appBar: AppBar(
        title: Text(t['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent, // Прозрачный AppBar
        centerTitle: true,
        elevation: 0,
      ),
      body: favoriteItems.isEmpty
          ? _buildEmptyFavorites(t['empty']!)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                return _buildFavoriteItem(item, index, t);
              },
            ),
    );
  }

  Widget _buildFavoriteItem(Map<String, dynamic> item, int index, Map<String, String> t) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Слегка прозрачный белый
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: Colors.grey[200]),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('${item['price']} ₸', 
                  style: const TextStyle(color: Color(0xFFA50044), fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D98),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(100, 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    setState(() {
                      cartItems.add({...item, 'quantity': 1, 'isSelected': true});
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t['added']!), 
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(t['to_cart']!, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: () {
              setState(() {
                favoriteItems.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFavorites(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 80, color: Colors.white54),
          const SizedBox(height: 10),
          Text(message, style: const TextStyle(fontSize: 18, color: Colors.white70)),
        ],
      ),
    );
  }
}