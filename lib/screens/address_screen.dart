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

  // Түстік палитра - кодты бір жерден басқару үшін
  final Color primaryBlue = const Color(0xFF004D98);
  final Color primaryRed = const Color(0xFFA50044);

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  void dispose() {
    // Памятьты босату үшін контроллерді жауып тастаймыз
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Локализацияны жеңілдету үшін Map қолданамыз
    final texts = {
      'KZ': {'title': 'Жеткізу мекен-жайы', 'label': 'Толық мекен-жай', 'btn': 'Сақтау'},
      'RU': {'title': 'Адрес доставки', 'label': 'Полный адрес', 'btn': 'Сохранить'},
      'EN': {'title': 'Delivery Address', 'label': 'Full Address', 'btn': 'Save'},
    }[widget.lang] ?? {'title': 'Delivery Address', 'label': 'Full Address', 'btn': 'Save'};

    return Scaffold(
      backgroundColor: primaryBlue,
      appBar: AppBar(
        title: Text(texts['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryRed,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildAddressField(texts['label']!), // Жеке виджет арқылы шақыру
            const Spacer(),
            _buildSaveButton(texts['btn']!),    // Жеке батырма виджеті
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Мекен-жай енгізу өрісі (Custom TextField)
  Widget _buildAddressField(String labelText) {
    return TextField(
      controller: _addressController,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: primaryBlue),
        prefixIcon: Icon(Icons.location_on_rounded, color: primaryBlue),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  // Сақтау батырмасы
  Widget _buildSaveButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 4,
      ),
      onPressed: () {
        // Мәліметті артқа жіберу
        Navigator.pop(context, _addressController.text.trim());
      },
      child: Text(
        text.toUpperCase(), 
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
      ),
    );
  }
}