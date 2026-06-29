import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../pages/home_page.dart';
import '../pages/shop_page.dart';
import '../pages/beauty_lab_page.dart';
import '../pages/wardrobe_page.dart';
import '../pages/community_page.dart';
import '../pages/profile_page.dart';
import '../pages/capture_page.dart';
import '../pages/wellness_page.dart';
import '../pages/style_page.dart';
import '../pages/skin_analysis_page.dart';
import '../pages/hair_analysis_page.dart';
import '../pages/skincare_page.dart';
import '../pages/outfit_page.dart';
import '../pages/hairstyle_page.dart';
import '../pages/blogger_page.dart';
import '../pages/makeup_page.dart';

/// APP 统一路由配置 — 四层架构五大模块
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) {
        return _MainShell(child: child, location: state.matchedLocation);
      },
      branches: [
        // 模块一：我的管家
        StatefulShellBranch(routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
        ]),
        // 模块二：妆造实验室
        StatefulShellBranch(routes: [
          GoRoute(path: '/lab', builder: (context, state) => const BeautyLabPage()),
        ]),
        // 模块三：智能衣橱
        StatefulShellBranch(routes: [
          GoRoute(path: '/wardrobe', builder: (context, state) => const WardrobePage()),
        ]),
        // 模块四：变美商城
        StatefulShellBranch(routes: [
          GoRoute(path: '/shop', builder: (context, state) => const ShopPage()),
        ]),
        // 模块五：美圈社区
        StatefulShellBranch(routes: [
          GoRoute(path: '/community', builder: (context, state) => const CommunityPage()),
        ]),
      ],
    ),
    // 非 Tab 页面
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
    GoRoute(path: '/capture', builder: (context, state) => const CapturePage()),
    GoRoute(path: '/wellness', builder: (context, state) => const WellnessPage()),
    GoRoute(path: '/style', builder: (context, state) => const StylePage()),
    GoRoute(path: '/skincare', builder: (context, state) => const SkincarePage()),
    GoRoute(path: '/outfit', builder: (context, state) => const OutfitPage()),
    GoRoute(path: '/hairstyle', builder: (context, state) => const HairstylePage()),
    GoRoute(path: '/bloggers', builder: (context, state) => const BloggerPage()),
    GoRoute(path: '/makeup', builder: (context, state) => const MakeupPage()),
    GoRoute(path: '/skin-analysis', builder: (context, state) => const SkinAnalysisPage()),
    GoRoute(path: '/hair-analysis', builder: (context, state) => const HairAnalysisPage()),
  ],
);

class _MainShell extends StatelessWidget {
  final Widget child;
  final String location;
  const _MainShell({required this.child, required this.location});

  int get _currentIndex {
    if (location.startsWith('/lab')) return 1;
    if (location.startsWith('/wardrobe')) return 2;
    if (location.startsWith('/shop')) return 3;
    if (location.startsWith('/community')) return 4;
    return 0;
  }

  static const _tabIcons = [
    (icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome, label: '管家'),
    (icon: Icons.science_outlined, activeIcon: Icons.science, label: '妆造'),
    (icon: Icons.checkroom_outlined, activeIcon: Icons.checkroom, label: '衣橱'),
    (icon: Icons.store_outlined, activeIcon: Icons.store, label: '商城'),
    (icon: Icons.group_outlined, activeIcon: Icons.group, label: '美圈'),
  ];

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex;
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: idx,
          onTap: (i) {
            final paths = ['/', '/lab', '/wardrobe', '/shop', '/community'];
            context.go(paths[i]);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textMute,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: _tabIcons.map((tab) {
            final i = _tabIcons.indexOf(tab);
            return BottomNavigationBarItem(
              icon: Icon(i == idx ? tab.activeIcon : tab.icon),
              label: tab.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}
