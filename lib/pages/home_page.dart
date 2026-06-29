import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/data_models.dart';
import '../models/ai_engine.dart';

/// 模块一：【我的管家】— 首页仪表盘
/// - 今日建议（天气+穿搭推荐）
/// - 待办事项（护肤/理发/衣橱）
/// - 快速入口（拍照诊断/衣橱整理）
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => app.init(),
          child: CustomScrollView(
            slivers: [
              // 顶部问候
              SliverToBoxAdapter(child: _buildHeader(context, app)),
              // 今日建议
              SliverToBoxAdapter(child: _buildTodaySuggestion(context, app)),
              // 待办事项
              SliverToBoxAdapter(child: _buildTodos(context, app)),
              // 快速入口
              SliverToBoxAdapter(child: _buildQuickActions(context, app)),
              // 风格 + 色彩季型
              SliverToBoxAdapter(child: _buildStyleCard(context, app)),
              // 推荐博主
              SliverToBoxAdapter(child: _buildBloggerSection(context, app)),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppState app) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi, ${app.userName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                Text(app.isVip ? '${app.vipLevel.label} · ${app.userCity}' : app.userCity,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textHint)),
              ],
            ),
          ),
          if (app.isVip)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.amber, Colors.orange]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('VIP', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTodaySuggestion(BuildContext context, AppState app) {
    final style = app.styleResult ?? '法式浪漫';
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary.withValues(alpha: 0.08), AppTheme.accent.withValues(alpha: 0.05)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.wb_sunny_outlined, size: 20, color: AppTheme.primary),
            const SizedBox(width: 8),
            const Text('今日建议', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const Spacer(),
            Text(app.userCity, style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
          ]),
          const SizedBox(height: 16),
          _suggestionRow(Icons.checkroom_outlined, '穿搭', '今日推荐 $style 风格，搭配丝质衬衫+高腰阔腿裤'),
          const SizedBox(height: 10),
          _suggestionRow(Icons.spa_outlined, '护肤', '今日护肤重点：${app.skinKeyword ?? "基础护理"}'),
          const SizedBox(height: 10),
          _suggestionRow(Icons.camera_alt_outlined, '出片', '今天光线适合在户外拍人像，推荐下午4-5点'),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _suggestionRow(IconData icon, String label, String text) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 16, color: AppTheme.primary),
      const SizedBox(width: 8),
      Text('$label  ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5))),
    ]);
  }

  Widget _buildTodos(BuildContext context, AppState app) {
    if (app.todos.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('待办事项', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const Spacer(),
            TextButton(onPressed: () => context.push('/skincare'), child: const Text('全部', style: TextStyle(fontSize: 13, color: AppTheme.primary))),
          ]),
          const SizedBox(height: 8),
          ...app.todos.map((todo) => _TodoTile(todo: todo).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0)),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }

  Widget _buildQuickActions(BuildContext context, AppState app) {
    final actions = [
      _QuickAction(icon: Icons.face_retouching_natural, label: 'AI测脸', color: const Color(0xFFE8B4B8), route: '/style'),
      _QuickAction(icon: Icons.checkroom, label: '智能衣橱', color: const Color(0xFFB4C8E8), route: '/wardrobe'),
      _QuickAction(icon: Icons.spa, label: '肤质分析', color: const Color(0xFFB8E8C4), route: '/skin-analysis'),
      _QuickAction(icon: Icons.cut, label: '发质分析', color: const Color(0xFFE8D4B4), route: '/hair-analysis'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('快速入口', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 16),
          Row(children: actions.map((a) => Expanded(child: _QuickActionCard(action: a))).toList()),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }

  Widget _buildStyleCard(BuildContext context, AppState app) {
    final colorSeason = app.faceProfile.colorSeason;
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('我的风格档案', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const Spacer(),
            TextButton(onPressed: () => context.push('/style'), child: const Text('重新诊断', style: TextStyle(fontSize: 12, color: AppTheme.primary))),
          ]),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _tagChip('风格', app.styleResult ?? '未设置', AppTheme.primary),
            _tagChip('体型', app.bodyProfile.bodyShape, const Color(0xFF7B68EE)),
            _tagChip('脸型', app.faceProfile.faceShape ?? '未设置', const Color(0xFFE8B4B8)),
            _tagChip('肤质', app.skinHairProfile.skinType ?? '未设置', const Color(0xFFB8E8C4)),
            _tagChip('色彩季型', colorSeason, Colors.amber),
          ]),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms);
  }

  Widget _tagChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$label: $value', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildBloggerSection(BuildContext context, AppState app) {
    final bloggers = MatchingEngine.matchBloggers(
      faceShape: app.faceProfile.faceShape,
      bodyShape: app.bodyProfile.bodyShape,
      styleTags: app.stylePreference.styleTags,
    ).take(3).toList();
    final display = bloggers.isEmpty ? mockBloggers.take(3).toList() : bloggers;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('相似博主推荐', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const Spacer(),
            TextButton(onPressed: () => context.push('/bloggers'), child: const Text('更多', style: TextStyle(fontSize: 13, color: AppTheme.primary))),
          ]),
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: display.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final b = display[i];
                return _BloggerMiniCard(blogger: b).animate().fadeIn(duration: 300.ms, delay: (i * 100).ms);
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 500.ms);
  }
}

class _TodoTile extends StatelessWidget {
  final TodoItem todo;
  const _TodoTile({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(children: [
        Icon(todo.icon, size: 20, color: AppTheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(todo.title, style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary))),
        const Icon(Icons.chevron_right, size: 20, color: AppTheme.textMute),
      ]),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.route});
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;
  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(action.route),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: action.color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: Column(children: [
          Icon(action.icon, size: 28, color: action.color),
          const SizedBox(height: 8),
          Text(action.label, style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

class _BloggerMiniCard extends StatelessWidget {
  final KOLBlogger blogger;
  const _BloggerMiniCard({required this.blogger});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(child: Text(blogger.avatar, style: const TextStyle(fontSize: 18)), radius: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(blogger.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
          const SizedBox(height: 8),
          Text('${blogger.faceShape} · ${blogger.bodyShape}', style: const TextStyle(fontSize: 11, color: AppTheme.textHint)),
          const SizedBox(height: 4),
          Wrap(spacing: 4, children: blogger.specialties.take(2).map((s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(s, style: const TextStyle(fontSize: 10, color: AppTheme.primary)),
          )).toList()),
        ],
      ),
    );
  }
}
