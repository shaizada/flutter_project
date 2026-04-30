import 'package:flutter/material.dart';
import 'dart:io'; // Файлдармен жұмыс істеу үшін керек
import '../main.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final String lang;

  const ProductDetailScreen({super.key, required this.product, required this.lang});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = 'M';
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = favoriteItems.any((item) => item['name'] == widget.product['name']);
  }

  // СУРЕТТІ ТҮРІНЕ ҚАРАЙ КӨРСЕТУ ФУНКЦИЯСЫ
  Widget _buildProductImage(String? path) {
    if (path == null || path.isEmpty) {
      return const Icon(Icons.image, size: 100, color: Colors.grey);
    }
    if (path.startsWith('assets/')) {
      return Image.asset(path, fit: BoxFit.contain);
    } else if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.contain);
    } else {
      return Image.file(File(path), fit: BoxFit.contain);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, String>> t = {
      'KZ': {
        'select_size': 'Өлшемді таңдаңыз:',
        'desc_title': 'Сипаттамасы:',
        'buy_now': 'ҚАЗІР САТЫП АЛУ',
        'added': 'себетке қосылды!',
        'official': 'Ресми Barça өнімі • 2024/25',
      },
      'RU': {
        'select_size': 'Выберите размер:',
        'desc_title': 'Описание:',
        'buy_now': 'КУПИТЬ СЕЙЧАС',
        'added': 'добавлено в корзину!',
        'official': 'Официальный продукт Barça • 2024/25',
      },
      'EN': {
        'select_size': 'Select size:',
        'desc_title': 'Description:',
        'buy_now': 'BUY NOW',
        'added': 'added to cart!',
        'official': 'Official Barça Product • 2024/25',
      },
    };

    final words = t[widget.lang]!;
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: const Color(0xFF004D98),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: product['name'] ?? 'product_tag', 
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 50, bottom: 20),
                  child: _buildProductImage(product['image'] ?? product['imagePath']), // ЖӨНДЕЛДІ
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, 
                    color: isFavorite ? Colors.red : Colors.white),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                    if (isFavorite) {
                      favoriteItems.add(product);
                    } else {
                      favoriteItems.removeWhere((item) => item['name'] == product['name']);
                    }
                  });
                },
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product['price']} ₸',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFFA50044)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['name'] ?? "No Name",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(words['official']!, style: const TextStyle(color: Colors.grey)),
                  
                  const Divider(height: 40),

                  Text(words['select_size']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: ['S', 'M', 'L', 'XL'].map((size) {
                      bool isSelected = selectedSize == size;
                      return GestureDetector(
                        onTap: () => setState(() => selectedSize = size),
                        child: Container(
                          margin: const EdgeInsets.only(right: 15),
                          width: 55, height: 55,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF004D98) : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!),
                          ),
                          child: Center(
                            child: Text(size, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  Text(words['desc_title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  
                  // СИПАТТАМАНЫ БАЗАДАН АЛУ (ЕГЕР БОС БОЛСА, ЕСКІ ТЕКСТІ КӨРСЕТУ)
                  Text(
                    product['description'] ?? "Nike Dri-FIT: Терді тез шығарып, денені құрғақ ұстайды. 100% полиэстер.",
                    style: TextStyle(color: Colors.grey[800], fontSize: 16, height: 1.6),
                  ),
                  
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        ],
      ),
      
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                cartItems.add({...product, 'quantity': 1, 'isSelected': true, 'size': selectedSize});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product['name']} ${words['added']}')),
                );
              },
              child: Container(
                height: 60, width: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF004D98)),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.add_shopping_cart, color: Color(0xFF004D98)),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA50044),
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {},
                child: Text(words['buy_now']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}