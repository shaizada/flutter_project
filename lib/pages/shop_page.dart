import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  final List<Map<String, String>> products = [
    {"name":"Home Jersey","price":"89","image":"https://upload.wikimedia.org/wikipedia/en/4/47/FC_Barcelona_crest.svg"},
    {"name":"Away Jersey","price":"85","image":"https://upload.wikimedia.org/wikipedia/en/4/47/FC_Barcelona_crest.svg"},
    {"name":"Hoodie","price":"120","image":"https://upload.wikimedia.org/wikipedia/en/4/47/FC_Barcelona_crest.svg"},
    {"name":"Scarf","price":"35","image":"https://upload.wikimedia.org/wikipedia/en/4/47/FC_Barcelona_crest.svg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Barcelona Shop"), backgroundColor: Color(0xFF004D98)),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF004D98), Color(0xFFA50044)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(15),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15, childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final item = products[index];
            return Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(item["image"]!, height:80),
                  SizedBox(height:10),
                  Text(item["name"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height:5),
                  Text(item["price"]!),
                  SizedBox(height:10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFA50044)),
                    onPressed: (){},
                    child: Text("Add to Cart"),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}