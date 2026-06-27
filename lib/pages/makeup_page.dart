import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../providers/app_state.dart';

class MakeupPage extends StatefulWidget {
  const MakeupPage({super.key});

  @override
  State<MakeupPage> createState() => _MakeupPageState();
}

class _MakeupPageState extends State<MakeupPage> {
  bool _isAnalyzing = false;
  double _progress = 0;
  String? _result;
  Timer? _timer;

  final _analysisSteps = [
    '正在检测肤质...',
    '分析面部特征...',
    '匹配妆容风格...',
    '生成个性化方案...',
    '分析完成！',
  ];

  String get _currentStep {
    final idx = (_progress * _analysisSteps.length).floor().clamp(0, _analysisSteps.length - 1);
    return _analysisSteps[idx];
  }

  void _startAnalysis() {
    setState(() {
      _isAnalyzing = true;
      _progress = 0;
      _result = null;
    });

    // 模拟分析进度
    _timer = Timer.periodic(const Duration(milliseconds: 80), (t) {
      setState(() => _progress += 0.01);
      if (_progress >= 1.0) {
        t.cancel();
        setState(() {
          _isAnalyzing = false;
          _result = '清新自然妆';
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('智能上妆'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _result != null
              ? _buildResult(context)
              : _isAnalyzing
                  ? _buildAnalyzing()
                  : _buildLanding(context),
        ),
      ),
    );
  }

  // 初始页面
  Widget _buildLanding(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 主图标
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(60),
          ),
          child: const Icon(Icons.brush, size: 56, color: Colors.white),
        ).animate().scale(
              duration: 600.ms,
              curve: Curves.elasticOut,
            ),

        const SizedBox(height: 32),

        const Text('AI 智能上妆',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),

        const SizedBox(height: 8),

        const Text('上传照片，获取个性化妆容建议',
            style: TextStyle(fontSize: 14, color: AppTheme.textHint)),

        const SizedBox(height: 48),

        // 上传照片按钮
        ElevatedButton.icon(
          onPressed: _startAnalysis,
          icon: const Icon(Icons.add_a_photo, size: 20),
          label: const Text('上传照片'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

        const SizedBox(height: 16),

        // 拍照按钮
        OutlinedButton.icon(
          onPressed: () => context.go('/capture'),
          icon: const Icon(Icons.camera_alt_outlined, size: 20),
          label: const Text('去拍照'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.textPrimary,
            minimumSize: const Size(double.infinity, 52),
            side: const BorderSide(color: AppTheme.borderLight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            ),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
      ],
    );
  }

  // 分析中页面
  Widget _buildAnalyzing() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 进度环
        SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 6,
                  backgroundColor: AppTheme.primary.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                ),
              ),
              Text('${(_progress * 100).toInt()}%',
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary)),
            ],
          ),
        ).animate().scale(duration: 300.ms, curve: Curves.easeOut),

        const SizedBox(height: 32),

        Text(_currentStep,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary)),

        const SizedBox(height: 8),

        const Text('AI 正在为你分析最适合的妆容',
            style: TextStyle(fontSize: 13, color: AppTheme.textHint)),

        const SizedBox(height: 48),

        // 分析步骤指示器
        Column(
          children: _analysisSteps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final done = _progress > (i + 1) / _analysisSteps.length;
            final current = _progress >= i / _analysisSteps.length &&
                _progress < (i + 1) / _analysisSteps.length;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(
                    done ? Icons.check_circle : Icons.circle,
                    size: 18,
                    color: done
                        ? Colors.green
                        : current
                            ? AppTheme.primary
                            : AppTheme.textMute,
                  ),
                  const SizedBox(width: 12),
                  Text(step,
                      style: TextStyle(
                          fontSize: 13,
                          color: done
                              ? AppTheme.textSecondary
                              : current
                                  ? AppTheme.textPrimary
                                  : AppTheme.textMute)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // 结果页面
  Widget _buildResult(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, size: 40, color: Colors.green),
        ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

        const SizedBox(height: 24),

        Text('推荐妆容：$_result',
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary)),

        const SizedBox(height: 8),

        const Text('根据你的面部特征，为你推荐以下妆容方案',
            style: TextStyle(fontSize: 14, color: AppTheme.textHint)),

        const SizedBox(height: 32),

        // 方案卡片
        AppCard(
          child: Column(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.accent],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                alignment: Alignment.center,
                child: const Text('💄', style: TextStyle(fontSize: 48)),
              ),
              const SizedBox(height: 16),
              const Text('清新自然妆',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('适合日常通勤，突出自然好气色',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _TipItem(label: '底妆', tip: '轻薄透气'),
                  _TipItem(label: '眼妆', tip: '大地色系'),
                  _TipItem(label: '唇妆', tip: '豆沙色'),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(
              begin: 0.2,
              end: 0,
              duration: 400.ms,
              curve: Curves.easeOut,
            ),

        const SizedBox(height: 32),

        ElevatedButton(
          onPressed: () {
            context.read<AppState>().saveStyleResult(_result!);
            setState(() {
              _result = null;
              _progress = 0;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            ),
          ),
          child: const Text('保存方案'),
        ),
      ],
    );
  }
}

class _TipItem extends StatelessWidget {
  final String label;
  final String tip;

  const _TipItem({required this.label, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppTheme.textHint)),
        const SizedBox(height: 2),
        Text(tip,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
