import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../data.dart';
import 'makeup_page.dart';
import 'capture_page.dart';
import 'style_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// 风格卡片数据模型
class _StyleItem {
  final String name;
  final int count;
  const _StyleItem({required this.name, required this.count});
}

// 探索风格列表数据
const List<_StyleItem> _styles = [
  _StyleItem(name: '温柔风', count: 128),
  _StyleItem(name: '职场范', count: 96),
  _StyleItem(name: '复古感', count: 73),
  _StyleItem(name: '街头潮', count: 54),
  _StyleItem(name: '极简主义', count: 89),
  _StyleItem(name: '法式浪漫', count: 67),
];

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final show = _scrollController.offset > 80;
      if (show != _showTitle) setState(() => _showTitle = show);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              elevation: _showTitle ? 1 : 0,
              title: _showTitle
                  ? const Text('钥纪',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary))
                  : null,
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: AppTheme.textPrimary),
                  onPressed: () {},
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('早上好 ☀️',
                        style: TextStyle(
                            fontSize: 14, color: AppTheme.textHint)),
                    const SizedBox(height: 4),
                    const Text('今天想尝试什么风格？',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary)),
                    const SizedBox(height: 20),
                    _SearchBar(),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: _FeatureGrid()),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                child: const SectionHeader(title: '今日推荐', subtitle: '为你精选'),
              ),
            ),

            SliverToBoxAdapter(child: _RecommendList()),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                child: const SectionHeader(title: '探索风格'),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _StyleCard(style: _styles[i]),
                  childCount: _styles.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

// 搜索栏
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/shop'),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F3),
          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, size: 20, color: AppTheme.textHint),
            SizedBox(width: 8),
            Text('搜索风格、好物...',
                style: TextStyle(fontSize: 14, color: AppTheme.textMute)),
          ],
        ),
      ),
    );
  }
}

// 功能入口网格
class _FeatureGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatureItem(
        icon: Icons.brush_outlined,
        label: '智能上妆',
        color: AppTheme.primary,
        onTap: () => context.go('/makeup'),
      ),
      _FeatureItem(
        icon: Icons.camera_alt_outlined,
        label: '拍照圣地',
        color: AppTheme.accent,
        onTap: () => context.go('/capture'),
      ),
      _FeatureItem(
        icon: Icons.auto_awesome_outlined,
        label: '风格诊断',
        color: const Color(0xFFB88A8A),
        onTap: () => context.go('/style'),
      ),
      _FeatureItem(
        icon: Icons.store_outlined,
        label: '好物商城',
        color: AppTheme.highlight,
        onTap: () => context.go('/shop'),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: features
          .map((f) => f.animate().scale(
                duration: 300.ms,
                delay: (features.indexOf(f) * 80).ms,
                curve: Curves.easeOut,
              ))
          .toList(),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

// 推荐商品横向列表
class _RecommendList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recs = products.take(6).toList();
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: recs.length,
        itemBuilder: (context, i) {
          final p = recs[i];
          final gradient = AppTheme.catGradients[p.category] ??
              [AppTheme.primary, AppTheme.accent];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppTheme.radiusM)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      p.name.substring(0, 1),
                      style: const TextStyle(
                          fontSize: 32, color: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('¥${p.price}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.highlight)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: (i * 60).ms),
          );
        },
      ),
    );
  }
}

// 风格卡片
class _StyleCard extends StatelessWidget {
  final _StyleItem style;
  const _StyleCard({required this.style});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/style'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          boxShadow: AppTheme.cardShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary.withValues(alpha: 0.3),
                      AppTheme.accent.withValues(alpha: 0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  style.name.substring(0, 1),
                  style: const TextStyle(fontSize: 48, color: Colors.white70),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(style.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('${style.count} 套搭配',
                          style: const TextStyle(
                              fontSize: 11, color: AppTheme.textHint)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms).scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.0, 1.0),
            duration: 300.ms,
            curve: Curves.easeOut,
          ),
    );
  }
}
