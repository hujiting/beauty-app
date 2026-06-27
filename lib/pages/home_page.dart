import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/common.dart';

/// 私人变美管家 — 首页仪表盘
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final show = _scrollController.offset > 60;
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
    final app = Provider.of<AppState>(context);
    final isFemale = app.isFemale;
    final style = app.styleResult ?? '待诊断';

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // ===== 顶部导航栏 =====
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              elevation: _showTitle ? 1 : 0,
              title: _showTitle
                  ? Text(app.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary))
                  : null,
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary),
                  onPressed: () {},
                ),
              ],
            ),

            SliverToBoxAdapter(child: _HeaderSection(isFemale: isFemale, style: style)),
            SliverToBoxAdapter(child: _SkincareSection()),
            SliverToBoxAdapter(child: _QuickActions(isFemale: isFemale)),
            SliverToBoxAdapter(child: _StyleSection(style: style, isFemale: isFemale)),
            SliverToBoxAdapter(child: _BloggerSection(isFemale: isFemale)),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

// ===== 欢迎头部 =====
class _HeaderSection extends StatelessWidget {
  final bool isFemale;
  final String style;
  const _HeaderSection({required this.isFemale, required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.accent]), borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isFemale ? '早上好，变美小主 ☀️' : '早上好，型男 ✨',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 4),
            Text('你的风格：$style', style: const TextStyle(fontSize: 13, color: AppTheme.textHint)),
          ]),
        ),
      ]),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0);
  }
}

// ===== 今日护肤打卡 =====
class _SkincareSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final steps = app.skincareSteps;
    final today = app.skincareToday;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 4, height: 18, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          const Text('今日护肤', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const Spacer(),
          Text('${today.values.where((v) => v).length}/${steps.length} 已完成',
              style: const TextStyle(fontSize: 12, color: AppTheme.textMute)),
        ]),
        const SizedBox(height: 14),
        Row(children: steps.map((step) {
          final done = today[step] ?? false;
          return Expanded(
            child: GestureDetector(
              onTap: () => app.toggleSkincareStep(step),
              child: Column(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: done ? AppTheme.primary.withValues(alpha: 0.12) : AppTheme.bgGray,
                    borderRadius: BorderRadius.circular(12),
                    border: done ? Border.all(color: AppTheme.primary.withValues(alpha: 0.4)) : null,
                  ),
                  child: Icon(
                    done ? Icons.check_circle : Icons.circle_outlined,
                    size: 22,
                    color: done ? AppTheme.primary : AppTheme.textMute,
                  ),
                ),
                const SizedBox(height: 6),
                Text(step, style: TextStyle(fontSize: 11, color: done ? AppTheme.primary : AppTheme.textHint)),
              ]),
            ),
          );
        }).toList()),
      ]),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }
}

// ===== 快捷功能入口 =====
class _QuickActions extends StatelessWidget {
  final bool isFemale;
  const _QuickActions({required this.isFemale});

  @override
  Widget build(BuildContext context) {
    final items = isFemale
        ? [
            _QuickItem(icon: Icons.face_retouching_natural, label: '妆容分析', color: AppTheme.primary, route: '/makeup'),
            _QuickItem(icon: Icons.science_outlined, label: '肤质分析', color: AppTheme.accent, route: '/makeup/skin'),
            _QuickItem(icon: Icons.content_cut_outlined, label: '发质分析', color: const Color(0xFFB88A8A), route: '/makeup/hair'),
            _QuickItem(icon: Icons.checkroom_outlined, label: '穿搭推荐', color: AppTheme.highlight, route: '/outfit'),
          ]
        : [
            _QuickItem(icon: Icons.face_retouching_natural, label: '妆容分析', color: AppTheme.primary, route: '/makeup'),
            _QuickItem(icon: Icons.science_outlined, label: '肤质分析', color: AppTheme.accent, route: '/makeup/skin'),
            _QuickItem(icon: Icons.content_cut_outlined, label: '发质分析', color: const Color(0xFFB88A8A), route: '/makeup/hair'),
            _QuickItem(icon: Icons.cut_outlined, label: '发型推荐', color: AppTheme.highlight, route: '/hairstyle'),
          ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 4, height: 18, decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          const Text('变美工具', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        ]),
        const SizedBox(height: 14),
        Row(children: items.map((item) {
          return Expanded(
            child: GestureDetector(
              onTap: () => context.go(item.route),
              child: Column(children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(color: item.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                  child: Icon(item.icon, color: item.color, size: 26),
                ),
                const SizedBox(height: 8),
                Text(item.label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ]),
            ),
          ).animate().scale(delay: (items.indexOf(item) * 80).ms, duration: 300.ms, curve: Curves.easeOut);
        }).toList()),
      ]),
    );
  }
}

