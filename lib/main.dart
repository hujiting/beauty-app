import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/makeup_page.dart';
import 'pages/style_page.dart';
import 'pages/shop_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const YueJiApp());
}

class YueJiApp extends StatelessWidget {
  const YueJiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beauty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A1A1A),
          primary: const Color(0xFF1A1A1A),
          secondary: const Color(0xFFD4A5A5),
          tertiary: const Color(0xFFC9B99A),
          surface: const Color(0xFFFCFCFA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F0),
        fontFamily: 'PingFang SC',
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadowColor: Colors.black.withOpacity(0.04),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F5F0),
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Color(0xFF1A1A1A),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF1A1A1A),
          unselectedItemColor: Color(0xFF8C8C8C),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  List<Widget> get _pages => [
    HomePage(onTabChange: (i) => setState(() => _currentIndex = i)),
    const MakeupPage(),
    const StylePage(),
    const ShopPage(),
    const ProfilePage(),
  ];

  final List<String> _labels = ['首页', '妆容', '穿搭', '商城', '我的'];

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.auto_awesome,
    Icons.checkroom,
    Icons.shopping_bag_outlined,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: const Color(0xFFF0EDE8), width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) {
                final isActive = _currentIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _currentIndex = index),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 64,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _icons[index],
                          size: 22,
                          color: isActive
                              ? const Color(0xFF1A1A1A)
                              : const Color(0xFF8C8C8C),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _labels[index],
                          style: TextStyle(
                            fontSize: 11,
                            color: isActive
                                ? const Color(0xFF1A1A1A)
                                : const Color(0xFF8C8C8C),
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
