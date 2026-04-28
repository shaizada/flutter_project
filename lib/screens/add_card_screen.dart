import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Форматтау үшін керек
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool _isLoading = false; // Жүктеу күйі

  final Color primaryBlue = const Color(0xFF004D98);
  final Color primaryRed = const Color(0xFFA50044);

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.initialData['number']);
    _holderController = TextEditingController(text: widget.initialData['holder']);
    _expiryController = TextEditingController(text: widget.initialData['expiry']);
  }

  @override
  void dispose() {
    _numberController.dispose();
    _holderController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  // Firebase-ке қауіпсіз сақтау функциясы
  Future<void> _handleSave() async {
    if (_numberController.text.isEmpty || _holderController.text.isEmpty) {
      _showSnackBar("Барлық өрістерді толтырыңыз");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('cards').add({
        'number': _numberController.text.replaceAll(' ', ''), // Бос орындарсыз сақтау
        'holder': _holderController.text.toUpperCase(),
        'expiry': _expiryController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnackBar("Қате шықты: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: primaryRed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Банк картасы", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryRed,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildStyledField(
              controller: _numberController,
              label: "Карта нөмірі",
              icon: Icons.credit_card,
              kType: TextInputType.number,
              // Карта нөмірін 4 саннан бөліп тұру үшін:
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ],
            ),
            const SizedBox(height: 16),
            _buildStyledField(
              controller: _holderController,
              label: "Иесінің аты (Full Name)",
              icon: Icons.person_outline,
              kType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            _buildStyledField(
              controller: _expiryController,
              label: "Мерзімі (MM/YY)",
              icon: Icons.date_range,
              kType: TextInputType.datetime,
              formatters: [LengthLimitingTextInputFormatter(5)],
            ),
            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType kType = TextInputType.text,
    List<TextInputFormatter>? formatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: kType,
      inputFormatters: formatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryBlue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: _isLoading ? null : _handleSave,
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text("КАРТАНЫ САҚТАУ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}