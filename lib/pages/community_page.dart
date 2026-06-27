import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 分享社区页
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});
  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  String _selected = '推荐';
  final _tabs = ['推荐', '穿搭', '妆容', '发型'];

  static final _posts = [
    _PostItem(
      name: '小鹿',
      avatar: '🦌',
      time: '2小时前',
      content: '今天尝试了法式碎花裙+贝雷帽的搭配，被同事夸了一整天！分享给大家～',
      tags: ['法式浪漫', '穿搭分享'],
      likes: 328,
      comments: 42,
    ),
    _PostItem(
      name: 'Lily',
      avatar: '💄',
      time: '5小时前',
      content: '新学的清透底妆技巧，重点是少量多次拍打，比涂抹更服帖！附详细步骤图。',
      tags: ['妆容教程', '日常妆'],
      likes: 512,
      comments: 67,
    ),
    _PostItem(
      name: '阿杰',
      avatar: '👨',
      time: '8小时前',
      content: '男生的护肤也可以很精致！我的日常三步：洁面+水+乳液，坚持一个月皮肤状态好太多。',
      tags: ['男士护肤', '简约护理'],
      likes: 256,
      comments: 31,
    ),
    _PostItem(
      name: '苏苏',
      avatar: '👩',
      time: '1天前',
      content: '极简衣橱实践第30天：只留了15件单品，每天出门不再纠结，而且每一件都爱不释手。',
      tags: ['极简主义', '一衣多穿'],
      likes: 689,
      comments: 94,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('变美社区'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab栏
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.borderLight, width: 0.5)),
            ),
            child: Row(
              children: _tabs.map((tab) {
                final active = tab == _selected;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = tab),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: active
                            ? const Border(bottom: BorderSide(color: AppTheme.primary, width: 2))
                            : null,
                      ),
                      child: Center(
                        child: Text(tab,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                              color: active ? AppTheme.textPrimary : AppTheme.textMute)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // 帖子列表
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemCount: _posts.length,
              itemBuilder: (_, i) {
                final post = _posts[i];
                return _PostCard(post: post)
                    .animate()
                    .fadeIn(duration: 300.ms, delay: (i * 80).ms)
                    .slideY(begin: 0.04, end: 0);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final _PostItem post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary.withValues(alpha: 0.3), AppTheme.accent.withValues(alpha: 0.3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(post.avatar, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    Text(post.time, style: const TextStyle(fontSize: 11, color: AppTheme.textMute)),
                  ],
                ),
              ),
              Icon(Icons.more_horiz, color: AppTheme.textMute, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          // 内容
          Text(post.content, style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary, height: 1.7)),
          const SizedBox(height: 12),
          // 标签
          Wrap(
            spacing: 8,
            children: post.tags
                .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(tag, style: const TextStyle(fontSize: 11, color: AppTheme.primary)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 14),
          // 互动栏
          Row(
            children: [
              _ActionButton(icon: Icons.favorite_border, label: '${post.likes}', onTap: () {}),
              const SizedBox(width: 24),
              _ActionButton(icon: Icons.chat_bubble_outline, label: '${post.comments}', onTap: () {}),
              const Spacer(),
              Icon(Icons.share_outlined, size: 18, color: AppTheme.textMute),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textMute),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textMute)),
        ],
      ),
    );
  }
}

class _PostItem {
  final String name;
  final String avatar;
  final String time;
  final String content;
  final List<String> tags;
  final int likes;
  final int comments;
  const _PostItem({required this.name, required this.avatar, required this.time, required this.content, required this.tags, required this.likes, required this.comments});
}
