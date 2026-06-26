import 'package:flutter/material.dart';
import '../data.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String _selectedCat = '全部';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['全部', '配饰', '包袋', '发饰', '美甲', '首饰', '帽子'];

  List<Product> get _filtered {
    if (_selectedCat == '全部') return products;
    return products.where((p) => p.category == _selectedCat).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F3),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(Icons.search, size: 20, color: Color(0xFF999999)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: '搜索好物',
                          hintStyle: TextStyle(fontSize: 14, color: Color(0xFFBBBBBB)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Category pills
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  final active = cat == _selectedCat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCat = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: active ? null : Border.all(color: const Color(0xFFE8E8E4)),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 13,
                          color: active ? Colors.white : const Color(0xFF666666),
                          fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Products grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.68,
                ),
                itemCount: _filtered.length,
                itemBuilder: (context, i) => _buildProductCard(_filtered[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const Map<String, List<Color>> _catGradients = {
    '包袋': [Color(0xFFE8D5D5), Color(0xFFD4A5A5)],
    '配饰': [Color(0xFFF0E6D6), Color(0xFFC9B99A)],
    '发饰': [Color(0xFFD4A5A5), Color(0xFFB88A8A)],
    '美甲': [Color(0xFFE8D5D5), Color(0xFFF0E6D6)],
    '首饰': [Color(0xFFC9B99A), Color(0xFFB88A8A)],
    '帽子': [Color(0xFFB88A8A), Color(0xFFD4A5A5)],
  };

  Widget _buildProductCard(Product p) {
    final gradient = _catGradients[p.category] ?? [const Color(0xFFE8D5D5), const Color(0xFFC9B99A)];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient top
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(p.category, style: const TextStyle(fontSize: 10, color: Color(0xFF666666))),
                ),
              ),
            ],
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF222222))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('¥${p.price}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFC46B8A))),
                    const SizedBox(width: 6),
                    if (p.originalPrice > p.price)
                      Text(
                        '¥${p.originalPrice}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFFBBBBBB), decoration: TextDecoration.lineThrough),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
