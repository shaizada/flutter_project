import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String lang;
  final Map<String, String> cardData;

  const PaymentScreen({super.key, required this.lang, required this.cardData});

  @override
  // Бұл жерде класс аты төмендегімен сәйкес болуы керек
  State<PaymentScreen> createState() => _PaymentScreenState();
}

// ҚАТЕ ОСЫ ЖЕРДЕ БОЛДЫ: _ProfileScreenState емес, _PaymentScreenState болуы керек
class _PaymentScreenState extends State<PaymentScreen> {
  // Деректерді экранда жаңарту үшін осы айнымалыны қолданамыз
  late Map<String, String> currentCard;

  @override
  void initState() {
    super.initState();
    // widget.cardData-дан деректерді көшіріп аламыз
    currentCard = Map.from(widget.cardData); 
  }

  // Өңдеу диалогы (BottomSheet)
  void _showEditDialog() {
    final numberController = TextEditingController(text: currentCard['number']);
    final holderController = TextEditingController(text: currentCard['holder']);
    final expiryController = TextEditingController(text: currentCard['expiry']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, 
          left: 25, 
          right: 25, 
          top: 25
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.lang == 'KZ' ? "Картаны өңдеу" : "Редактирование",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: "Card Number", border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: holderController,
              decoration: const InputDecoration(labelText: "Card Holder", border: OutlineInputBorder()),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: expiryController,
              decoration: const InputDecoration(labelText: "Expiry (MM/YY)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA50044),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                setState(() {
                  // Жаңа мәндерді айнымалыға сақтаймыз
                  currentCard = {
                    'number': numberController.text,
                    'holder': holderController.text,
                    'expiry': expiryController.text,
                  };
                });
                Navigator.pop(context); // Диалогты жабу
              },
              child: Text(
                widget.lang == 'KZ' ? "Сақтау" : "Сохранить",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
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
        // Артқа қайтқанда жаңарған деректі ProfileScreen-ге береміз
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, currentCard),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
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
                    currentCard['number']!.isEmpty ? "**** **** **** ****" : currentCard['number']!,
                    style: const TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("CARD HOLDER", style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text(currentCard['holder']!.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("EXPIRES", style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text(currentCard['expiry']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // --- ӨҢДЕУ БАТЫРМАСЫ ---
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: const Icon(Icons.edit, color: Color(0xFF004D98)),
                title: Text(widget.lang == 'KZ' ? 'Картаны өңдеу' : 'Редактировать карту'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _showEditDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }
}