import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String lang;
  final Map<String, String> cardData;

  const PaymentScreen({super.key, required this.lang, required this.cardData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Map<String, String> currentCard;

  @override
  void initState() {
    super.initState();
    currentCard = widget.cardData;
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.lang == 'KZ' ? 'Төлем әдістері' : (widget.lang == 'RU' ? 'Методы оплаты' : 'Payment Methods');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFA50044),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- КАРТА ДИЗАЙНЫ ---
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF004D98), Color(0xFFA50044)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
              ),
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.credit_card, color: Colors.white, size: 40),
                  ),
                  Text(
                    currentCard['number'] ?? "**** **** **** ****",
                    style: const TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("CARD HOLDER", style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text(currentCard['holder'] ?? "NAME SURNAME", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("EXPIRES", style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text(currentCard['expiry'] ?? "00/00", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // КАРТАНЫ ӨЗГЕРТУ БАТЫРМАСЫ
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF004D98)),
              title: Text(widget.lang == 'KZ' ? 'Картаны өңдеу' : 'Редактировать карту'),
              onTap: () async {
                // Бұл жерде AddCardScreen-ге өтеміз (оны келесі қадамда жасаймыз)
                _showEditDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Уақытша өңдеу диалогы (кейін жеке бетке ауыстырамыз)
  void _showEditDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: "Card Number")),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Save"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}