import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore қосылды
import 'dart:io'; // Файлдарды оқу үшін
import '../data/products.dart';
import '../main.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String lang;
  const HomeScreen({super.key, required this.lang});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedCategory = "All";

  RangeValues _currentRangeValues = const RangeValues(0, 100000);
  List<String> _selectedSizes = [];
  bool _fastDeliveryOnly = false;

  final Map<String, Map<String, String>> localizedText = {
    'KZ': {
      'title': 'БАРСА ДҮКЕНІ',
      'search': 'Тауарларды іздеу...',
      'cat_all': 'Барлық өнімдер',
      'cat_kit': 'Форма',
      'cat_train': 'Жаттығу',
      'cat_acc': 'Аксессуарлар',
      'cat_retro': 'Ретро',
      'add': 'Қосу',
      'added': 'себетке қосылды!',
      'filter_title': 'Фильтрлер',
      'price': 'Бағасы',
      'size': 'Өлшемі',
      'delivery': 'Жедел жеткізу',
      'apply': 'Қолдану',
      'reset': 'Тастау',
      'no_items': 'Тауар табылмады',
    },
    'RU': {
      'title': 'МАГАЗИН БАРСЫ',
      'search': 'Поиск товаров...',
      'cat_all': 'Все товары',
      'cat_kit': 'Форма',
      'cat_train': 'Тренировка',
      'cat_acc': 'Аксессуары',
      'cat_retro': 'Ретро',
      'add': 'Добавить',
      'added': 'добавлено в корзину!',
      'filter_title': 'Фильтры',
      'price': 'Цена',
      'size': 'Размер',
      'delivery': 'Экспресс-доставка',
      'apply': 'Применить',
      'reset': 'Сбросить',
      'no_items': 'Ничего не найдено',
    },
    'EN': {
      'title': 'BARÇA STORE',
      'search': 'Search products...',
      'cat_all': 'All',
      'cat_kit': 'Kits',
      'cat_train': 'Training',
      'cat_acc': 'Accessories',
      'cat_retro': 'Retro',
      'add': 'Add',
      'added': 'added to cart!',
      'filter_title': 'Filters',
      'price': 'Price',
      'size': 'Size',
      'delivery': 'Fast Delivery',
      'apply': 'Apply',
      'reset': 'Reset',
      'no_items': 'No products found',
    },
  };

  void _showFilterPanel() {
    final t = localizedText[widget.lang]!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 20),
                  Text(t['filter_title']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 25),
                  Text("${t['price']}: ${_currentRangeValues.start.round()} - ${_currentRangeValues.end.round()} ₸", 
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  RangeSlider(
                    values: _currentRangeValues,
                    max: 100000,
                    divisions: 20,
                    activeColor: const Color(0xFFA50044),
                    labels: RangeLabels(_currentRangeValues.start.round().toString(), _currentRangeValues.end.round().toString()),
                    onChanged: (values) => setModalState(() => _currentRangeValues = values),
                  ),
                  const SizedBox(height: 20),
                  Text(t['size']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: ['S', 'M', 'L', 'XL'].map((size) {
                      bool isSel = _selectedSizes.contains(size);
                      return ChoiceChip(
                        label: Text(size),
                        selected: isSel,
                        selectedColor: const Color(0xFF004D98),
                        labelStyle: TextStyle(color: isSel ? Colors.white : Colors.black),
                        onSelected: (selected) => setModalState(() => selected ? _selectedSizes.add(size) : _selectedSizes.remove(size)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: Text(t['delivery']!, style: const TextStyle(color: Colors.black)),
                    value: _fastDeliveryOnly,
                    activeColor: const Color(0xFFA50044),
                    onChanged: (val) => setModalState(() => _fastDeliveryOnly = val),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _currentRangeValues = const RangeValues(0, 100000);
                              _selectedSizes = [];
                              _fastDeliveryOnly = false;
                            });
                            Navigator.pop(context);
                          },
                          child: Text(t['reset']!),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA50044), foregroundColor: Colors.white),
                          onPressed: () {
                            setState(() {}); 
                            Navigator.pop(context);
                          },
                          child: Text(t['apply']!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        );
      },
    );
  }

  // Суретті көрсету логикасы (Firebase-тен келген жолды оқу үшін)
  Widget _buildProductImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, fit: BoxFit.contain);
    } else if (imagePath.startsWith('http')) {
      return Image.network(imagePath, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image));
    } else {
      return Image.file(File(imagePath), fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = localizedText[widget.lang]!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(t['title']!,
                style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.white)),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            floating: true,
            snap: true,
            pinned: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.tune, color: Colors.white),
                onPressed: _showFilterPanel,
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(130),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _searchQuery = value),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: t['search'],
                        hintStyle: const TextStyle(color: Colors.white60),
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        _buildCategoryChip("All", t['cat_all']!),
                        _buildCategoryChip("Kit", t['cat_kit']!),
                        _buildCategoryChip("Training", t['cat_train']!),
                        _buildCategoryChip("Accessory", t['cat_acc']!),
                        _buildCategoryChip("Retro", t['cat_retro']!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FIREBASE STREAM BUILDER ОСЫ ЖЕРДЕ
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: Colors.white)));
              }

              // Firebase-тен келген деректерді фильтрлеу
              final docs = snapshot.data?.docs ?? [];
              final List<Map<String, dynamic>> firebaseProducts = docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return {
                  'id': doc.id,
                  'name': data['name'] ?? '',
                  'price': double.tryParse(data['price'].toString()) ?? 0.0,
                  'image': data['imagePath'] ?? data['image'] ?? 'assets/images/placeholder.png',
                  'category': data['category'] ?? 'All',
                  'description': data['description'] ?? '',
                };
              }).toList();

              // Іздеу және фильтрлеу логикасы
              final filteredProducts = firebaseProducts.where((product) {
                final nameMatches = product['name'].toLowerCase().contains(_searchQuery.toLowerCase());
                final categoryMatches = _selectedCategory == "All" || product['category'] == _selectedCategory;
                final priceMatches = product['price'] >= _currentRangeValues.start && product['price'] <= _currentRangeValues.end;
                return nameMatches && categoryMatches && priceMatches;
              }).toList();

              if (filteredProducts.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Text(t['no_items']!, style: const TextStyle(color: Colors.white))),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 0.68, 
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredProducts[index];
                      bool isFavorite = favoriteItems.any((item) => item['name'] == product['name']);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(
                                product: product,
                                lang: widget.lang,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Center(
                                          child: _buildProductImage(product['image']),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: IconButton(
                                        icon: Icon(
                                          isFavorite ? Icons.favorite : Icons.favorite_border,
                                          color: const Color(0xFFA50044),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (isFavorite) {
                                              favoriteItems.removeWhere((item) => item['name'] == product['name']);
                                            } else {
                                              favoriteItems.add(product);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${product['price']} ₸',
                                      style: const TextStyle(
                                        color: Color(0xFFA50044),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 34,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF004D98),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            final i = cartItems.indexWhere((item) => item['name'] == product['name']);
                                            if (i != -1) {
                                              cartItems[i]['quantity']++;
                                            } else {
                                              cartItems.add({...product, 'quantity': 1, 'isSelected': true, 'size': 'M'});
                                            }
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${product['name']} ${t['added']}'),
                                              duration: const Duration(seconds: 1),
                                              behavior: SnackBarBehavior.floating,
                                              backgroundColor: const Color(0xFF004D98),
                                            ),
                                          );
                                        },
                                        child: Text(t['add']!, style: const TextStyle(fontSize: 11)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: filteredProducts.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String categoryId, String label) {
    bool isSelected = _selectedCategory == categoryId;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = categoryId),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFA50044) : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.white : Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}