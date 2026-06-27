import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../providers/app_state.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  final _picker = ImagePicker();
  List<File> _capturedImages = [];
  bool _isCaptureing = false;

  Future<void> _pickFromCamera() async {
    setState(() => _isCaptureing = true);
    try {
      final img = await _picker.pickImage(source: ImageSource.camera);
      if (img != null) {
        setState(() => _capturedImages.insert(0, File(img.path)));
        await context.read<AppState>().addCapture(img.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('无法打开相机：$e')));
      }
    }
    setState(() => _isCaptureing = false);
  }

  Future<void> _pickFromGallery() async {
    try {
      final imgs = await _picker.pickMultiImage();
      if (imgs.isNotEmpty) {
        for (final img in imgs) {
          setState(() => _capturedImages.insert(0, File(img.path)));
          await context.read<AppState>().addCapture(img.path);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('无法打开相册：$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('拍照圣地'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 拍照按钮区
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // 拍照
                  Expanded(
                    child: _CaptureButton(
                      icon: Icons.camera_alt,
                      label: '拍照',
                      onTap: _pickFromCamera,
                      loading: _isCaptureing,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 相册
                  Expanded(
                    child: _CaptureButton(
                      icon: Icons.photo_library_outlined,
                      label: '相册',
                      onTap: _pickFromGallery,
                    ),
                  ),
                ],
              ),
            ),

            // 提示语
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '拍照或上传照片，AI 将为你分析最适合的妆容风格',
                style: TextStyle(fontSize: 13, color: AppTheme.textHint),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            // 照片网格
            Expanded(
              child: _capturedImages.isEmpty
                  ? _buildEmptyState()
                  : _buildPhotoGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt_outlined,
          size: 64,
          color: AppTheme.textMute.withOpacity(0.5),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              duration: 2000.ms,
              begin: const Offset(0.95, 0.95),
              end: const Offset(1.05, 1.05),
            ),
        const SizedBox(height: 16),
        const Text('还没有照片',
            style: TextStyle(fontSize: 16, color: AppTheme.textHint)),
        const SizedBox(height: 4),
        const Text('点击上方按钮开始拍照',
            style: TextStyle(fontSize: 13, color: AppTheme.textMute)),
      ],
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: _capturedImages.length,
      itemBuilder: (context, i) {
        final file = _capturedImages[i];
        return GestureDetector(
          onTap: () => _showImagePreview(file),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
            child: Image.file(file, fit: BoxFit.cover),
          ).animate().fadeIn(
                duration: 300.ms,
                delay: (i * 50).ms,
              ),
        );
      },
    );
  }

  void _showImagePreview(File file) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              child: Image.file(file, fit: BoxFit.contain),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              bottom: 16,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/makeup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  ),
                ),
                child: const Text('用此照片分析妆容'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 拍照/相册按钮
class _CaptureButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool loading;

  const _CaptureButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primary, AppTheme.accent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          boxShadow: AppTheme.cardShadow,
        ),
        child: loading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Column(
                children: [
                  Icon(icon, size: 32, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(label,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ],
              ),
      ).animate().fadeIn(duration: 400.ms).scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.0, 1.0),
            duration: 300.ms,
            curve: Curves.easeOut,
          ),
    );
  }
}
