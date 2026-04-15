import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../main.dart'; // Глобалды айнымалыларға (myOrders, cartItems) қол жеткізу үшін

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String address;
  final Map<String, String> cardData;
  final String lang;

  const CheckoutScreen({
    super.key,
    required this.items,
    required this.address,
    required this.cardData,
    required this.lang,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;
  bool _isSuccess = false;

  // Бағаны есептеу (әр тауардың санына көбейтуді ұмытпаймыз)
  double get totalPrice {
    return widget.items.fold(0, (sum, item) => sum + ((item['price'] ?? 0) * (item['quantity'] ?? 1)));
  }

// CheckoutScreen ішіндегі _processOrder-ді осыған ауыстыр:
void _processOrder() async {
  setState(() => _isProcessing = true);

  await Future.delayed(const Duration(seconds: 2));

  if (mounted) {
    setState(() {
      // Тапсырысты сақтау
      myOrders.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'date': DateTime.now(),
        'items': List.from(widget.items), 
        'total': totalPrice,
      });

      // СЕБЕТТІ ТАЗАРТУДЫ ОСЫ ЖЕРДЕ ЖАСАЙМЫЗ
      cartItems.clear(); 

      _isProcessing = false;
      _isSuccess = true;
    });
  }

  // Күте тұру және қайту
  await Future.delayed(const Duration(seconds: 3));
  if (mounted) {
    // popUntil қолданғанда сақ болу керек, егер маршруттар дұрыс болмаса қате береді
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

  @override
  Widget build(BuildContext context) {
    final isKZ = widget.lang == 'KZ';

    if (_isSuccess) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Lottie.network(
  'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json', 
  width: 250,
  repeat: false,
),
              const SizedBox(height: 20),
              Text(
                isKZ ? "Тапсырыс қабылданды!" : "Заказ принят!",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF004D98)),
              ),
              const SizedBox(height: 10),
              Text(
                isKZ ? "Себет босатылды" : "Корзина очищена",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isKZ ? "Тапсырысты рәсімдеу" : "Оформление заказа"),
        backgroundColor: const Color(0xFF004D98),
        foregroundColor: Colors.white,
      ),
      body: _isProcessing 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFA50044)))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(isKZ ? "Жеткізу мекен-жайы" : "Адрес доставки"),
                _buildInfoCard(Icons.location_on, widget.address),
                
                const SizedBox(height: 20),
                _buildSectionTitle(isKZ ? "Төлем әдісі" : "Метод оплаты"),
                _buildInfoCard(Icons.credit_card, "**** **** **** ${widget.cardData['number']!.substring(widget.cardData['number']!.length - 4)}"),

                const SizedBox(height: 20),
                _buildSectionTitle(isKZ ? "Тауарлар тізімі" : "Список товаров"),
                ...widget.items.map((item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item['name']),
                  subtitle: Text("${item['quantity']} шт"),
                  trailing: Text("${(item['price'] * item['quantity']).toInt()} ₸"),
                )),

                const Divider(height: 40, thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isKZ ? "Жалпы сома:" : "Итого:", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("${totalPrice.toInt()} ₸", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFA50044))),
                  ],
                ),
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _processOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D98),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(isKZ ? "ТӨЛЕУ ЖӘНЕ ТАПСЫРЫС БЕРУ" : "ОПЛАТИТЬ И ЗАКАЗАТЬ", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildInfoCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF004D98)),
          const SizedBox(width: 15),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}