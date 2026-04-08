import 'package:flutter/material.dart';
import 'dart:io'; // Сурет файлын оқу үшін міндетті түрде керек
import 'edit_product_screen.dart';

class SellerProductsScreen extends StatefulWidget {
  const SellerProductsScreen({super.key});

  @override
  State<SellerProductsScreen> createState() => _SellerProductsScreenState();
}

class _SellerProductsScreenState extends State<SellerProductsScreen> {
  // Уақытша тауарлар тізімі
  List<Map<String, dynamic>> myProducts = [
    {"name": "Barça Jersey 2024", "price": "45000", "image": null},
    {"name": "Away Kit 24/25", "price": "42000", "image": null},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("МЕНІҢ ТАУАРЛАРЫМ", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 тауардан қатар тұрады
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: myProducts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              // Тауардың ішіне кіру (редакциялау)
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductScreen(product: myProducts[index]),
                ),
              );
              if (result != null) {
                setState(() => myProducts[index] = result);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      // --- СУРЕТТІ КӨРСЕТУ БӨЛІМІ ---
                      child: myProducts[index]['image'] != null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: Image.file(
                                File(myProducts[index]['image']),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          myProducts[index]['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1, // Мәтін асып кетпеуі үшін
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${myProducts[index]['price']} ₸",
                          style: const TextStyle(
                            color: Color(0xFFA50044),
                            fontWeight: FontWeight.bold,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Color(0xFFA50044)),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProductScreen()),
          );
          if (result != null) setState(() => myProducts.add(result));
        },
      ),
    );
  }
}