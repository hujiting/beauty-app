import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

class WellnessPage extends StatelessWidget {
  const WellnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('健康知识'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemCount: _articles.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('健康美丽，从内而外',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('科学护肤，健康生活',
                      style: TextStyle(
                          fontSize: 14, color: AppTheme.textHint)),
                  const SizedBox(height: 20),
                ],
              ).animate().fadeIn(duration: 400.ms);
            }
            return _ArticleCard(article: _articles[i - 1], index: i - 1);
          },
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final _Article article;
  final int index;

  const _ArticleCard({required this.article, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: AppCard(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部色块（替代图片）
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: article.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppTheme.radiusM)),
              ),
              alignment: Alignment.center,
              child: Text(
                article.emoji,
                style: const TextStyle(fontSize: 48),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(article.summary,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          height: 1.5),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(article.tag,
                          style: const TextStyle(
                              fontSize: 11, color: AppTheme.primary)),
                      const Spacer(),
                      const Icon(Icons.favorite_border,
                          size: 16, color: AppTheme.textMute),
                      const SizedBox(width: 4),
                      Text('${article.likes}',
                          style: const TextStyle(
                              fontSize: 11, color: AppTheme.textMute)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (index * 80).ms).slideY(
          begin: 0.1,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }
}

class _Article {
  final String title;
  final String summary;
  final String emoji;
  final List<Color> colors;
  final String tag;
  final int likes;

  const _Article({
    required this.title,
    required this.summary,
    required this.emoji,
    required this.colors,
    required this.tag,
    required this.likes,
  });
}

final _articles = [
  _Article(
    title: '早晚护肤步骤，你做对了吗？',
    summary: '正确的护肤步骤能让护肤品发挥最大功效，避免浪费和皮肤负担。',
    emoji: '🧴',
    colors: [Color(0xFFE8D5D5), Color(0xFFD4A5A5)],

    likes: 128,
  ),
  _Article(
    title: '多喝水真的能改善肤质吗？',
    summary: '科学研究表明，充足的水分摄入对皮肤健康有积极影响。',
    emoji: '💧',
    colors: [Color(0xFFF0E6D6), Color(0xFFC9B99A)],
    tag: '健康饮食',
    likes: 96,
  ),
  _Article(
    title: '每天5分钟，改善面部循环',
    summary: '简单的面部按摩手法，促进面部血液循环，提升皮肤光泽。',
    emoji: '✨',
    colors: [Color(0xFFD4A5A5), Color(0xFFB88A8A)],

    likes: 156,
  ),
  _Article(
    title: '防晒是最便宜的抗老方式',
    summary: '紫外线是皮肤老化的最大元凶，科学防晒从今天开始。',
    emoji: '☀️',
    colors: [Color(0xFFC9B99A), Color(0xFFB88A8A)],

    likes: 203,
  ),
  _Article(
    title: '睡不够8小时，皮肤会怎样？',
    summary: '睡眠不足会影响皮肤修复，导致暗沉、细纹等问题。',
    emoji: '🌙',
    colors: [Color(0xFFE8D5D5), Color(0xFFF0E6D6)],

    likes: 87,
  ),
];
