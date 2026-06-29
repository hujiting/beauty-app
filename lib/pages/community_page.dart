import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/data_models.dart';
import '../models/ai_engine.dart';

/// 模块五：【美圈社区】
/// - 真人实测：相同肤质/身材的认证用户测评
/// - 作业打卡：跟教程完成的反馈
/// - 互助问答：用户互助
/// - KOL种草：博主标注身材/脸型参数
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('美圈社区'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textMute,
          indicatorColor: AppTheme.primary,
          isScrollable: true,
          tabs: const [
            Tab(text: '推荐'),
            Tab(text: '真人实测'),
            Tab(text: '作业打卡'),
            Tab(text: '互助问答'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RecommendTab(),
          _RealTestTab(),
          _HomeworkTab(),
          _QATab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPostDialog(context),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit),
        label: const Text('发布'),
      ),
    );
  }

  void _showPostDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('发布内容'),
      content: const Text('发布功能开发中...\n\n你可以分享：\n• 穿搭实测\n• 妆容打卡\n• 提问互助'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('知道了'))],
    ));
  }
}

// ==================== 推荐（含KOL种草）====================
class _RecommendTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    // KOL 博主内容 + 热门帖子混合
    final kolContents = mockBloggers.take(3).map((b) => _KOLContent(
      blogger: b,
      title: '${b.styleTag}一周穿搭分享',
      desc: '${b.faceShape}/${b.bodyShape}的穿搭心得，附详细单品清单',
    )).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // KOL 种草区
        const Text('KOL种草', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        const SizedBox(height: 4),
        const Text('博主已标注身材/脸型参数，方便对号入座', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
        const SizedBox(height: 12),
        ...kolContents.map((c) => _KOLContentCard(content: c)
            .animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0)),
        const SizedBox(height: 20),
        // 热门帖子
        const Text('热门讨论', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        const SizedBox(height: 12),
        ...mockCommunityPosts.map((p) => _PostCard(post: p)
            .animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.05, end: 0)),
      ],
    );
  }
}

class _KOLContent {
  final KOLBlogger blogger;
  final String title;
  final String desc;
  const _KOLContent({required this.blogger, required this.title, required this.desc});
}

class _KOLContentCard extends StatelessWidget {
  final _KOLContent content;
  const _KOLContentCard({required this.content});

  @override
  Widget build(BuildContext context) {
    final b = content.blogger;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // KOL 信息
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            CircleAvatar(
              backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
              child: Text(b.avatar, style: const TextStyle(fontSize: 20)),
              radius: 22,
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(b.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                const SizedBox(width: 6),
                if (b.isVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(3)),
                    child: const Text('认证', style: TextStyle(fontSize: 9, color: Colors.white)),
                  ),
              ]),
              Text('${b.followers ~/ 1000}k 粉丝', style: const TextStyle(fontSize: 11, color: AppTheme.textHint)),
            ])),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                minimumSize: const Size(56, 28),
                side: const BorderSide(color: AppTheme.primary),
              ),
              child: const Text('关注', style: TextStyle(fontSize: 12)),
            ),
          ]),
        ),
        // 参数标签
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Wrap(spacing: 6, runSpacing: 6, children: [
            _paramChip('脸型', b.faceShape),
            _paramChip('身材', b.bodyShape),
            _paramChip('风格', b.styleTag),
            ...b.specialties.map((s) => _paramChip('专长', s)),
          ]),
        ),
        // 内容
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(content.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            const SizedBox(height: 4),
            Text(content.desc, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5)),
          ]),
        ),
        // 互动栏
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(children: [
            _actionBtn(Icons.favorite_border, '${b.followers ~/ 500}'),
            _actionBtn(Icons.chat_bubble_outline, '${b.followers ~/ 2000}'),
            _actionBtn(Icons.bookmark_border, '收藏'),
            const Spacer(),
            _actionBtn(Icons.share_outlined, '分享'),
          ]),
        ),
      ]),
    );
  }

  Widget _paramChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text('$label: $value', style: const TextStyle(fontSize: 10, color: AppTheme.accent)),
    );
  }

  Widget _actionBtn(IconData icon, String count) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16, color: AppTheme.textMute),
      label: Text(count, style: const TextStyle(fontSize: 12, color: AppTheme.textMute)),
      style: TextButton.styleFrom(minimumSize: const Size(0, 32), padding: const EdgeInsets.symmetric(horizontal: 8)),
    );
  }
}

