import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/data_models.dart';

/// 模块二：【妆造实验室】
/// - 妆容模拟（AR试妆框架）
/// - 发型模拟器
/// - 教程定制（针对个人特征）
class BeautyLabPage extends StatelessWidget {
  const BeautyLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildTools(context, app)),
            SliverToBoxAdapter(child: _buildTutorials(context, app)),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('妆造实验室', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          const Text('定制属于你的妆容与造型', style: TextStyle(fontSize: 14, color: AppTheme.textHint)),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTools(BuildContext context, AppState app) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('智能工具', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _ToolCard(
              icon: Icons.face_retouching_natural,
              title: 'AR试妆',
              subtitle: '口红/眼影试色',
              color: const Color(0xFFE8B4B8),
              onTap: () => _showARTryOn(context, app),
            )),
            const SizedBox(width: 12),
            Expanded(child: _ToolCard(
              icon: Icons.cut,
              title: '发型模拟',
              subtitle: '一键换发型',
              color: const Color(0xFFB4C8E8),
              onTap: () => _showHairstyleSimulator(context, app),
            )),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _ToolCard(
              icon: Icons.palette_outlined,
              title: '色彩季型',
              subtitle: '测试适合的色彩',
              color: const Color(0xFFE8D4B4),
              onTap: () => context.push('/style'),
            )),
            const SizedBox(width: 12),
            Expanded(child: _ToolCard(
              icon: Icons.face,
              title: 'AI测脸',
              subtitle: '分析骨相皮相',
              color: const Color(0xFFB8E8C4),
              onTap: () => context.push('/style'),
            )),
          ]),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
  }

  Widget _buildTutorials(BuildContext context, AppState app) {
    final faceShape = app.faceProfile.faceShape ?? '鹅蛋脸';
    final eyeShape = app.faceProfile.eyeShape ?? '双眼皮';
    final bodyShape = app.bodyProfile.bodyShape;

    final tutorials = <_Tutorial>[
      _Tutorial(
        title: '${faceShape}专属妆容教程',
        desc: '针对${faceShape}的修容和提亮技巧',
        icon: Icons.brush,
        color: const Color(0xFFE8B4B8),
        tag: '妆容',
      ),
      if (eyeShape == '肿泡眼')
        _Tutorial(
          title: '肿泡眼消肿眼妆教程',
          desc: '通过大地色系打造深邃眼窝',
          icon: Icons.visibility,
          color: const Color(0xFFB4C8E8),
          tag: '眼妆',
        ),
      _Tutorial(
        title: '${bodyShape}显瘦穿搭教程',
        desc: '根据${bodyShape}身材特点的穿搭公式',
        icon: Icons.checkroom,
        color: const Color(0xFFB8E8C4),
        tag: '穿搭',
      ),
      _Tutorial(
        title: '${app.skinHairProfile.skincareFocus}护肤教程',
        desc: '针对${app.skinHairProfile.skinType ?? "混合"}肌的护肤步骤',
        icon: Icons.spa,
        color: const Color(0xFFE8D4B4),
        tag: '护肤',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('定制教程', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(width: 8),
            const Text('基于你的面部特征', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
          ]),
          const SizedBox(height: 12),
          ...tutorials.map((t) => _TutorialCard(tutorial: t)
              .animate().fadeIn(duration: 400.ms, delay: (tutorials.indexOf(t) * 80).ms).slideY(begin: 0.05, end: 0)),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }

  void _showARTryOn(BuildContext context, AppState app) {
    if (!app.vipLevel.canUseAITryOn) {
      _showVipDialog(context, 'AR试妆');
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _ARTryOnSheet(),
    );
  }

  void _showHairstyleSimulator(BuildContext context, AppState app) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _HairstyleSimSheet(),
    );
  }

  void _showVipDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('VIP 功能', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        content: Text('$feature是VIP专属功能\n升级VIP即可解锁无限次使用'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); context.push('/profile'); },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
            child: const Text('去升级'),
          ),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _ToolCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
        ]),
      ),
    );
  }
}

class _Tutorial {
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  final String tag;
  const _Tutorial({required this.title, required this.desc, required this.icon, required this.color, required this.tag});
}

class _TutorialCard extends StatelessWidget {
  final _Tutorial tutorial;
  const _TutorialCard({required this.tutorial});

  @override
  Widget build(BuildContext context) {
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
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: tutorial.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(tutorial.icon, color: tutorial.color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: tutorial.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(tutorial.tag, style: TextStyle(fontSize: 10, color: tutorial.color, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(tutorial.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary))),
          ]),
          const SizedBox(height: 4),
          Text(tutorial.desc, style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
        ])),
        const Icon(Icons.play_circle_outline, size: 28, color: AppTheme.primary),
      ]),
    );
  }
}

// ==================== AR 试妆 ====================
class _ARTryOnSheet extends StatelessWidget {
  const _ARTryOnSheet();

  final _products = const [
    {'name': '正红色口红', 'color': Color(0xFFCC0000), 'brand': 'MAC', 'price': '¥180'},
    {'name': '豆沙色口红', 'color': Color(0xFFB07060), 'brand': 'YSL', 'price': '¥320'},
    {'name': '西柚色口红', 'color': Color(0xFFFF7F50), 'brand': 'Dior', 'price': '¥350'},
    {'name': '裸粉色口红', 'color': Color(0xFFD4A0A0), 'brand': 'Chanel', 'price': '¥340'},
    {'name': '梅子色口红', 'color': Color(0xFF8B4513), 'brand': 'Tom Ford', 'price': '¥480'},
    {'name': '珊瑚色口红', 'color': Color(0xFFFF7F7F), 'brand': 'NARS', 'price': '¥260'},
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(children: [
          Container(
            width: 40, height: 4, margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(color: AppTheme.textMute.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(children: [
              Text('AR 试妆', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Spacer(),
              Text('VIP 无限次', style: TextStyle(fontSize: 12, color: AppTheme.primary)),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _products.length,
              itemBuilder: (_, i) {
                final p = _products[i];
                final color = p['color'] as Color;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: Row(children: [
                    Container(width: 44, height: 44, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(22))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      Text('${p['brand']} · ${p['price']}', style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
                    ])),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, minimumSize: const Size(72, 32)),
                      child: const Text('试妆', style: TextStyle(fontSize: 12)),
                    ),
                  ]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

// ==================== 发型模拟 ====================
class _HairstyleSimSheet extends StatelessWidget {
  const _HairstyleSimSheet();

  final _hairstyles = const [
    {'name': '长直发', 'icon': '👩', 'desc': '修饰圆脸'},
    {'name': '短发bob', 'icon': '💇', 'desc': '显脸小利器'},
    {'name': '空气刘海', 'icon': '💁', 'desc': '缩短脸长比例'},
    {'name': '中分波浪', 'icon': '🧑', 'desc': '柔和方脸线条'},
    {'name': '齐耳短发', 'icon': '👨', 'desc': '干净利落'},
    {'name': '丸子头', 'icon': '🙆', 'desc': '拉长身形比例'},
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(children: [
          Container(
            width: 40, height: 4, margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(color: AppTheme.textMute.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('发型模拟器', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: GridView.builder(
              controller: controller,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: _hairstyles.length,
              itemBuilder: (_, i) {
                final h = _hairstyles[i];
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primary.withValues(alpha: 0.1)),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(h['icon'] as String, style: const TextStyle(fontSize: 36)),
                      const SizedBox(height: 8),
                      Text(h['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                      const SizedBox(height: 4),
                      Text(h['desc'] as String, style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
                    ]),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
