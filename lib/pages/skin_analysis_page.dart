import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/common.dart';

/// 肤质分析页
class SkinAnalysisPage extends StatefulWidget {
  const SkinAnalysisPage({super.key});
  @override
  State<SkinAnalysisPage> createState() => _SkinAnalysisPageState();
}

class _SkinAnalysisPageState extends State<SkinAnalysisPage> {
  bool _analyzing = false;
  String? _result;

  Future<void> _startAnalysis() async {
    setState(() { _analyzing = true; _result = null; });
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() {
      _analyzing = false;
      _result = '混合性皮肤';
    });
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.addSkinAnalysis(
      result: _result!,
      summary: 'T区偏油，U区偏干，建议分区护理，重点关注水油平衡。',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFemale = Provider.of<AppState>(context).isFemale;
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(title: const Text('肤质分析'), backgroundColor: Colors.white, foregroundColor: AppTheme.textPrimary, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('拍照分析肤质', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 8),
            Text(isFemale ? '拍摄素颜正面照，AI 分析你的肤质类型' : '拍摄素颜正面照，AI 分析你的肤质类型',
                style: const TextStyle(fontSize: 14, color: AppTheme.textHint)),
            const SizedBox(height: 32),
            Expanded(
              child: Center(
                child: _analyzing
                    ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        CircularProgressIndicator(color: AppTheme.primary),
                        const SizedBox(height: 20),
                        const Text('正在分析肤质...', style: TextStyle(fontSize: 15, color: AppTheme.textHint)),
                      ])
                    : _result != null
                        ? _buildResult()
                        : _buildUploadArea(),
              ),
            ),
          ],
        ),
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
          color: AppTheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(Icons.camera_alt_outlined, size: 48, color: AppTheme.primary),
            const SizedBox(height: 16),
            Text('点击拍摄 / 上传照片', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.primary)),
            const SizedBox(height: 8),
            const Text('请确保光线充足，素颜拍摄', style: TextStyle(fontSize: 12, color: AppTheme.textMute)),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primary.withValues(alpha: 0.08), AppTheme.accent.withValues(alpha: 0.08)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 64, height: 64, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
          child: Icon(Icons.face_retouching_natural, size: 32, color: AppTheme.primary)),
        const SizedBox(height: 16),
        Text(_result!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        const SizedBox(height: 12),
        const Text('T区偏油，U区偏干\n建议分区护理，重点关注水油平衡', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.6)),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: () => context.go('/skincare'), style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusPill))),
            child: const Text('查看护肤方案')),
      ]),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }
}
