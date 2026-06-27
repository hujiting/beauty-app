import 'package:flutter/material.dart';

/// 钥纪 APP 统一主题系统
/// 主色调：粉金质感，优雅高级
class AppTheme {
  // ============ 主色板 ============
  /// 主粉（品牌色）
  static const Color primary = Color(0xFFD4A5A5);
  /// 主粉深
  static const Color primaryDark = Color(0xFFB88A8A);
  /// 辅助金
  static const Color accent = Color(0xFFC9B99A);
  /// 辅助金深
  static const Color accentDark = Color(0xFFA68B6B);
  /// 强调粉（用于价格等）
  static const Color highlight = Color(0xFFC46B8A);

  // ============ 中性色 ============
  static const Color bgWhite = Color(0xFFFAFAFA);
  static const Color bgCard = Colors.white;
  static const Color bgGradientStart = Color(0xFFF0E6D6);
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color textMute = Color(0xFFBBBBBB);
  static const Color border = Color(0xFFF0F0F0);
  static const Color borderLight = Color(0xFFE8E8E4);
  static const Color shadow = Color(0x0A000000);

  // ============ Dark Mode 色板 ============
  static const Color darkBg = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF2A2A2A);
  static const Color darkTextPrimary = Color(0xFFEDEDED);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);

  // ============ 分类渐变色 ============
  static const Map<String, List<Color>> catGradients = {
    '包袋': [Color(0xFFE8D5D5), Color(0xFFD4A5A5)],
    '配饰': [Color(0xFFF0E6D6), Color(0xFFC9B99A)],
    '发饰': [Color(0xFFD4A5A5), Color(0xFFB88A8A)],
    '美甲': [Color(0xFFE8D5D5), Color(0xFFF0E6D6)],
    '首饰': [Color(0xFFC9B99A), Color(0xFFB88A8A)],
    '帽子': [Color(0xFFB88A8A), Color(0xFFD4A5A5)],
  };

  // ============ 圆角 ============
  static const double radiusXS = 8;
  static const double radiusS = 12;
  static const double radiusM = 16;
  static const double radiusL = 20;
  static const double radiusXL = 28;
  static const double radiusPill = 100;

  // ============ 间距 ============
  static const double spaceXS = 4;
  static const double spaceS = 8;
  static const double spaceM = 12;
  static const double spaceL = 16;
  static const double spaceXL = 20;
  static const double space2XL = 24;
  static const double space3XL = 32;

  // ============ 阴影 ============
  static List<BoxShadow> get cardShadow => [
        const BoxShadow(
          color: shadow,
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get cardShadowLg => [
        const BoxShadow(
          color: Color(0x05000000),
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
      ];

  // ============ Light Theme ============
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
          background: bgWhite,
          surface: bgCard,
        ),
        scaffoldBackgroundColor: bgWhite,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
          iconTheme: IconThemeData(color: textPrimary),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textPrimary),
          bodyMedium: TextStyle(color: textSecondary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusPill),
            ),
          ),
        ),
      );

  // ============ Dark Theme ============
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
          background: darkBg,
          surface: darkCard,
        ),
        scaffoldBackgroundColor: darkBg,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkTextPrimary,
          ),
          iconTheme: const IconThemeData(color: darkTextPrimary),
        ),
      );
}
