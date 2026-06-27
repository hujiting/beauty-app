import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 穿搭推荐页
class OutfitPage extends StatefulWidget {
  const OutfitPage({super.key});
  @override
  State<OutfitPage> createState() => _OutfitPageState();
}

class _OutfitPageState extends State<OutfitPage> {
  String _selected = '全部';
  final _tags = ['全部', '上衣', '下装', '外套', '连衣裙', '配饰'];

  static const _outfits = [
    _OutfitItem(title: '温柔针织开衫', category: '上衣', style: '法式浪漫', desc: '米白色针织开衫，柔软亲肤，适合早秋搭配', price: 299, originalPrice: 399),
    _OutfitItem(title: '高腰阔腿裤', category: '下装', style: '极简知性', desc: '垂感面料，拉长腿部线条，通勤百搭', price: 259, originalPrice: 359),
    _OutfitItem(title: '小香风外套', category: '外套', style: '优雅气质', desc: '粗花呢面料，精致剪裁，提升整体质感', price: 899, originalPrice: 1299),
    _OutfitItem(title: '碎花连衣裙', category: '连衣裙', style: '法式浪漫', desc: '轻盈雪纺面料，浪漫碎花图案，约会首选', price: 359, originalPrice: 499),
    _OutfitItem(title: '极简银项链', category: '配饰', style: '极简知性', desc: '简约几何吊坠，S925银材质，日常百搭', price: 168, originalPrice: 228),
    _OutfitItem(title: '真丝方巾', category: '配饰', style: '优雅气质', desc: '100%桑蚕丝，多色可选，点亮整体穿搭', price: 299, originalPrice: 399),
  ];

  List<_OutfitItem> get _filtered => _selected == '全部'
      ? _outfits
      : _outfits.where((e) => e.category == _selected).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('穿搭推荐'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: _tags.length,
              itemBuilder: (_, i) => CategoryPill(
                label: _tags[i],
                active: _tags[i] == _selected,
                onTap: () => setState(() => _selected = _tags[i]),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final item = list[i];
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppTheme.primary.withValues(alpha: 0.2), AppTheme.accent.withValues(alpha: 0.2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusM)),
                            ),
                            alignment: Alignment.center,
                            child: Text(item.title.substring(0, 1), style: const TextStyle(fontSize: 32, color: Colors.white70)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                              const SizedBox(height: 4),
                              Text(item.style, style: const TextStyle(fontSize: 11, color: AppTheme.primary)),
                              const SizedBox(height: 6),
                              Row(children: [
                                Text('¥${item.price}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.highlight)),
                                const SizedBox(width: 6),
                                Text('¥${item.originalPrice}', style: const TextStyle(fontSize: 11, color: AppTheme.textMute, decoration: TextDecoration.lineThrough)),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: (i * 60).ms),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _OutfitItem {
  final String title;
  final String category;
  final String style;
  final String desc;
  final int price;
  final int originalPrice;
  const _OutfitItem({required this.title, required this.category, required this.style, required this.desc, required this.price, required this.originalPrice});
}
