import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/data_models.dart';
import '../models/ai_engine.dart';

/// 出片圣地 — 根据个人风格推荐拍摄地点
/// 含本地生活推荐（跳转大众点评/地图）
class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  String _selectedCity = '全部';
  String _selectedCategory = '全部';

  final _cities = ['全部', '上海', '北京', '广州', '深圳', '成都'];
  final _categories = ['全部', '街拍', '咖啡馆', '艺术展', '公园', '网红墙'];

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final userStyle = app.styleResult ?? '';
    final userCity = app.userCity;

    // 根据风格智能推荐
    final recommended = MatchingEngine.recommendSpots(
      styleTags: [userStyle],
      city: userCity,
    );

    // 过滤
    var filtered = mockSpots.where((s) {
      final cityOk = _selectedCity == '全部' || s.city == _selectedCity;
      final catOk = _selectedCategory == '全部' || s.category == _selectedCategory;
      return cityOk && catOk;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('出片圣地'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: CustomScrollView(
        slivers: [
          // 智能推荐banner
          if (recommended.isNotEmpty)
            SliverToBoxAdapter(child: _buildRecommendedBanner(context, recommended.first, userStyle)),
          // 城市筛选
          SliverToBoxAdapter(child: _buildCityFilter(context)),
          // 分类筛选
          SliverToBoxAdapter(child: _buildCategoryFilter(context)),
          // 地点列表
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _SpotCard(spot: filtered[i], isFav: app.isSpotFavorite(filtered[i].name))
                    .animate().fadeIn(duration: 300.ms, delay: (i * 50).ms).slideY(begin: 0.05, end: 0),
                childCount: filtered.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildRecommendedBanner(BuildContext context, PhotoSpot spot, String style) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.auto_awesome, size: 18, color: Colors.white),
          const SizedBox(width: 6),
          const Text('风格推荐', style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 8),
        Text('基于你的「$style」风格', style: const TextStyle(fontSize: 12, color: Colors.white70)),
        const SizedBox(height: 8),
        Text(spot.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text('${spot.city} · ${spot.category}', style: const TextStyle(fontSize: 13, color: Colors.white70)),
        const SizedBox(height: 8),
        Text(spot.description, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.9), height: 1.5)),
      ]),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.98, 0.98), end: const Offset(1, 1));
  }

  Widget _buildCityFilter(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _cities.length,
        itemBuilder: (_, i) {
          final selected = _selectedCity == _cities[i];
          return GestureDetector(
            onTap: () => setState(() => _selectedCity = _cities[i]),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: selected ? AppTheme.primary : AppTheme.borderLight),
              ),
              child: Text(_cities[i], style: TextStyle(fontSize: 13, color: selected ? Colors.white : AppTheme.textSecondary, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: _categories.map((cat) {
          final selected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? AppTheme.accent.withValues(alpha: 0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: selected ? AppTheme.accent : AppTheme.borderLight),
              ),
              child: Text(cat, style: TextStyle(fontSize: 12, color: selected ? AppTheme.accent : AppTheme.textHint)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SpotCard extends StatelessWidget {
  final PhotoSpot spot;
  final bool isFav;
  const _SpotCard({required this.spot, required this.isFav});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // 图片占位
        Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primary.withValues(alpha: 0.15), AppTheme.accent.withValues(alpha: 0.1)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Stack(children: [
            const Center(child: Icon(Icons.photo_camera, size: 40, color: AppTheme.textMute)),
            Positioned(top: 10, right: 10, child: GestureDetector(
              onTap: () => app.toggleSpotFavorite(spot.name),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
                child: Icon(isFav ? Icons.favorite : Icons.favorite_border, size: 16, color: isFav ? Colors.red : AppTheme.textMute),
              ),
            )),
            Positioned(top: 10, left: 10, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(6)),
              child: Text(spot.category, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w500)),
            )),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(spot.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary))),
              const Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 2),
              Text(spot.rating.toString(), style: const TextStyle(fontSize: 13, color: Colors.amber, fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textHint),
              const SizedBox(width: 4),
              Expanded(child: Text(spot.address, style: const TextStyle(fontSize: 12, color: AppTheme.textHint), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 8),
            Text(spot.description, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5)),
            const SizedBox(height: 8),
            Row(children: [
              ...spot.suitableStyles.map((s) => Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(4)),
                child: Text(s, style: const TextStyle(fontSize: 10, color: AppTheme.primary)),
              )),
              const Spacer(),
              Text('热度 ${spot.heat}', style: const TextStyle(fontSize: 11, color: AppTheme.textMute)),
            ]),
          ]),
        ),
      ]),
    );
  }
}
