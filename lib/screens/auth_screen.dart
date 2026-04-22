import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🔥 Firebase пакеті

class SplashOrRegistration extends StatefulWidget {
  final VoidCallback onRegisterSuccess;

  const SplashOrRegistration({super.key, required this.onRegisterSuccess});

  @override
  State<SplashOrRegistration> createState() => _SplashOrRegistrationState();
}

class _SplashOrRegistrationState extends State<SplashOrRegistration> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // 🔥 Құпия сөз үшін
  
  bool _isLampOn = false; 
  String _userRole = "Buyer"; 
  bool _isLoading = false; // Жүктелу күйі

  void _toggleLamp() {
    setState(() {
      _isLampOn = !_isLampOn;
    });
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // --- FIREBASE-ПЕН ТІРКЕЛУ ЖӘНЕ КІРУ ---
  Future<void> _handleRegister() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim(); // Firebase-ке пароль керек

    if (name.isEmpty || email.isEmpty || password.length < 6) {
      _showError('Барлық жолақты толтырыңыз! (Пароль мин. 6 таңба)');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Firebase-те тіркелуге немесе кіруге тырысамыз
      UserCredential userCredential;
      
      try {
        // Алдымен жаңа пайдаланушы ретінде тіркеу
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // Егер почта бар болса, жай ғана кіру (Login)
          userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else {
          throw e;
        }
      }

      // 2. Сәтті өтсе, деректерді SharedPreferences-ке сақтаймыз (бұрынғыдай)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);
      await prefs.setString('user_role', _userRole);
      await prefs.setBool('is_logged_in', true);
      
      setState(() => _isLoading = false);
      widget.onRegisterSuccess();

    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Қате шықты: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFA50044),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: _isLampOn ? const Color(0xFF1C1F24) : const Color(0xFF0A0A0A),
        child: Stack(
          children: [
            // 1. ШАМ
            Positioned(
              top: 0, right: 60,
              child: GestureDetector(
                onTap: _toggleLamp,
                child: Column(
                  children: [
                    Container(width: 2, height: 120, color: Colors.white38),
                    Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: _isLampOn ? Colors.yellow : Colors.grey[800],
                        shape: BoxShape.circle,
                        boxShadow: _isLampOn 
                          ? [BoxShadow(color: Colors.yellow.withOpacity(0.6), blurRadius: 40, spreadRadius: 10)] 
                          : [],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 2. ФОРМА
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.sports_soccer, size: 70, color: Color(0xFF004D98)),
                    ),
                    const SizedBox(height: 20),
                    const Text('BARÇA STORE', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 40),
                    AnimatedOpacity(
                      opacity: _isLampOn ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 600),
                      child: Visibility(
                        visible: _isLampOn,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildRoleChip("Buyer", "Сатып алушы", Icons.shopping_bag_outlined),
                                const SizedBox(width: 15),
                                _buildRoleChip("Seller", "Сатушы", Icons.storefront),
                              ],
                            ),
                            const SizedBox(height: 25),
                            _buildTextField(controller: _nameController, hint: 'Аты-жөні', icon: Icons.person_outline),
                            const SizedBox(height: 15),
                            _buildTextField(controller: _emailController, hint: 'E-mail', icon: Icons.alternate_email, keyboardType: TextInputType.emailAddress),
                            const SizedBox(height: 15),
                            _buildTextField(controller: _passwordController, hint: 'Пароль', icon: Icons.lock_outline, isPassword: true),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity, height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, 
                                  foregroundColor: const Color(0xFF004D98), 
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                                ),
                                onPressed: _isLoading ? null : _handleRegister,
                                child: _isLoading 
                                  ? const CircularProgressIndicator()
                                  : const Text('КІРУ / ТІРКЕЛУ', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleChip(String roleId, String label, IconData icon) {
    bool isSelected = _userRole == roleId;
    return GestureDetector(
      onTap: () => setState(() => _userRole = roleId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFA50044) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: isSelected ? Colors.white : Colors.white24, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, 
    required String hint, 
    required IconData icon, 
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false
  }) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none, 
          hintText: hint, 
          prefixIcon: Icon(icon, color: const Color(0xFF004D98)), 
          contentPadding: const EdgeInsets.symmetric(vertical: 18)
        ),
      ),
    );
  }
}