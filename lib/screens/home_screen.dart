import 'package:flutter/material.dart';
import '../data/products.dart';
import '../main.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String lang; // Принимаем язык из main.dart

  const HomeScreen({super.key, required this.lang});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  // Словарь для перевода текстов на главной
  final Map<String, Map<String, String>> localizedText = {
    'KZ': {
      'title': 'БАРСА ДҮКЕНІ',
      'add': 'Қосу',
      'added': 'себетке қосылды!',
    },
    'RU': {
      'title': 'МАГАЗИН БАРСЫ',
      'add': 'Добавить',
      'added': 'добавлено в корзину!',
    },
    'EN': {
      'title': 'BARÇA STORE',
      'add': 'Add',
      'added': 'added to cart!',
    },
  };

  @override
  Widget build(BuildContext context) {
    final t = localizedText[widget.lang]!;

    return Scaffold(
      backgroundColor: Colors.transparent, // Прозрачный фон, чтобы видеть градиент
      appBar: AppBar(
        title: Text(t['title']!,
            style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.white)),
        backgroundColor: Colors.transparent, 
        centerTitle: true,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 0.7, 
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: barcaProducts.length,
        itemBuilder: (context, index) {
          final product = barcaProducts[index];
          bool isFavorite = favoriteItems.any((item) => item['name'] == product['name']);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(
                    product: product, 
                    lang: widget.lang, 
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset( // ИСПРАВЛЕНО: используем локальные файлы
                              product['image'],
                              fit: BoxFit.contain, // Чтобы одежда не обрезалась
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isFavorite) {
                                  favoriteItems.removeWhere((item) => item['name'] == product['name']);
                                } else {
                                  favoriteItems.add(product);
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.9),
                              radius: 16,
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                size: 18,
                                color: const Color(0xFFA50044),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${product['price']} ₸',
                          style: const TextStyle(
                            color: Color(0xFFA50044),
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 32,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF004D98),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              setState(() {
                                final i = cartItems.indexWhere((item) => item['name'] == product['name']);
                                if (i != -1) {
                                  cartItems[i]['quantity']++;
                                } else {
                                  cartItems.add({...product, 'quantity': 1, 'isSelected': true, 'size': 'M'});
                                }
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product['name']} ${t['added']}'),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF004D98),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_shopping_cart, size: 14),
                                const SizedBox(width: 4),
                                Text(t['add']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}