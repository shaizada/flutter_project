import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic>? product;
  const EditProductScreen({super.key, this.product, required String productId});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController(); // Сипаттама үшін
  
  // КАТЕГОРИЯЛАР ТІЗІМІ (Сатып алушыдағы фильтрлермен бірдей болуы керек)
  String _selectedCategory = "Kit"; 
  final List<String> _categories = ["Kit", "Training", "Accessory", "Retro"];

  XFile? _imageFile; 
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!['name'] ?? "";
      _priceController.text = widget.product!['price'] ?? "";
      _descController.text = widget.product!['description'] ?? ""; // Сипаттаманы жүктеу
      _selectedCategory = widget.product!['category'] ?? "Kit"; // Категорияны жүктеу
    }
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
      });
    }
  }

  // БАЗАҒА САҚТАУ ФУНКЦИЯСЫ (ТОЛЫҚТЫРЫЛҒАН)
  Future<void> _saveProductToFirebase() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;

    try {
      final data = {
        'name': _nameController.text,
        'price': _priceController.text,
        'description': _descController.text, // Сипаттаманы сақтау
        'category': _selectedCategory,        // Категорияны сақтау
        'timestamp': FieldValue.serverTimestamp(),
        'imagePath': _imageFile?.path ?? widget.product?['imagePath'] ?? "", 
      };

      if (widget.product == null) {
        // ЖАҢА ТАУАР ҚОСУ
        await FirebaseFirestore.instance.collection('products').add(data);
      } else {
        // БАР ТАУАРДЫ ӨҢДЕУ (Егер id болса)
        final id = widget.product!['id'];
        if (id != null) {
          await FirebaseFirestore.instance.collection('products').doc(id).update(data);
        }
      }

      if (mounted) Navigator.pop(context); 
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
                height: 200, width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _imageFile != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(File(_imageFile!.path), fit: BoxFit.cover))
                    : (widget.product?['imagePath'] != null && widget.product?['imagePath'] != "" 
                        ? ClipRRect(borderRadius: BorderRadius.circular(20), child: _buildImage(widget.product!['imagePath']))
                        : const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Тауар аты", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: "Бағасы (₸)", border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 15),
            
            // КАТЕГОРИЯ ТАҢДАУ (DROPDOWN)
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: "Категория", border: OutlineInputBorder()),
              items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            const SizedBox(height: 15),

            // СИПАТТАМА ЖАЗУ (DESCRIPTION)
            TextField(
              controller: _descController, 
              maxLines: 3, 
              decoration: const InputDecoration(labelText: "Сипаттама (Description)", border: OutlineInputBorder())
            ),
            
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 157, 1, 66),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: _saveProductToFirebase,
              child: const Text("САҚТАУ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  // Суретті көрсетуге арналған көмекші функция
  Widget _buildImage(String path) {
    if (path.startsWith('assets/')) return Image.asset(path, fit: BoxFit.cover);
    if (path.startsWith('http')) return Image.network(path, fit: BoxFit.cover);
    return Image.file(File(path), fit: BoxFit.cover);
  }
}