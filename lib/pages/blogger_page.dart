import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 博主推荐页
class BloggerPage extends StatefulWidget {
  const BloggerPage({super.key});
  @override
  State<BloggerPage> createState() => _BloggerPageState();
}

class _BloggerPageState extends State<BloggerPage> {
  String _selected = '全部';
  final _tags = ['全部', '极简风', '法式浪漫', '职场知性', '酷飒街头', '护肤'];

  static const _bloggers = [
    _BloggerItem(name: '苏苏的穿搭日记', fans: '52万', style: '极简风', platform: '小红书', avatar: '👩', desc: '极简主义穿搭分享，一衣多穿技巧'),
    _BloggerItem(name: 'Lily美妆分享', fans: '38万', style: '日常妆', platform: '抖音', avatar: '💄', desc: '日常淡妆教程，新手友好step by step'),
    _BloggerItem(name: '一衣多穿', fans: '67万', style: '通勤风', platform: '小红书', avatar: '👔', desc: '一件单品N种穿法，通勤穿搭不重样'),
    _BloggerItem(name: '小鹿的护肤笔记', fans: '45万', style: '护肤', platform: 'B站', avatar: '🧴', desc: '成分党护肤科普，科学护肤不踩雷'),
    _BloggerItem(name: '法式穿搭志', fans: '28万', style: '法式浪漫', platform: '小红书', avatar: '🇫🇷', desc: '法式慵懒风穿搭，碎花裙和贝雷帽'),
    _BloggerItem(name: '酷飒Alice', fans: '41万', style: '酷飒街头', platform: '抖音', avatar: '🖤', desc: '街头潮牌穿搭，OOTD每日更新'),
    _BloggerItem(name: '职场穿搭笔记', fans: '33万', style: '职场知性', platform: '小红书', avatar: '💼', desc: '职场得体穿搭，面试/通勤全攻略'),
  ];

  List<_BloggerItem> get _filtered => _selected == '全部'
      ? _bloggers
      : _bloggers.where((e) => e.style == _selected).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('博主推荐'),
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
            child: const Text('根据你的风格推荐同好博主', style: TextStyle(fontSize: 13, color: AppTheme.textHint)),
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
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final b = list[i];
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
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primary.withValues(alpha: 0.2), AppTheme.accent.withValues(alpha: 0.2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(b.avatar, style: const TextStyle(fontSize: 24)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Text('${b.fans}粉丝', style: const TextStyle(fontSize: 11, color: AppTheme.textMute)),
                              const SizedBox(width: 8),
                              Container(width: 1, height: 10, color: AppTheme.borderLight),
                              const SizedBox(width: 8),
                              Text(b.platform, style: const TextStyle(fontSize: 11, color: AppTheme.textMute)),
                            ]),
                            const SizedBox(height: 6),
                            Text(b.desc, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                        ),
                        child: const Text('关注', style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: (i * 60).ms);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _BloggerItem {
  final String name;
  final String fans;
  final String style;
  final String platform;
  final String avatar;
  final String desc;
  const _BloggerItem({required this.name, required this.fans, required this.style, required this.platform, required this.avatar, required this.desc});
}
