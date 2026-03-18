import 'package:flutter/material.dart';

class SplashOrRegistration extends StatefulWidget {
  final Function(String) onRegisterSuccess; // Функция, чтобы вернуть имя в main

  const SplashOrRegistration({super.key, required this.onRegisterSuccess});

  @override
  State<SplashOrRegistration> createState() => _SplashOrRegistrationState();
}

class _SplashOrRegistrationState extends State<SplashOrRegistration> {
  // Контроллеры для полей ввода
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _handleRegister() {
    // Получаем имя из поля ввода
    String name = _nameController.text.trim();

    if (name.isNotEmpty) {
      // Сохраняем имя в глобальную переменную (через функцию в main)
      widget.onRegisterSuccess(name);
    } else {
      // Уведомление, если имя пустое
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Аты-жөніңізді енгізіңіз / Введите ваше имя')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Для градиента
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ЛОГОТИП (можно заменить на картинку позже)
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Icon(Icons.sports_soccer, size: 80, color: Color(0xFF004D98)),
            ),
            const SizedBox(height: 20),
            const Text(
              'BARÇA STORE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Visca el Barça! Кіру / Регистрация',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 50),

            // ПОЛЕ ВВОДА ИМЕНИ
            _buildTextField(
              controller: _nameController,
              hint: 'Аты-жөні / Ваше Имя',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 15),

            // ПОЛЕ ВВОДА E-MAIL (для UX, не сохраняем)
            _buildTextField(
              controller: _emailController,
              hint: 'E-mail / Почта',
              icon: Icons.alternate_email,
              keyboard: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),

            // КНОПКА РЕГИСТРАЦИИ
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Белая кнопка
                  foregroundColor: const Color(0xFF004D98), // Синий текст
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _handleRegister, // Вызываем функцию при нажатии
                child: const Text(
                  'ЖАЛҒАСТЫРУ / ПРОДОЛЖИТЬ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Общий виджет для полей ввода
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF004D98)),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}