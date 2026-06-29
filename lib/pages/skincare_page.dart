import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/ai_engine.dart';

/// 护肤管理页 — 每日护肤步骤 + 肤质分析历史
class SkincarePage extends StatefulWidget {
  const SkincarePage({super.key});
  @override
  State<SkincarePage> createState() => _SkincarePageState();
}

class _SkincarePageState extends State<SkincarePage> {
  int _tab = 0; // 0=今日护肤 1=肤质记录 2=发质记录

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('护肤管理'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_outlined),
            onPressed: () => setState(() => _tab = 1),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab 切换
          Container(
            margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            decoration: BoxDecoration(
              color: AppTheme.bgGray,
              borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            ),
            child: Row(
              children: ['今日护肤', '肤质记录', '发质记录']
                  .asMap()
                  .entries
                  .map((e) => Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _tab = e.key),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _tab == e.key
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusPill),
                              boxShadow: _tab == e.key
                                  ? AppTheme.cardShadow
                                  : null,
                            ),
                            child: Center(
                              child: Text(e.value,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: _tab == e.key
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: _tab == e.key
                                        ? AppTheme.textPrimary
                                        : AppTheme.textMute)),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: [
                _SkincareToday(app: app),
                _AnalysisHistory(
                    items: app.skinAnalysisHistory, icon: Icons.face),
                _AnalysisHistory(
                    items: app.hairAnalysisHistory,
                    icon: Icons.content_cut),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===== 今日护肤步骤 =====
class _SkincareToday extends StatelessWidget {
  final AppState app;
  const _SkincareToday({required this.app});

  static const _stepDesc = {
    '洁面': '温和清洁，去除污垢和多余油脂',
    '爽肤水': '补水平衡，帮助后续吸收',
    '精华': '针对性修护，改善肤质问题',
    '乳液/面霜': '锁水保湿，形成保护膜',
    '防晒': '阻挡紫外线，预防光老化',
  };

  @override
  Widget build(BuildContext context) {
    final steps = app.skincareSteps;
    final today = app.skincareToday;
    final doneCount = today.values.where((v) => v).length;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // 进度环
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.3),
                width: 6,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$doneCount/${steps.length}',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary)),
                  const Text('已完成',
                      style:
                          TextStyle(fontSize: 11, color: AppTheme.textMute)),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),
        const SizedBox(height: 28),
        ...steps.asMap().entries.map((e) {
          final i = e.key;
          final step = e.value;
          final done = today[step] ?? false;
          return _SkincareStepCard(
            index: i,
            step: step,
            done: done,
            desc: _stepDesc[step] ?? '',
            onTap: () => app.toggleSkincareStep(step),
          ).animate().fadeIn(delay: (i * 80).ms, duration: 300.ms);
        }),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SkincareStepCard extends StatelessWidget {
  final int index;
  final String step;
  final bool done;
  final String desc;
  final VoidCallback onTap;
  const _SkincareStepCard(
      {required this.index,
      required this.step,
      required this.done,
      required this.desc,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: done ? AppTheme.primary.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: done
              ? Border.all(color: AppTheme.primary.withValues(alpha: 0.3))
              : Border.all(color: AppTheme.borderLight),
          boxShadow: done ? [] : AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: done
                    ? AppTheme.primary.withValues(alpha: 0.15)
                    : AppTheme.bgGray,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text('${index + 1}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: done ? AppTheme.primary : AppTheme.textMute)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: done
                              ? AppTheme.textPrimary
                              : AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Text(desc,
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.textHint)),
                ],
              ),
            ),
            Icon(
              done ? Icons.check_circle : Icons.circle_outlined,
              color: done ? AppTheme.primary : AppTheme.borderLight,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

// ===== 分析历史记录 =====
class _AnalysisHistory extends StatelessWidget {
  final List<dynamic> items;
  final IconData icon;
  const _AnalysisHistory({required this.items, required this.icon});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppTheme.textMute.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text('暂无记录', style: TextStyle(fontSize: 14, color: AppTheme.textMute)),
            const SizedBox(height: 8),
            Text('去分析页完成你的第一次分析吧',
                style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final item = items[i];
        // 兼容 SkinAnalysisResult / HairAnalysisResult 对象
        final String resultStr;
        final String summaryStr;
        if (item is SkinAnalysisResult) {
          resultStr = item.type;
          summaryStr = item.summary;
        } else if (item is HairAnalysisResult) {
          resultStr = item.type;
          summaryStr = item.summary;
        } else {
          resultStr = (item as Map)['result'] ?? '';
          summaryStr = item['summary'] ?? '';
        }
        final dateStr = (item is Map) ? (item['date'] ?? '') : DateTime.now().toIso8601String().substring(0, 10);
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
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 18, color: AppTheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(resultStr,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary)),
                  ),
                  Text(dateStr,
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.textMute)),
                ],
              ),
              const SizedBox(height: 10),
              Text(summaryStr,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      height: 1.5)),
            ],
          ),
        ).animate().fadeIn(delay: (i * 60).ms, duration: 300.ms);
      },
    );
  }
}
