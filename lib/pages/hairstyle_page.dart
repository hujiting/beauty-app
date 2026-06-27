import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 发型推荐页
class HairstylePage extends StatefulWidget {
  const HairstylePage({super.key});
  @override
  State<HairstylePage> createState() => _HairstylePageState();
}

class _HairstylePageState extends State<HairstylePage> {
  String _selected = '全部';
  final _tags = ['全部', '短发', '中长发', '长发', '编发'];

  static const _hairstyles = [
    _HairItem(name: '一刀切短发', category: '短发', forFace: '圆脸/方脸', desc: '干净利落，突出下颌线条，适合职场女性', color: Color(0xFFD4A5A5)),
    _HairItem(name: '法式慵懒卷', category: '中长发', forFace: '鹅蛋脸/心形脸', desc: '自然大卷，浪漫慵懒，法式风格必备', color: Color(0xFFC9B99A)),
    _HairItem(name: '日系层次短发', category: '短发', forFace: '长脸/菱形脸', desc: '层次感强，修饰脸型，清新少年感', color: Color(0xFFB88A8A)),
    _HairItem(name: '韩系微卷长发', category: '长发', forFace: '所有脸型', desc: '温柔微卷，氛围感十足，约会首选', color: Color(0xFFE8D5D5)),
    _HairItem(name: '气质低盘发', category: '编发', forFace: '鹅蛋脸/方脸', desc: '优雅知性，适合正式场合和职场', color: Color(0xFFF0E6D6)),
    _HairItem(name: '潮酷烫发', category: '中长发', forFace: '圆脸/方脸', desc: '个性十足，街头潮流风的不二之选', color: Color(0xFF999999)),
  ];

  List<_HairItem> get _filtered => _selected == '全部'
      ? _hairstyles
      : _hairstyles.where((e) => e.category == _selected).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('发型推荐'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text('根据你的脸型和风格推荐', style: TextStyle(fontSize: 13, color: AppTheme.textHint)),
          ),
          const SizedBox(height: 12),
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
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final item = list[i];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [item.color.withValues(alpha: 0.3), item.color.withValues(alpha: 0.1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.content_cut, size: 28, color: Colors.white70),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                            const SizedBox(height: 4),
                            Text('适合脸型：${item.forFace}', style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
                            const SizedBox(height: 6),
                            Text(item.desc, maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.5)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppTheme.textMute, size: 20),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: (i * 80).ms).slideX(begin: 0.05, end: 0);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _HairItem {
  final String name;
  final String category;
  final String forFace;
  final String desc;
  final Color color;
  const _HairItem({required this.name, required this.category, required this.forFace, required this.desc, required this.color});
}