class _QuickItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  const _QuickItem({required this.icon, required this.label, required this.color, required this.route});
}

// ===== 我的风格 =====
class _StyleSection extends StatelessWidget {
  final String style;
  final bool isFemale;
  const _StyleSection({required this.style, required this.isFemale});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 4, height: 18, decoration: BoxDecoration(color: AppTheme.highlight, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          const Text('我的风格', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const Spacer(),
          TextButton(onPressed: () => context.go('/style'), child: const Text('重新诊断', style: TextStyle(fontSize: 13))),
        ]),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () => context.go('/capture'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primary.withValues(alpha: 0.08), AppTheme.accent.withValues(alpha: 0.08)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
            ),
            child: Row(children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: const Icon(Icons.auto_awesome, color: AppTheme.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(style, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(isFemale ? '根据风格推荐出片圣地、饰品和博主' : '根据风格推荐出片圣地、配饰和穿搭博主',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
              ])),
              const Icon(Icons.chevron_right, color: AppTheme.textMute),
            ]),
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
      ]),
    );
  }
}

// ===== 推荐博主 =====
class _BloggerSection extends StatelessWidget {
  final bool isFemale;
  const _BloggerSection({required this.isFemale});

  static const _bloggers = [
    (name: '苏苏的穿搭日记', fans: '52万', tag: '极简风'),
    (name: 'Lily美妆分享', fans: '38万', tag: '日常妆'),
    (name: '一衣多穿', fans: '67万', tag: '通勤风'),
  ];

  static const _maleBloggers = [
    (name: '型男日记', fans: '45万', tag: '简约干净'),
    (name: '男士理容指南', fans: '32万', tag: '精致护肤'),
    (name: '日系穿搭志', fans: '28万', tag: '慵懒风'),
  ];

  @override
  Widget build(BuildContext context) {
    final list = isFemale ? _bloggers : _maleBloggers;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 4, height: 18, decoration: BoxDecoration(color: const Color(0xFFB88A8A), borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(isFemale ? '推荐博主' : '型男推荐', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const Spacer(),
          TextButton(onPressed: () => context.go('/bloggers'), child: const Text('查看更多', style: TextStyle(fontSize: 13))),
        ]),
        const SizedBox(height: 14),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) {
              final b = list[i];
              return GestureDetector(
                onTap: () => context.go('/bloggers'),
                child: Container(
                  width: 140,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppTheme.radiusM), boxShadow: AppTheme.cardShadow),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(width: 36, height: 36, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.12), shape: BoxShape.circle),
                        child: const Icon(Icons.person, size: 20, color: AppTheme.primary)),
                      const Spacer(),
                      Icon(Icons.add_circle_outline, size: 18, color: AppTheme.textMute),
                    ]),
                    const Spacer(),
                    Text(b.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Text(b.fans, style: const TextStyle(fontSize: 11, color: AppTheme.textMute)),
                      const SizedBox(width: 8),
                      Container(height: 10, width: 1, color: AppTheme.borderLight),
                      const SizedBox(width: 8),
                      Text(b.tag, style: const TextStyle(fontSize: 11, color: AppTheme.primary)),
                    ]),
                  ]),
                ).animate().fadeIn(delay: (i * 80).ms, duration: 300.ms),
              );
            },
          ),
        ),
      ]),
    );
  }
}
