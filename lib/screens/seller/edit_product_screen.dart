import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart'; // БАЗАҒА КЕРЕК ИМПОРТ

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic>? product;
  const EditProductScreen({super.key, this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  
  XFile? _imageFile; 
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!['name'] ?? "";
      _priceController.text = widget.product!['price'] ?? "";
    }
  }

  // Галереядан сурет таңдау
  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
      });
    }
  }

  // БАЗАҒА САҚТАУ ФУНКЦИЯСЫ
  Future<void> _saveProductToFirebase() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;

    try {
      // "products" деген коллекцияға сақтаймыз
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text,
        'price': _priceController.text,
        'timestamp': FieldValue.serverTimestamp(),
        // Суретті Firebase Storage-ге салуды келесі сабақта қосамыз
        'imagePath': _imageFile?.path ?? "", 
      });

      if (mounted) {
        Navigator.pop(context); // Сақталған соң артқа қайту
      }
    } catch (e) {
      print("Қате шықты: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? "Жаңа тауар" : "Өңдеу"),
        backgroundColor: const Color(0xFF004D98),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("Сурет таңдау үшін басыңыз", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Тауар аты")),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: "Бағасы (₸)"), keyboardType: TextInputType.number),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 157, 1, 66),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: _saveProductToFirebase, // ОСЫ ЖЕРДЕ БАЗАҒА ЖІБЕРЕМІЗ
              child: const Text("САҚТАУ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}