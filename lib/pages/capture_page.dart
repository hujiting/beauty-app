import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/common.dart';

/// 出片圣地 — 根据个人风格推荐拍照场地（无拍照功能）
class CapturePage extends StatefulWidget {
  const CapturePage({super.key});
  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  String _selectedCity = '全部';
  final List<String> _cities = ['全部', '上海', '杭州', '成都', '厦门', '北京', '深圳'];

  static const _spots = [
    _Spot(
      city: '上海',
      name: '武康路法式街区',
      style: '法式浪漫',
      desc: '梧桐树下，复古建筑，充满法式慵懒感',
      tags: ['法式', '复古', '街拍'],
    ),
    _Spot(
      city: '杭州',
      name: '西湖断桥残雪',
      style: '清冷文艺',
      desc: '湖光山色，适合清冷风格的出片圣地',
      tags: ['文艺', '清新', '自然'],
    ),
    _Spot(
      city: '成都',
      name: '太古里潮流街区',
      desc: '时尚潮流地标，酷飒街头风首选',
      style: '酷飒街头',
      tags: ['街头', '时尚', '潮牌'],
    ),
    _Spot(
      city: '厦门',
      name: '沙坡尾艺术西区',
      style: '清新文艺',
      desc: '海边艺术区，清新文艺风的天堂',
      tags: ['文艺', '清新', '海边'],
    ),
    _Spot(
      city: '北京',
      name: '胡同文艺小巷',
      style: '极简知性',
      desc: '灰砖青瓦，极简知性风的完美背景',
      tags: ['极简', '知性', '人文'],
    ),
    _Spot(
      city: '深圳',
      name: '华侨城创意园',
      style: '职场知性',
      desc: '现代艺术园区，适合职场风、知性风拍摄',
      tags: ['职场', '知性', '现代'],
    ),
  ];

  List<_Spot> get _filteredSpots {
    if (_selectedCity == '全部') return _spots;
    return _spots.where((s) => s.city == _selectedCity).toList();
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final style = app.styleResult ?? '';
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('出片圣地'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 风格提示
          if (style.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Row(children: [
                const Icon(Icons.auto_awesome, size: 18, color: AppTheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('根据你的风格「$style」推荐以下场地',
                      style: const TextStyle(fontSize: 13, color: AppTheme.primary)),
                ),
              ]),
            ),
          const SizedBox(height: 16),
          // 城市筛选
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _cities.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final city = _cities[i];
                final active = city == _selectedCity;
                return CategoryPill(
                  label: city,
                  active: active,
                  onTap: () => setState(() => _selectedCity = city),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // 圣地列表
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: _filteredSpots.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) {
                final spot = _filteredSpots[i];
                final matched = style.isNotEmpty && spot.style.contains(style.substring(0, 2));
                return _SpotCard(spot: spot, matched: matched)
                    .animate()
                    .fadeIn(duration: 300.ms, delay: (i * 80).ms)
                    .slideY(begin: 0.05, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Spot {
  final String city;
  final String name;
  final String style;
  final String desc;
  final List<String> tags;
  const _Spot({required this.city, required this.name, required this.style, required this.desc, required this.tags});
}

class _SpotCard extends StatelessWidget {
  final _Spot spot;
  final bool matched;
  const _SpotCard({required this.spot, required this.matched});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: matched ? Border.all(color: AppTheme.primary.withValues(alpha: 0.4)) : null,
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 渐变顶部
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: matched
                      ? [AppTheme.primary.withValues(alpha: 0.3), AppTheme.accent.withValues(alpha: 0.3)]
                      : [AppTheme.accent.withValues(alpha: 0.2), AppTheme.highlight.withValues(alpha: 0.2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusM)),
              ),
              alignment: Alignment.center,
              child: Icon(
                matched ? Icons.favorite : Icons.place_outlined,
                size: 36,
                color: matched ? AppTheme.primary : AppTheme.textMute,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(spot.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    ),
                    if (matched)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('风格匹配', style: TextStyle(fontSize: 10, color: AppTheme.primary)),
                      ),
                  ]),
                  const SizedBox(height: 6),
                  Text(spot.city,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
                  const SizedBox(height: 8),
                  Text(spot.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: spot.tags
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.bgGray,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(tag, style: const TextStyle(fontSize: 11, color: AppTheme.textMute)),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