// ==================== 真人实测 ====================
class _RealTestTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final userShape = app.bodyProfile.bodyShape;
    final userFace = app.faceProfile.faceShape ?? '鹅蛋脸';

    // 优先展示同身材/脸型的帖子
    final matched = mockCommunityPosts.where((p) =>
      p.userBodyShape == userShape || p.userFaceShape == userFace).toList();
    final others = mockCommunityPosts.where((p) =>
      p.userBodyShape != userShape && p.userFaceShape != userFace).toList();
    final display = [...matched, ...others];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (matched.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.1)),
            ),
            child: Row(children: [
              const Icon(Icons.verified_user, size: 18, color: AppTheme.primary),
              const SizedBox(width: 8),
              Expanded(child: Text('已为你筛选 ${matched.length} 条相同身材/脸型的实测', style: const TextStyle(fontSize: 12, color: AppTheme.primary))),
            ]),
          ),
        ],
        ...display.map((p) => _PostCard(post: p, showMatch: true)
            .animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0)),
      ],
    );
  }
}

// ==================== 作业打卡 ====================
class _HomeworkTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeworks = mockCommunityPosts.where((p) => p.category == '作业打卡').toList();
    final display = homeworks.isEmpty ? mockCommunityPosts.take(2).toList() : homeworks;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('跟着教程画完妆/搭完衣服的反馈区', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
        const SizedBox(height: 12),
        ...display.map((p) => _PostCard(post: p, showMatch: false)
            .animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0)),
      ],
    );
  }
}

// ==================== 互助问答 =====================
class _QATab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final questions = mockCommunityPosts.where((p) => p.category == '互助问答').toList();
    final display = questions.isEmpty ? mockCommunityPosts.take(1).toList() : questions;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('有疑问？问问和你一样的小伙伴', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
        const SizedBox(height: 12),
        ...display.map((p) => _PostCard(post: p, showMatch: false)
            .animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0)),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('我要提问'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primary,
            minimumSize: const Size(double.infinity, 48),
            side: const BorderSide(color: AppTheme.primary),
          ),
        ),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  final CommunityPost post;
  final bool showMatch;
  const _PostCard({required this.post, this.showMatch = false});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final isMatched = showMatch &&
      (post.userBodyShape == app.bodyProfile.bodyShape ||
       post.userFaceShape == app.faceProfile.faceShape);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: isMatched ? Border.all(color: AppTheme.primary.withValues(alpha: 0.3)) : null,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // 用户信息
          Row(children: [
            CircleAvatar(child: Text(post.userAvatar), radius: 18),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(post.userName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                if (isMatched) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(3)),
                    child: const Text('同款', style: TextStyle(fontSize: 9, color: Colors.white)),
                  ),
                ],
              ]),
              Text('${post.userFaceShape} · ${post.userBodyShape}', style: const TextStyle(fontSize: 11, color: AppTheme.textHint)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(4)),
              child: Text(post.category, style: const TextStyle(fontSize: 10, color: AppTheme.accent)),
            ),
          ]),
          const SizedBox(height: 10),
          // 标题和内容
          Text(post.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(post.content, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          // 互动
          Row(children: [
            Icon(Icons.favorite_border, size: 16, color: AppTheme.textMute),
            const SizedBox(width: 4),
            Text('${post.likes}', style: const TextStyle(fontSize: 12, color: AppTheme.textMute)),
            const SizedBox(width: 16),
            Icon(Icons.chat_bubble_outline, size: 16, color: AppTheme.textMute),
            const SizedBox(width: 4),
            Text('${post.comments}', style: const TextStyle(fontSize: 12, color: AppTheme.textMute)),
            const Spacer(),
            const Icon(Icons.bookmark_border, size: 16, color: AppTheme.textMute),
          ]),
        ]),
      ),
    );
  }
}
