import 'package:flutter/material.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Жалпы табыс карточкасы
            _buildStatCard("Жалпы табыс", "1,250,000 ₸", Icons.payments, Colors.green),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _buildStatCard("Тапсырыстар", "156", Icons.shopping_bag, Colors.orange)),
                const SizedBox(width: 15),
                Expanded(child: _buildStatCard("Клиенттер", "89", Icons.people, Colors.blue)),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Соңғы белсенділік",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            // Уақытша тізім
            Expanded(
              child: ListView(
                children: [
                  _buildActivityItem("Jersey 2024 сатылды", "12 мин бұрын", "+45,000 ₸"),
                  _buildActivityItem("Жаңа тапсырыс #442", "1 сағ бұрын", "Күтуде"),
                  _buildActivityItem("Away Kit сатылды", "3 сағ бұрын", "+42,000 ₸"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
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
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
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