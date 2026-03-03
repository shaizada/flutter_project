import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> cards = [
    {"title": "Latest Matches", "icon": Icons.sports_soccer, "color": Colors.blue[800]},
    {"title": "Team News", "icon": Icons.newspaper, "color": Colors.red[700]},
    {"title": "Player Stats", "icon": Icons.bar_chart, "color": Colors.orange[700]},
    {"title": "Tickets & Events", "icon": Icons.event, "color": Colors.purple[700]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcelona Home"),
        backgroundColor: Color(0xFF004D98),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004D98), Color(0xFFA50044)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${card['title']} clicked!")),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    shadowColor: Colors.black45,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            card['color']!.withOpacity(0.8),
                            card['color']!.withOpacity(0.4)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Icon(card['icon'], color: Colors.white, size: 30),
                          ),
                          SizedBox(width: 20),
                          Text(
                            card['title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(2, 2))],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}