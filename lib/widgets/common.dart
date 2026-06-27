import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';

/// 公共组件库 - 统一 APP 视觉风格

// ============ 统一卡片 ============
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? radius;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const AppCard({
    required this.child,
    this.padding,
    this.radius,
    this.color,
    this.boxShadow,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        color: color ?? AppTheme.bgCard,
        borderRadius: BorderRadius.circular(radius ?? AppTheme.radiusM),
        boxShadow: boxShadow ?? AppTheme.cardShadow,
      ),
      child: child,
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius ?? AppTheme.radiusM),
        child: content,
      ),
    );
  }
}

// ============ 渐变卡片 ============
class AppGradientCard extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final double? radius;

  const AppGradientCard({
    required this.child,
    required this.colors,
    this.radius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius ?? AppTheme.radiusM),
        boxShadow: AppTheme.cardShadow,
      ),
      child: child,
    );
  }
}

// ============ 统一按钮 ============
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool filled;
  final bool small;
  final Color? color;

  const AppButton({
    required this.label,
    this.onTap,
    this.filled = true,
    this.small = false,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: filled ? (color ?? Colors.black) : Colors.transparent,
        foregroundColor: filled ? Colors.white : Colors.black,
        elevation: 0,
        side: filled ? null : const BorderSide(color: AppTheme.borderLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: small ? 16 : 24,
          vertical: small ? 8 : 14,
        ),
      ),
      child: Text(label, style: TextStyle(fontSize: small ? 13 : 15)),
    );
  }
}

// ============ 区块标题 ============
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onMore;

  const SectionHeader({
    required this.title,
    this.subtitle,
    this.onMore,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary)),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(subtitle!,
                  style: const TextStyle(
                      fontSize: 12, color: AppTheme.textHint)),
            ],
          ],
        ),
        if (onMore != null)
          GestureDetector(
            onTap: onMore,
            child: const Text('查看更多',
                style: TextStyle(
                    fontSize: 13, color: AppTheme.textHint)),
          ),
      ],
    );
  }
}

// ============ 分类胶囊 ============
class CategoryPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const CategoryPill({
    required this.label,
    this.active = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Animate(
        effects: [
          ScaleEffect(
            duration: 200.ms,
            curve: Curves.easeOut,
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: active ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            border: active
                ? null
                : Border.all(color: AppTheme.borderLight),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: active ? Colors.white : AppTheme.textSecondary,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

// ============ 加载骨架屏 ============
class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const SkeletonBox({
    this.width = double.infinity,
    required this.height,
    this.radius = 8,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(radius),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(
          duration: 1200.ms,
          color: Colors.grey[100]!,
        );
  }
}
