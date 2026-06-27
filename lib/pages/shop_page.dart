import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../data.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String _selectedCat = '全部';
  final _searchController = TextEditingController();

  final _categories = ['全部', '配饰', '包袋', '发饰', '美甲', '首饰', '帽子'];

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

            // 搜索栏 - 点击跳转搜索页或展开搜索
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F3),
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, size: 20, color: AppTheme.textHint),
                      SizedBox(width: 8),
                      Text('搜索好物',
                          style: TextStyle(
                              fontSize: 14, color: AppTheme.textMute)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 分类胶囊
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: _categories.length,
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  return CategoryPill(
                    label: cat,
                    active: cat == _selectedCat,
                    onTap: () => setState(() => _selectedCat = cat),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 商品网格
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
                itemBuilder: (context, i) =>
                    _ProductCard(product: _filtered[i], index: i),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final int index;

  const _ProductCard({required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final gradient = AppTheme.catGradients[product.category] ??
        [AppTheme.primary, AppTheme.accent];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: const Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 渐变顶部
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
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppTheme.radiusM)),
                ),
                alignment: Alignment.center,
                child: Text(
                  product.name.substring(0, 1),
                  style: const TextStyle(
                      fontSize: 40, color: Colors.white70),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Text(product.category,
                      style: const TextStyle(
                          fontSize: 10, color: AppTheme.textSecondary)),
                ),
              ),
            ],
          ),

          // 信息区
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('¥${product.price}',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.highlight)),
                    const SizedBox(width: 6),
                    if (product.originalPrice > product.price)
                      Text(
                        '¥${product.originalPrice}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textMute,
                            decoration: TextDecoration.lineThrough),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms).scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1.0, 1.0),
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }
}
