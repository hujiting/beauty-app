import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/ai_engine.dart';

/// 发质分析页 — AI拍照分析头发状态
class HairAnalysisPage extends StatefulWidget {
  const HairAnalysisPage({super.key});

  @override
  State<HairAnalysisPage> createState() => _HairAnalysisPageState();
}

class _HairAnalysisPageState extends State<HairAnalysisPage> {
  bool _analyzing = false;
  HairAnalysisResult? _result;

  Future<void> _startAnalysis() async {
    setState(() => _analyzing = true);
    await Future.delayed(const Duration(seconds: 3));
    final result = DiagnosticEngine.analyzeHair(imagePath: '');
    final app = Provider.of<AppState>(context, listen: false);
    await app.addHairAnalysis(result);
    if (!mounted) return;
    setState(() {
      _result = result;
      _analyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('发质分析'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: SafeArea(
        child: _analyzing
            ? _buildAnalyzing()
            : _result != null
                ? _buildResult(context)
                : _buildUpload(),
      ),
    );
  }

  Widget _buildUpload() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.cut, size: 56, color: AppTheme.accent),
          ),
          const SizedBox(height: 24),
          const Text('AI 发质检测', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text('上传头发照片，AI分析你的发质状态\n发质类型、受损程度、头皮健康度',
              style: TextStyle(fontSize: 14, color: AppTheme.textHint, height: 1.6),
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _startAnalysis,
            icon: const Icon(Icons.camera_alt),
            label: const Text('拍照分析'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusPill)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildAnalyzing() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(
        width: 60, height: 60,
        child: CircularProgressIndicator(color: AppTheme.accent, strokeWidth: 3),
      ),
      const SizedBox(height: 20),
      const Text('AI 正在分析你的发质...', style: TextStyle(fontSize: 15, color: AppTheme.textSecondary)),
    ]));
  }

  Widget _buildResult(BuildContext context) {
    final r = _result!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.accent.withValues(alpha: 0.08), AppTheme.primary.withValues(alpha: 0.05)]),
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
            ),
            child: Column(children: [
              const Text('你的发质', style: TextStyle(fontSize: 14, color: AppTheme.textHint)),
              const SizedBox(height: 4),
              Text(r.type, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.accent)),
              const SizedBox(height: 12),
              Text(r.summary, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.6), textAlign: TextAlign.center),
            ]),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 20),
          // 详细数据
          _detailRow('受损程度', r.damage),
          _detailRow('头皮状况', r.scalpCondition),
          _detailRow('发量密度', r.hairDensity),
          const SizedBox(height: 20),
          // 护发建议
          const Text('护发建议', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          ...r.recommendations.map((rec) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(children: [
              const Icon(Icons.check_circle, size: 18, color: AppTheme.accent),
              const SizedBox(width: 8),
              Expanded(child: Text(rec, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
            ]),
          )),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => setState(() => _result = null),
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48), side: const BorderSide(color: AppTheme.borderLight)),
              child: const Text('重新检测'),
            )),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(
              onPressed: () => context.push('/hairstyle'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, foregroundColor: Colors.white, minimumSize: const Size(0, 48)),
              child: const Text('推荐发型'),
            )),
          ]),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(children: [
        Text(label, style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
