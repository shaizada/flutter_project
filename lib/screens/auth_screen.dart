import 'package:flutter/material.dart';

class SplashOrRegistration extends StatefulWidget {
  // Рөлді де жіберу үшін String name, String role деп өзгерттік
  final Function(String, String) onRegisterSuccess;

  const SplashOrRegistration({super.key, required this.onRegisterSuccess});

  @override
  State<SplashOrRegistration> createState() => _SplashOrRegistrationState();
}

class _SplashOrRegistrationState extends State<SplashOrRegistration> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  bool _isLampOn = false; 
  String _userRole = "Buyer"; // Бастапқы рөл: Сатып алушы

  void _toggleLamp() {
    setState(() {
      _isLampOn = !_isLampOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: _isLampOn ? const Color(0xFF1C1F24) : const Color(0xFF0A0A0A),
        child: Stack(
          children: [
            // 1. ШАМ ЖӘНЕ ЖІП
            Positioned(
              top: 0,
              right: 60,
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

            // 2. ОРТАЛЫҚТАҒЫ ФОРМА
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.sports_soccer, size: 70, color: Color(0xFF004D98)),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'BARÇA STORE',
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 40),

                    // Шам жанғанда шығатын бөлім
                    AnimatedOpacity(
                      opacity: _isLampOn ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 600),
                      child: Visibility(
                        visible: _isLampOn,
                        child: Column(
                          children: [
                            // --- РӨЛ ТАҢДАУ (ЖАҢА) ---
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildRoleChip("Buyer", "Сатып алушы", Icons.shopping_bag_outlined),
                                const SizedBox(width: 15),
                                _buildRoleChip("Seller", "Сатушы", Icons.storefront),
                              ],
                            ),
                            const SizedBox(height: 25),

                            _buildTextField(
                              controller: _nameController,
                              hint: 'Аты-жөні / Ваше Имя',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              controller: _emailController,
                              hint: 'E-mail / Почта',
                              icon: Icons.alternate_email,
                            ),
                            const SizedBox(height: 30),

                            // БАТЫРМА
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF004D98),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                                onPressed: _handleRegister,
                                child: const Text('ЖАЛҒАСТЫРУ / ПРОДОЛЖИТЬ', style: TextStyle(fontWeight: FontWeight.bold)),
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

  // Рөлді таңдауға арналған стильді батырма (Chip)
  Widget _buildRoleChip(String roleId, String label, IconData icon) {
    bool isSelected = _userRole == roleId;
    return GestureDetector(
      onTap: () => setState(() => _userRole = roleId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
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
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  void _handleRegister() {
    if (_nameController.text.isNotEmpty) {
      // Енді аты мен таңдалған рөлін қоса жібереміз
      widget.onRegisterSuccess(_nameController.text.trim(), _userRole);
    }
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
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