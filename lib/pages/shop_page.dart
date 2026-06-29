import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/data_models.dart';
import '../models/ai_engine.dart';

/// 模块四：【变美商城】
/// - 精准导购：只推适合你尺码、风格、肤色的商品
/// - 整套购买：一键买齐整套搭配
/// - 本地生活：推荐附近拍照打卡点
class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('变美商城'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textMute,
          indicatorColor: AppTheme.primary,
          tabs: const [
            Tab(text: '为你推荐'),
            Tab(text: '整套搭配'),
            Tab(text: '本地生活'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RecommendTab(),
          _OutfitShopTab(),
          _LocalLifeTab(),
        ],
      ),
    );
  }
}

// ==================== 精准导购 ====================
class _RecommendTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    // 基于用户肤质过滤护肤品
    final skincare = MatchingEngine.filterSkincareProducts(profile: app.skinHairProfile);
    // 基于风格过滤服饰
    final styleTags = app.stylePreference.styleTags.isNotEmpty
        ? app.stylePreference.styleTags
        : [app.styleResult ?? ''];
    final fashion = mockProducts.where((p) =>
      p.category != '护肤' &&
      (p.suitableStyles.isEmpty || p.suitableStyles.any((s) => styleTags.any((t) => s.contains(t))))
    ).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 精准推荐banner
        Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.primary.withValues(alpha: 0.08), AppTheme.accent.withValues(alpha: 0.05)]),
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
          ),
          child: Row(children: [
            const Icon(Icons.recommend, size: 24, color: AppTheme.primary),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('精准推荐', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
              Text('基于${app.skinHairProfile.skinType ?? "混合"}肌 · ${app.styleResult ?? "法式浪漫"}风格',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
            ])),
          ]),
        ).animate().fadeIn(duration: 400.ms),

        // 护肤区
        if (skincare.isNotEmpty) ...[
          const Text('护肤推荐', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          ...skincare.map((p) => _ProductCard(product: p, isFav: app.isFavorite(p.id))
              .animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0)),
        ],
        const SizedBox(height: 16),
        // 服饰区
        if (fashion.isNotEmpty) ...[
          const Text('服饰推荐', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          ...fashion.map((p) => _ProductCard(product: p, isFav: app.isFavorite(p.id))
              .animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0)),
        ],
      ],
    );
  }
}

// ==================== 整套搭配 ====================
class _OutfitShopTab extends StatelessWidget {
  final _outfits = const [
    {
      'name': '法式优雅套装',
      'items': '丝质衬衫 + 高腰阔腿裤 + 珍珠耳环',
      'price': 1097, 'originalPrice': 1397,
      'color': Color(0xFFE8B4B8),
      'tag': '法式浪漫',
    },
    {
      'name': '极简职场套装',
      'items': '白衬衫 + 黑色西装裤 + 银色耳钉',
      'price': 858, 'originalPrice': 998,
      'color': Color(0xFFB4C8E8),
      'tag': '极简知性',
    },
    {
      'name': '街头潮流套装',
      'items': '卫衣 + 牛仔裤 + 棒球帽 + 板鞋',
      'price': 1288, 'originalPrice': 1488,
      'color': Color(0xFFB8E8C4),
      'tag': '街头潮流',
    },
    {
      'name': '甜美约会套装',
      'items': '碎花连衣裙 + 裸色高跟鞋 + 手链',
      'price': 998, 'originalPrice': 1198,
      'color': Color(0xFFE8D4B4),
      'tag': '甜美可爱',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('一键买齐模特身上这一套', style: TextStyle(fontSize: 13, color: AppTheme.textHint)),
        const SizedBox(height: 12),
        ..._outfits.map((o) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [(o['color'] as Color).withValues(alpha: 0.2), (o['color'] as Color).withValues(alpha: 0.05)],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(child: Icon(Icons.checkroom, size: 40, color: o['color'] as Color)),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(o['name'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: (o['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                    child: Text(o['tag'] as String, style: TextStyle(fontSize: 10, color: o['color'] as Color)),
                  ),
                ]),
                const SizedBox(height: 4),
                Text(o['items'] as String, style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
                const SizedBox(height: 10),
                Row(children: [
                  Text('¥${o['price']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                  const SizedBox(width: 6),
                  Text('¥${o['originalPrice']}', style: const TextStyle(fontSize: 13, color: AppTheme.textMute, decoration: TextDecoration.lineThrough)),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white, minimumSize: const Size(80, 36)),
                    child: const Text('一键购买', style: TextStyle(fontSize: 12)),
                  ),
                ]),
              ]),
            ),
          ]),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0)),
      ],
    );
  }
}

// ==================== 本地生活 ====================
class _LocalLifeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final spots = MatchingEngine.recommendSpots(
      styleTags: [app.styleResult ?? ''],
      city: app.userCity,
    );
    final display = spots.isEmpty ? mockSpots.take(4).toList() : spots.take(6).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(children: [
          const Icon(Icons.location_on, size: 18, color: AppTheme.primary),
          const SizedBox(width: 6),
          Text('${app.userCity} · 附近拍照好去处', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        ]),
        const SizedBox(height: 4),
        const Text('点击查看详情，可跳转大众点评/地图', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
        const SizedBox(height: 12),
        ...display.map((s) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.photo_camera, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(s.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                const SizedBox(width: 6),
                const Icon(Icons.star, size: 12, color: Colors.amber),
                Text(s.rating.toString(), style: const TextStyle(fontSize: 12, color: Colors.amber)),
              ]),
              const SizedBox(height: 2),
              Text(s.address, style: const TextStyle(fontSize: 12, color: AppTheme.textHint), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(children: s.suitableStyles.take(2).map((st) => Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(3)),
                child: Text(st, style: const TextStyle(fontSize: 10, color: AppTheme.accent)),
              )).toList()),
            ])),
            const Icon(Icons.chevron_right, color: AppTheme.textMute),
          ]),
        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0)),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final bool isFav;
  const _ProductCard({required this.product, required this.isFav});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            product.category == '护肤' ? Icons.spa : product.category == '彩妆' ? Icons.brush : Icons.checkroom,
            color: AppTheme.primary, size: 28,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          const SizedBox(height: 2),
          Text('${product.brand} · ${product.category}', style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
          const SizedBox(height: 4),
          if (product.suitableSkinTypes.isNotEmpty)
            Wrap(spacing: 4, children: product.suitableSkinTypes.take(3).map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(3)),
              child: Text('${s}肌', style: const TextStyle(fontSize: 10, color: Colors.green)),
            )).toList()),
          if (product.suitableStyles.isNotEmpty)
            Wrap(spacing: 4, children: product.suitableStyles.take(2).map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(3)),
              child: Text(s, style: const TextStyle(fontSize: 10, color: AppTheme.accent)),
            )).toList()),
          const SizedBox(height: 6),
          Row(children: [
            Text('¥${product.price}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary)),
            if (product.originalPrice != null) ...[
              const SizedBox(width: 4),
              Text('¥${product.originalPrice}', style: const TextStyle(fontSize: 12, color: AppTheme.textMute, decoration: TextDecoration.lineThrough)),
            ],
            const SizedBox(width: 8),
            Text('已售${product.sales}', style: const TextStyle(fontSize: 11, color: AppTheme.textMute)),
          ]),
        ])),
        Column(children: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, size: 20, color: isFav ? Colors.red : AppTheme.textMute),
            onPressed: () => app.toggleFavorite(product.id),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white, minimumSize: const Size(56, 28), padding: EdgeInsets.zero),
            child: const Text('购买', style: TextStyle(fontSize: 12)),
          ),
        ]),
      ]),
    );
  }
}
