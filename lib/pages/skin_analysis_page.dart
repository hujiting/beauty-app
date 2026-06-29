import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/ai_engine.dart';

/// 肤质分析页 — AI拍照分析皮肤状态
class SkinAnalysisPage extends StatefulWidget {
  const SkinAnalysisPage({super.key});

  @override
  State<SkinAnalysisPage> createState() => _SkinAnalysisPageState();
}

class _SkinAnalysisPageState extends State<SkinAnalysisPage> {
  bool _analyzing = false;
  SkinAnalysisResult? _result;

  Future<void> _startAnalysis() async {
    setState(() => _analyzing = true);
    await Future.delayed(const Duration(seconds: 3));
    final result = DiagnosticEngine.analyzeSkin(imagePath: '');
    final app = Provider.of<AppState>(context, listen: false);
    await app.addSkinAnalysis(result);
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
        title: const Text('肤质分析'),
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
              color: AppTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.face_retouching_natural, size: 56, color: AppTheme.primary),
          ),
          const SizedBox(height: 24),
          const Text('AI 肤质检测', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text('上传面部照片，AI分析你的皮肤状态\n水分、油分、毛孔、色斑等多维度评估',
              style: TextStyle(fontSize: 14, color: AppTheme.textHint, height: 1.6),
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Row(children: [
            Expanded(child: ElevatedButton.icon(
              onPressed: _startAnalysis,
              icon: const Icon(Icons.camera_alt),
              label: const Text('拍照分析'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusPill)),
              ),
            )),
          ]),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildAnalyzing() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(
        width: 60, height: 60,
        child: CircularProgressIndicator(color: AppTheme.primary, strokeWidth: 3),
      ),
      const SizedBox(height: 20),
      const Text('AI 正在分析你的肌肤...', style: TextStyle(fontSize: 15, color: AppTheme.textSecondary)),
      const SizedBox(height: 8),
      const Text('检测水分·油分·毛孔·色斑', style: TextStyle(fontSize: 13, color: AppTheme.textHint)),
    ]));
  }

  Widget _buildResult(BuildContext context) {
    final r = _result!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 总体评分
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primary.withValues(alpha: 0.08), AppTheme.accent.withValues(alpha: 0.05)]),
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
            ),
            child: Column(children: [
              const Text('你的肤质', style: TextStyle(fontSize: 14, color: AppTheme.textHint)),
              const SizedBox(height: 4),
              Text(r.type, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primary)),
              const SizedBox(height: 12),
              Text(r.summary, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.6), textAlign: TextAlign.center),
            ]),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 20),
          // 多维度评分
          const Text('多维度评估', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          _scoreBar('水分', r.hydration, Colors.blue),
          _scoreBar('油分', r.oiliness, Colors.orange),
          _scoreBar('平滑度', r.smoothness, Colors.green),
          _scoreBar('敏感度', r.sensitivity, Colors.red),
          _scoreBar('色斑', r.darkSpots, Colors.purple),
          _scoreBar('毛孔', r.pores, Colors.teal),
          const SizedBox(height: 20),
          // 护肤建议
          const Text('护肤建议', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
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
              const Icon(Icons.check_circle, size: 18, color: AppTheme.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(rec, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
            ]),
          )),
          const SizedBox(height: 20),
          // 操作按钮
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => setState(() => _result = null),
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48), side: const BorderSide(color: AppTheme.borderLight)),
              child: const Text('重新检测'),
            )),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(
              onPressed: () => context.push('/skincare'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white, minimumSize: const Size(0, 48)),
              child: const Text('查看护肤方案'),
            )),
          ]),
        ],
      ),
    );
  }

  Widget _scoreBar(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        SizedBox(width: 60, child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
        const SizedBox(width: 12),
        Expanded(child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        )),
        const SizedBox(width: 8),
        SizedBox(width: 32, child: Text('$value', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color), textAlign: TextAlign.right)),
      ]),
    );
  }
}
