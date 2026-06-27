import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../providers/app_state.dart';
import 'capture_page.dart';
import 'wellness_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _UserInfoCard(),
              const SizedBox(height: 16),
              _StyleCard(),
              const SizedBox(height: 16),
              _StatRow(),
              const SizedBox(height: 20),
              const SectionHeader(title: '我的服务'),
              const SizedBox(height: 12),
              _MenuList(),
            ],
          ),
        ),
      ),
    );
  }
}

// 用户信息卡
class _UserInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return AppCard(
      onTap: () {}, // TODO: 编辑资料页
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: const Text('👤', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appState.userName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(appState.userBio,
                    style: const TextStyle(
                        fontSize: 13, color: AppTheme.textHint)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.textMute),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(
          begin: 0.1,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }
}

// 风格诊断卡片
class _StyleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final styleResult = context.watch<AppState>().styleResult;

    return AppGradientCard(
      colors: const [Color(0xFFF0E6D6), Colors.white],
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            child: const Icon(Icons.auto_awesome,
                color: AppTheme.accent, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  styleResult != null ? '你的风格：$styleResult' : '风格诊断',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  styleResult != null ? '查看详细分析报告' : '完成风格测试，解锁你的专属穿搭方案',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => context.go('/style'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusPill),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 0,
            ),
            child: Text(styleResult != null ? '查看' : '去测试',
                style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }
}

// 数据统计行
class _StatRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _StatItem(count: '12', label: '收藏'),
          _StatItem(count: '5', label: '关注'),
          _StatItem(count: '8', label: '获赞'),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;

  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
      ],
    );
  }
}

// 菜单列表
class _MenuList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (icon: Icons.camera_alt_outlined, label: '拍照圣地', route: '/capture'),
      (icon: Icons.favorite_outline, label: '健康知识', route: '/wellness'),
      (icon: Icons.receipt_outlined, label: '我的订单', route: ''),
      (icon: Icons.star_outline, label: '我的收藏', route: ''),
    ];

    return Column(
      children: items.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        return Column(
          children: [
            _MenuItem(
              icon: item.icon as IconData,
              label: item.label as String,
              onTap: item.route != ''
                  ? () => context.go(item.route as String)
                  : () {},
            ),
            if (i < items.length - 1) const SizedBox(height: 12),
          ],
        ).animate().fadeIn(duration: 300.ms, delay: (300 + i * 80).ms).slideX(
              begin: 0.05,
              end: 0,
              duration: 300.ms,
              curve: Curves.easeOut,
            );
      }).toList(),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: AppCard(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.bgGradientStart.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: Icon(icon, color: AppTheme.accent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textMute),
            ],
          ),
        ),
      ),
    );
  }
}
