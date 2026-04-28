import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Міндетті түрде керек

class SellerStatisticsScreen extends StatelessWidget {
  const SellerStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("СТАТИСТИКА", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // "orders" коллекциясын нақты уақытта бақылаймыз
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Деректер табылмады", style: TextStyle(color: Colors.white)));
          }

          // --- ЕСЕПТЕУЛЕР БӨЛІМІ ---
          double totalRevenue = 0;
          int totalOrders = snapshot.data!.docs.length;
          var orderDocs = snapshot.data!.docs;

          for (var doc in orderDocs) {
            var data = doc.data() as Map<String, dynamic>;
            // "price" өрісін (number) алып, жалпы табысқа қосамыз
            totalRevenue += (data['price'] ?? 0).toDouble();
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // ЖАЛПЫ ТАБЫС (Базадан есептелген)
                _buildStatCard("Жалпы табыс", "${totalRevenue.toStringAsFixed(0)} ₸", Icons.payments, Colors.green),
                const SizedBox(height: 15),
                Row(
                  children: [
                    // ТАПСЫРЫСТАР САНЫ (Құжаттар саны)
                    Expanded(child: _buildStatCard("Тапсырыстар", totalOrders.toString(), Icons.shopping_bag, Colors.orange)),
                    const SizedBox(width: 15),
                    // КЛИЕНТТЕР САНЫ (Мысалы, static 89 немесе басқа коллекциядан алуға болады)
                    Expanded(child: _buildStatCard("Клиенттер", "89", Icons.people, Colors.blue)),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  "Соңғы белсенділік",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                // БАЗАДАН КЕЛГЕН СОҢҒЫ ТАПСЫРЫСТАР ТІЗІМІ
                Expanded(
                  child: ListView.builder(
                    itemCount: orderDocs.length,
                    itemBuilder: (context, index) {
                      var data = orderDocs[index].data() as Map<String, dynamic>;
                      return _buildActivityItem(
                        "${data['productName'] ?? 'Тауар'} сатылды", 
                        "Жаңа", // Уақытын базаға timestamp қосу арқылы шығаруға болады
                        "+${data['price']} ₸"
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(title, style: TextStyle(color: const Color.fromARGB(255, 90, 90, 90), fontSize: 14)),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, String amount) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Color(0xFF004D98), child: Icon(Icons.history, color: Colors.white)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(time),
        trailing: Text(amount, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
      ),
    );
  }
}