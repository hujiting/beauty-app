import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';

/// 发质分析页
class HairAnalysisPage extends StatefulWidget {
  const HairAnalysisPage({super.key});
  @override
  State<HairAnalysisPage> createState() => _HairAnalysisPageState();
}

class _HairAnalysisPageState extends State<HairAnalysisPage> {
  bool _analyzing = false;
  String? _result;

  Future<void> _startAnalysis() async {
    setState(() { _analyzing = true; _result = null; });
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() {
      _analyzing = false;
      _result = Provider.of<AppState>(context, listen: false).isFemale ? '干性发质' : '油性发质';
    });
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.addHairAnalysis(
      result: _result!,
      summary: '发丝偏干，建议减少烫染频率，使用滋润型洗护产品。',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(title: const Text('发质分析'), backgroundColor: Colors.white, foregroundColor: AppTheme.textPrimary, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('拍照分析发质', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text('拍摄头发照片，AI 分析你的发质类型', style: TextStyle(fontSize: 14, color: AppTheme.textHint)),
          const SizedBox(height: 32),
          Expanded(
            child: Center(
              child: _analyzing
                  ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      CircularProgressIndicator(color: AppTheme.accent),
                      const SizedBox(height: 20),
                      const Text('正在分析发质...', style: TextStyle(fontSize: 15, color: AppTheme.textHint)),
                    ])
                  : _result != null ? _buildResult() : _buildUploadArea(),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _startAnalysis,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(
          color: AppTheme.accent.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.2)),
        ),
        child: Column(children: [
          Icon(Icons.content_cut_outlined, size: 48, color: AppTheme.accent),
          const SizedBox(height: 16),
          Text('点击拍摄 / 上传照片', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.accent)),
          const SizedBox(height: 8),
          const Text('请确保光线充足，拍摄头发自然状态', style: TextStyle(fontSize: 12, color: AppTheme.textMute)),
        ]),
      ),
    );
  }

  Widget _buildResult() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.accent.withValues(alpha: 0.08), AppTheme.primary.withValues(alpha: 0.08)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 64, height: 64, decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.15), shape: BoxShape.circle),
          child: Icon(Icons.content_cut, size: 32, color: AppTheme.accent)),
        const SizedBox(height: 16),
        Text(_result!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        const SizedBox(height: 12),
        const Text('发丝偏干，建议减少烫染频率\n使用滋润型洗护产品', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.6)),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: () => context.go('/hairstyle'), style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusPill))),
            child: const Text('查看发型推荐')),
      ]),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }
}
