import 'package:flutter/material.dart';
import '../data.dart';
import 'capture_page.dart';
import 'wellness_page.dart';

// ---------------------------------------------------------------------------
// Helper Widgets
// ---------------------------------------------------------------------------

class _GradientBox extends StatelessWidget {
  final Color color1;
  final Color color2;
  final Widget? child;
  final double borderRadius;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const _GradientBox({
    required this.color1,
    required this.color2,
    this.child,
    this.borderRadius = 16,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: [color1, color2],
        ),
      ),
      child: child,
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const _Card({
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// HomePage
// ---------------------------------------------------------------------------

class HomePage extends StatelessWidget {
  final void Function(int)? onTabChange;
  const HomePage({super.key, this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ---- App Bar with Search ----
            SliverToBoxAdapter(child: _buildSearchBar(context)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  _buildInspirationCard(context),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  _buildHotTopicsSection(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('为你精选'),
                  const SizedBox(height: 12),
                ]),
              ),
            ),

            // ---- Inspiration Feed ----
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildInspirationItem(
                    context,
                    inspirations[index],
                  ),
                  childCount: inspirations.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Search Bar
  // ---------------------------------------------------------------------------

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F0),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(
                    Icons.search,
                    color: Color(0xFF999999),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '搜索妆容、穿搭、博主...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF999999),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Camera circle button (gradient pink→gold)
          _GradientBox(
            color1: pink,
            color2: gold,
            borderRadius: 22,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 今日变美灵感 Card
  // ---------------------------------------------------------------------------

  Widget _buildInspirationCard(BuildContext context) {
    return _GradientBox(
      color1: const Color(0xFF1A1A1A),
      color2: const Color(0xFF2A2A2A),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section label with gold sun icon
            Row(
              children: [
                Icon(
                  Icons.wb_sunny,
                  color: gold,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  '今日变美灵感',
                  style: TextStyle(
                    color: gold,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Quote text
            const Text(
              '真正的美不是模仿别人，而是找到最适合自己的样子。',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 16),
            // Tag chips
            Wrap(
              spacing: 8,
              children: [
                _buildTagChip('#自我风格'),
                _buildTagChip('#Beauty主义'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 12,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Quick Action Buttons
  // ---------------------------------------------------------------------------

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          context,
          icon: Icons.auto_awesome,
          label: 'AI妆容分析',
          onTap: () {
            onTabChange?.call(1);
          },
        ),
        _buildActionButton(
          context,
          icon: Icons.checkroom,
          label: '风格测试',
          onTap: () {
            onTabChange?.call(2);
          },
        ),
        _buildActionButton(
          context,
          icon: Icons.camera_alt,
          label: '出片模板',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CapturePage()),
            );
          },
        ),
        _buildActionButton(
          context,
          icon: Icons.favorite,
          label: '健康知识',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const WellnessPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF333333)),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 热门话题 Horizontal Scroll
  // ---------------------------------------------------------------------------

  Widget _buildHotTopicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('热门话题'),
        const SizedBox(height: 12),
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildTopicTag('#秋季穿搭'),
              _buildTopicTag('#淡妆教程'),
              _buildTopicTag('#极简风'),
              _buildTopicTag('#身材管理'),
              _buildTopicTag('#拍照姿势'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopicTag(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: softPink,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 13, color: pinkDark),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section Header Helper
  // ---------------------------------------------------------------------------

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const Icon(
          Icons.chevron_right,
          color: Color(0xFF999999),
          size: 20,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 为你精选 — Inspiration Item Card
  // ---------------------------------------------------------------------------

  Widget _buildInspirationItem(BuildContext context, Inspiration item) {
    return _Card(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Left: gradient thumbnail with play icon
          _GradientBox(
            color1: pink,
            color2: gold,
            borderRadius: 12,
            child: SizedBox(
              width: 120,
              height: 100,
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Right: title, tag, reads count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: softPink,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.category,
                    style: TextStyle(fontSize: 11, color: pinkDark),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.visibility_outlined,
                      size: 14,
                      color: Color(0xFF999999),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.views,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
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

  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
