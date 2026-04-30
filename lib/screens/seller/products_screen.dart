import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:io';

import '../../data/products.dart'; // Ескі тауарлар тізімі осы жерде

import 'edit_product_screen.dart';



class SellerProductsScreen extends StatefulWidget {

  const SellerProductsScreen({super.key});



  @override

  State<SellerProductsScreen> createState() => _SellerProductsScreenState();

}



class _SellerProductsScreenState extends State<SellerProductsScreen> {

 

  // --- БҰЛ ФУНКЦИЯ ЕСКІ ТАУАРЛАРДЫ FIREBASE-КЕ КӨШІРЕДІ ---

  Future<void> syncOldProducts() async {

    final collection = FirebaseFirestore.instance.collection('products');

   

    // Жүктеліп жатқанын көрсету

    showDialog(

      context: context,

      barrierDismissible: false,

      builder: (context) => const Center(child: CircularProgressIndicator()),

    );



    for (var item in barcaProducts) {

      await collection.add({

        'name': item['name'],

        'price': item['price'].toString(), // Сатушыға ыңғайлы болу үшін String

        'imagePath': item['image'],

        'category': item['category'],

        'description': 'Official FC Barcelona product',

      });

    }



    Navigator.pop(context); // Индикаторды жабу

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(content: Text("Барлық ескі тауарлар базаға сәтті қосылды!")),

    );

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.transparent,

      appBar: AppBar(

  title: const Text(

    "МЕНІҢ ТАУАРЛАРЫМ",

    style: TextStyle(fontWeight: FontWeight.bold)

  ),

  backgroundColor: Colors.transparent,

  elevation: 0,

  centerTitle: true,

  // actions бөлігін толықтай өшіріп тастадық

),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance.collection('products').snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(child: CircularProgressIndicator());

          }



          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {

            return const Center(child: Text("Тауарлар табылмады", style: TextStyle(color: Colors.white)));

          }



          var products = snapshot.data!.docs;



          return GridView.builder(

            padding: const EdgeInsets.all(15),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

              crossAxisCount: 2,

              childAspectRatio: 0.75,

              crossAxisSpacing: 12,

              mainAxisSpacing: 12,

            ),

            itemCount: products.length,

            itemBuilder: (context, index) {

              var data = products[index].data() as Map<String, dynamic>;

             

              return GestureDetector(

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (context) => EditProductScreen(product: data, productId: '',),

                    ),

                  );

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

                          // СУРЕТТІ КӨРСЕТУ ЛОГИКАСЫН ЖӨНДЕДІК

                          child: ClipRRect(

                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),

                            child: _buildImage(data['imagePath']),

                          ),

                        ),

                      ),

                      Padding(

                        padding: const EdgeInsets.all(10),

                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Text(

                              data['name'] ?? "Аты жоқ",

                              style: const TextStyle(fontWeight: FontWeight.bold),

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                            ),

                            const SizedBox(height: 5),

                            Text(

                              "${data['price']} ₸",

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

          );

        },

      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: Colors.white,

        child: const Icon(Icons.add, color: Color(0xFFA50044)),

        onPressed: () {

          Navigator.push(

            context,

            MaterialPageRoute(builder: (context) => const EditProductScreen(productId: '',)),

          );

        },

      ),

    );

  }



  // Суреттің түріне қарай (File, Asset немесе Network) көрсету

  Widget _buildImage(String? path) {

    if (path == null || path.isEmpty) {

      return const Icon(Icons.image, size: 50, color: Colors.grey);

    }

   

    if (path.startsWith('assets/')) {

      return Image.asset(path, fit: BoxFit.contain);

    } else if (path.startsWith('http')) {

      return Image.network(path, fit: BoxFit.contain);

    } else {

      // Егер телефонның ішіндегі файл болса (Сатушы жаңадан қосқанда)

      return Image.file(File(path), fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {

        return const Icon(Icons.broken_image, size: 50);

      });

    }

  }

}