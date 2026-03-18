import 'package:flutter/material.dart';
import '../main.dart';

class CartScreen extends StatefulWidget {
  final String lang; // Принимаем язык

  const CartScreen({super.key, required this.lang});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  
  // Словарь для корзины
  final Map<String, Map<String, String>> localizedText = {
    'KZ': {
      'title': 'СЕБЕТ',
      'total': 'Жалпы сумма:',
      'order': 'ТАПСЫРЫС БЕРУ',
      'empty': 'Себет бос',
    },
    'RU': {
      'title': 'КОРЗИНА',
      'total': 'Общая сумма:',
      'order': 'ОФОРМИТЬ ЗАКАЗ',
      'empty': 'Корзина пуста',
    },
    'EN': {
      'title': 'CART',
      'total': 'Total amount:',
      'order': 'PLACE ORDER',
      'empty': 'Cart is empty',
    },
  };

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));

  @override
  Widget build(BuildContext context) {
    final t = localizedText[widget.lang]!;

    return Scaffold(
      backgroundColor: Colors.transparent, // Для градиента
      appBar: AppBar(
        title: Text(t['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: cartItems.isEmpty
          ? Center(child: Text(t['empty']!, style: const TextStyle(color: Colors.white70, fontSize: 18)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _buildCartItem(item, index);
                    },
                  ),
                ),
                _buildBottomBar(t),
              ],
            ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(item['image'], width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${item['price']} ₸', style: const TextStyle(color: Color(0xFFA50044))),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => setState(() {
                  if (item['quantity'] > 1) item['quantity']--;
                  else cartItems.removeAt(index);
                }),
              ),
              Text('${item['quantity']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => setState(() => item['quantity']++),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Map<String, String> t) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t['total']!, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              Text('${totalPrice.toInt()} ₸', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFA50044))),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004D98),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {},
              child: Text(t['order']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}