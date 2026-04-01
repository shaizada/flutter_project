import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String lang;
  // Бастапқы деректерді ProfileScreen-нен алу үшін қосамыз
  final String initialName;
  final String initialEmail;

  const EditProfileScreen({
    super.key, 
    required this.lang, 
    required this.initialName, 
    required this.initialEmail
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final TextEditingController _phoneController = TextEditingController(text: "+7 777 777 77 77");

  @override
  void initState() {
    super.initState();
    // Контроллерлерді келген деректермен толтырамыз
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004D98), // Көк
      appBar: AppBar(
        title: Text(widget.lang == 'KZ' ? 'Профильді өңдеу' : 'Редактировать профиль'),
        backgroundColor: const Color(0xFFA50044), // Анар түсі
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
            _buildTextField(
              controller: _nameController,
              label: widget.lang == 'KZ' ? 'Аты-жөні' : 'Имя Фамилия',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: _phoneController,
              label: widget.lang == 'KZ' ? 'Телефон' : 'Телефон',
              icon: Icons.phone_android_outlined,
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA50044),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                // МАҢЫЗДЫ: Мұнда деректерді Map ретінде артқа қайтарамыз
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'email': _emailController.text,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(widget.lang == 'KZ' ? 'Сақталды!' : 'Сохранено!'),
                    backgroundColor: const Color(0xFF004D98),
                  ),
                );
              },
              child: Text(
                widget.lang == 'KZ' ? 'Сақтау' : 'Сохранить',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: const Color(0xFF004D98)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFA50044), width: 2),
        ),
      ),
    );
  }
}