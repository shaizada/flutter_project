import 'package:flutter/material.dart';
import '../main.dart'; // myOrders тізімін алу үшін

class OrdersScreen extends StatefulWidget {
  final String lang;
  const OrdersScreen({super.key, required this.lang});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final isKZ = widget.lang == 'KZ';
    
    // Тілдер бойынша мәтіндер
    final Map<String, String> txt = {
      'title': isKZ ? "Менің тапсырыстарым" : "Мои заказы",
      'empty': isKZ ? "Тапсырыстар әлі жоқ" : "Заказов пока нет",
      'order': isKZ ? "Тапсырыс" : "Заказ",
      'total': isKZ ? "Жалпы" : "Итого",
      'items': isKZ ? "Тауарлар" : "Товары",
      'delete': isKZ ? "Өшірілді" : "Удалено",
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(txt['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 5, 83, 161),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: myOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 15),
                  Text(txt['empty']!, style: const TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myOrders.length,
              itemBuilder: (context, index) {
                // Кері ретпен алу (соңғы тапсырыс жоғарыда тұруы үшін)
                final orderIndex = myOrders.length - 1 - index;
                final order = myOrders[orderIndex];
                final DateTime date = order['date'];
                final List items = order['items'];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  child: ExpansionTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFA50044),
                      child: Icon(Icons.shopping_bag, color: Colors.white, size: 20),
                    ),
                    title: Text(
                      "${txt['order']} #${orderIndex + 1}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                    ),
                    // ОҢ ЖАҚ БӨЛІМ: БАҒА ЖӘНЕ ӨШІРУ БАТЫРМАСЫ
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${order['total'].toInt()} ₸",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004D98)),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                          onPressed: () {
                            setState(() {
                              // Глобалды тізімнен өшіру
                              myOrders.removeAt(orderIndex);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(txt['delete']!),
                                duration: const Duration(seconds: 1),
                                backgroundColor: const Color(0xFFA50044),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    children: [
                      const Divider(),
                      ...items.map((item) => ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: item['image'].startsWith('http')
                              ? Image.network(item['image'], width: 40, height: 40, fit: BoxFit.cover, 
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image))
                              : Image.asset(item['image'], width: 40, height: 40, fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image)),
                        ),
                        title: Text(item['name'], style: const TextStyle(fontSize: 14)),
                        subtitle: Text("${item['quantity']} шт x ${item['price']} ₸"),
                        trailing: Text("${(item['price'] * item['quantity']).toInt()} ₸"),
                      )),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
    );
  }
}