import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/data_models.dart';

/// 个人中心 — 含 VIP 升级 + 完整档案管理 + 线下引流
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildUserCard(context, app)),
            SliverToBoxAdapter(child: _buildVipCard(context, app)),
            SliverToBoxAdapter(child: _buildProfileSection(context, app)),
            SliverToBoxAdapter(child: _buildMenuSection(context)),
            SliverToBoxAdapter(child: _buildOfflineSection(context)),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, AppState app) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary.withValues(alpha: 0.08), AppTheme.accent.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Row(children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(app.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(app.userBio, style: const TextStyle(fontSize: 13, color: AppTheme.textHint)),
          const SizedBox(height: 8),
          Row(children: [
            _statChip('风格', app.styleResult ?? '未设置'),
            const SizedBox(width: 8),
            _statChip('城市', app.userCity),
          ]),
        ])),
      ]),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _statChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$label: $value', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildVipCard(BuildContext context, AppState app) {
    if (app.isVip) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.amber, Colors.orange]),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        child: Row(children: [
          const Icon(Icons.workspace_premium, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(app.vipLevel.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text('无限次AI试妆 · 专属造型师', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ])),
          TextButton(
            onPressed: () => _showVipDialog(context, app),
            child: const Text('权益', style: TextStyle(fontSize: 13, color: Colors.white)),
          ),
        ]),
      ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
    }

    return GestureDetector(
      onTap: () => _showVipDialog(context, app),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black.withValues(alpha: 0.85), Colors.black.withValues(alpha: 0.7)]),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        child: Row(children: [
          const Icon(Icons.workspace_premium, color: Colors.amber, size: 32),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('升级 VIP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const Text('解锁无限次AI试妆 · 专属造型师 · 高清皮肤检测', style: TextStyle(fontSize: 12, color: Colors.white60)),
          ])),
          const Icon(Icons.chevron_right, color: Colors.white60),
        ]),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
  }

  void _showVipDialog(BuildContext context, AppState app) {
    showDialog(context: context, builder: (_) => SimpleDialog(
      title: const Text('VIP 会员', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      children: [
        _vipOption(context, app, '普通用户', '基础诊断 · 每日3次AI分析', '免费', VipLevel.free),
        _vipOption(context, app, 'VIP 会员', '无限次AI试妆 · 高清皮肤检测 · ¥29/月', '升级', VipLevel.vip),
        _vipOption(context, app, 'SVIP 会员', 'VIP权益 + 专属人工造型师1对1 · ¥99/月', '升级', VipLevel.svip),
      ],
    ));
  }

  Widget _vipOption(BuildContext context, AppState app, String title, String desc, String btn, VipLevel level) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          if (app.vipLevel == level) ...[
            const SizedBox(width: 6),
            const Text('当前', style: TextStyle(fontSize: 11, color: AppTheme.primary)),
          ],
        ]),
        const SizedBox(height: 4),
        Text(desc, style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
        const SizedBox(height: 8),
        if (app.vipLevel != level)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () { app.upgradeToVip(level); Navigator.pop(context); },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
              child: Text(btn),
            ),
          ),
      ]),
    );
  }

  Widget _buildProfileSection(BuildContext context, AppState app) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('我的档案', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          _profileRow('身体数据', app.bodyProfile.bodyShape, Icons.accessibility),
          _profileRow('面部数据', app.faceProfile.faceShape ?? '未设置', Icons.face),
          _profileRow('发肤数据', app.skinHairProfile.skinType ?? '未设置', Icons.spa),
          _profileRow('色彩季型', app.faceProfile.colorSeason, Icons.palette),
          _profileRow('衣橱数量', '${app.wardrobe.length}件', Icons.checkroom),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }

  Widget _profileRow(String label, String value, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20, color: AppTheme.primary),
      title: Text(label, style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
      trailing: Text(value, style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final menus = [
      _MenuItem(Icons.spa_outlined, '护肤管理', '/skincare'),
      _MenuItem(Icons.camera_alt_outlined, '出片圣地', '/capture'),
      _MenuItem(Icons.people_outline, '相似博主', '/bloggers'),
      _menuItem(Icons.health_and_safety_outlined, '健康知识', '/wellness'),
      _MenuItem(Icons.brush_outlined, '妆容分析', '/makeup'),
      _MenuItem(Icons.cut, '发型推荐', '/hairstyle'),
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: menus.map((m) => ListTile(
          leading: Icon(m.icon, size: 20, color: AppTheme.primary),
          title: Text(m.label, style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary)),
          trailing: const Icon(Icons.chevron_right, size: 20, color: AppTheme.textMute),
          onTap: m.route != null ? () => context.push(m.route!) : null,
        )).toList(),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }

  _MenuItem _menuItem(IconData icon, String label, String route) => _MenuItem(icon, label, route);

  Widget _buildOfflineSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFFE8B4B8).withValues(alpha: 0.1), const Color(0xFFB4C8E8).withValues(alpha: 0.05)]),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.store_mall_directory, size: 20, color: AppTheme.primary),
            const SizedBox(width: 8),
            const Text('线下服务', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          ]),
          const SizedBox(height: 4),
          const Text('合作商户在线预约 · APP领券 · 线下核销', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _offlineCard('美容院', '面部护理 8折', Icons.spa)),
            const SizedBox(width: 8),
            Expanded(child: _offlineCard('理发店', '剪染套餐 ¥199', Icons.cut)),
            const SizedBox(width: 8),
            Expanded(child: _offlineCard('照相馆', '证件照 ¥49', Icons.camera)),
          ]),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms);
  }

  Widget _offlineCard(String name, String offer, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        Icon(icon, size: 24, color: AppTheme.primary),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        const SizedBox(height: 2),
        Text(offer, style: const TextStyle(fontSize: 10, color: AppTheme.accent)),
      ]),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? route;
  const _MenuItem(this.icon, this.label, this.route);
}
