import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  final String lang;
  final String initialAddress;

  const AddressScreen({super.key, required this.lang, required this.initialAddress});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.lang == 'KZ' ? 'Жеткізу мекен-жайы' : (widget.lang == 'RU' ? 'Адрес доставки' : 'Delivery Address');
    String label = widget.lang == 'KZ' ? 'Толық мекен-жай' : (widget.lang == 'RU' ? 'Полный адрес' : 'Full Address');
    String buttonText = widget.lang == 'KZ' ? 'Сақтау' : (widget.lang == 'RU' ? 'Сохранить' : 'Save');

    return Scaffold(
      backgroundColor: const Color(0xFF004D98),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFA50044),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: const Icon(Icons.location_city, color: Color(0xFF004D98)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA50044),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                Navigator.pop(context, _addressController.text); // Жаңа адресті артқа қайтару
              },
              child: Text(buttonText, style: const TextStyle(color: Colors.white, fontSize: 18)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}