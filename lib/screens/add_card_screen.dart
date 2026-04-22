import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 1. Бұл міндетті түрде керек

class AddCardScreen extends StatefulWidget {
  final Map<String, String> initialData;
  const AddCardScreen({super.key, required this.initialData});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  late TextEditingController _numberController;
  late TextEditingController _holderController;
  late TextEditingController _expiryController;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.initialData['number']);
    _holderController = TextEditingController(text: widget.initialData['holder']);
    _expiryController = TextEditingController(text: widget.initialData['expiry']);
  }

  // 2. Деректі базаға жіберетін функция
  Future<void> _saveToFirebase() async {
    try {
      await FirebaseFirestore.instance.collection('cards').add({
        'number': _numberController.text,
        'holder': _holderController.text,
        'expiry': _expiryController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        Navigator.pop(context); // Сақталған соң артқа қайтады
      }
    } catch (e) {
      print("Қате шықты: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Карта деректері"), backgroundColor: const Color(0xFFA50044)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _numberController, decoration: const InputDecoration(labelText: "Карта нөмірі")),
            const SizedBox(height: 10),
            TextField(controller: _holderController, decoration: const InputDecoration(labelText: "Иесінің аты (Holder)")),
            const SizedBox(height: 10),
            TextField(controller: _expiryController, decoration: const InputDecoration(labelText: "Мерзімі (MM/YY)")),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004D98), minimumSize: const Size(double.infinity, 50)),
              onPressed: _saveToFirebase, // 3. Осы жерде функцияны шақырамыз
              child: const Text("Сақтау", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}