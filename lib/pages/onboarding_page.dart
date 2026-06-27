import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'home_page.dart';

/// 首次启动引导页
/// 1. 性别选择 2. 风格诊断（男女不同题库）3. 保存结果进入首页
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _step = 0; // 0:欢迎 1:性别选择 2+:风格问答 3:结果页
  String? _gender; // 'male' or 'female'
  final Map<int, String> _answers = {};
  int _qIndex = 0;

  // ==================== 女性题库 ====================
  static const _femaleQuestions = [
    {
      'q': '你的肤色偏向？',
      'icon': '🎨',
      'options': ['冷白皮', '暖黄皮', '橄榄皮', '健康小麦色'],
      'tags': ['cool', 'warm', 'olive', 'tan'],
    },
    {
      'q': '你更喜欢哪种穿搭感觉？',
      'icon': '👗',
      'options': ['温柔浪漫', '干练职场', '慵懒法式', '酷飒街头'],
      'tags': ['romantic', 'professional', 'french', 'street'],
    },
    {
      'q': '你的脸型是？',
      'icon': '😊',
      'options': ['鹅蛋脸', '圆脸', '方脸', '心形脸'],
      'tags': ['oval', 'round', 'square', 'heart'],
    },
    {
      'q': '日常妆容偏好？',
      'icon': '💄',
      'options': ['清透裸妆', '元气甜美', '气质红唇', '个性辣妹'],
      'tags': ['natural', 'sweet', 'elegant', 'bold'],
    },
    {
      'q': '你最在意的护肤问题是？',
      'icon': '✨',
      'options': ['干燥缺水', '出油痘痘', '暗沉无光', '细纹松弛'],
      'tags': ['dry', 'oily', 'dull', 'aging'],
    },
  ];

  // ==================== 男性题库 ====================
  static const _maleQuestions = [
    {
      'q': '你的肤色偏向？',
      'icon': '🎨',
      'options': ['冷白皮', '自然肤色', '健康小麦色', '深沉肤色'],
      'tags': ['cool', 'natural', 'tan', 'deep'],
    },
    {
      'q': '你更喜欢哪种穿搭风格？',
      'icon': '👔',
      'options': ['简约干净', '商务正装', '街头潮牌', '日系慵懒'],
      'tags': ['minimal', 'formal', 'street', 'casual'],
    },
    {
      'q': '你的脸型是？',
      'icon': '😊',
      'options': ['长脸', '圆脸', '方脸', '菱形脸'],
      'tags': ['long', 'round', 'square', 'diamond'],
    },
    {
      'q': '日常护肤习惯？',
      'icon': '💧',
      'options': ['精致护肤党', '基础清洁派', '偶尔护个肤', '直男不护肤'],
      'tags': ['skincare', 'basic', 'occasional', 'none'],
    },
    {
      'q': '你最在意的形象问题是？',
      'icon': '✨',
      'options': ['出油脱发', '暗沉疲态', '穿搭土气', '身材管理'],
      'tags': ['oil_hair', 'dull', 'style', 'body'],
    },
  ];

  List<Map<String, Object>> get _currentQuestions =>
      (_gender == 'male' ? _maleQuestions : _femaleQuestions).cast<Map<String, Object>>();

  // 风格结果计算
  String get _styleResult {
    final tags = _answers.values.toList();
    if (_gender == 'male') {
      if (tags.contains('street') || tags.contains('bold')) return '街头潮男';
      if (tags.contains('formal') || tags.contains('elegant')) return '绅士型格';
      if (tags.contains('casual') || tags.contains('french')) return '日系慵懒';
      return '简约干净';
    } else {
      if (tags.contains('street') || tags.contains('bold')) return '酷飒个性';
      if (tags.contains('french') || tags.contains('romantic')) return '法式浪漫';
      if (tags.contains('professional') || tags.contains('elegant')) return '职场知性';
      return '温柔日常';
    }
  }

  // 护肤关键词
  String get _skinKeyword {
    final tags = _answers.values.toList();
    if (_gender == 'female') {
      if (tags.contains('dry')) return '补水保湿';
      if (tags.contains('oily')) return '控油祛痘';
      if (tags.contains('dull')) return '提亮美白';
      if (tags.contains('aging')) return '抗老紧致';
    } else {
      if (tags.contains('oil_hair')) return '控油防脱';
      if (tags.contains('dull')) return '提亮去黄';
      if (tags.contains('basic') || tags.contains('none')) return '基础清洁';
      return '清爽保湿';
    }
    return '平衡护理';
  }

  Future<void> _completeOnboarding() async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.completeOnboarding(
      gender: _gender!,
      styleResult: _styleResult,
      skinKeyword: _skinKeyword,
    );
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: 400.ms,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, 0.08), end: Offset.zero)
                  .animate(anim),
              child: child,
            ),
          ),
          child: _buildCurrentStep(),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    if (_step == 0) return _WelcomeStep(onNext: () => setState(() => _step = 1));
    if (_step == 1) return _GenderStep(
      onSelected: (g) => setState(() {
        _gender = g;
        _step = 2;
        _qIndex = 0;
      }),
    );
    if (_step == 2) {
      final questions = _currentQuestions;
      if (_qIndex < questions.length) {
        return _QuizStep(
          question: questions[_qIndex],
          total: questions.length,
          current: _qIndex + 1,
          onAnswer: (tag) {
            setState(() {
              _answers[_qIndex] = tag;
              if (_qIndex + 1 < questions.length) {
                _qIndex++;
              } else {
                _step = 3;
              }
            });
          },
        );
      }
    }
    if (_step == 3) {
      return _ResultStep(
        gender: _gender!,
        styleResult: _styleResult,
        skinKeyword: _skinKeyword,
        onComplete: _completeOnboarding,
      );
    }
    return const SizedBox.shrink();
  }
}

// ==================== 欢迎页 ====================
class _WelcomeStep extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomeStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(Icons.auto_awesome, size: 56, color: Colors.white),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 40),
          const Text('欢迎来到 钥纪',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
          const SizedBox(height: 16),
          const Text('你的私人个性化变美管家\n让每一次变美都有迹可循',
              style: TextStyle(fontSize: 15, color: AppTheme.textHint, height: 1.8),
              textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
          const SizedBox(height: 60),
          _NextButton(text: '开始探索', onTap: onNext)
              .animate().fadeIn(delay: 600.ms, duration: 500.ms),
        ],
      ),
    );
  }
}

// ==================== 性别选择 ====================
class _GenderStep extends StatelessWidget {
  final ValueChanged<String> onSelected;
  const _GenderStep({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('你是？', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          const Text('我们将根据你的性别推荐专属方案', style: TextStyle(fontSize: 14, color: AppTheme.textHint)),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: _GenderCard(
                  icon: '👩',
                  label: '女生',
                  color: AppTheme.primary,
                  onTap: () => onSelected('female'),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _GenderCard(
                  icon: '👨',
                  label: '男生',
                  color: AppTheme.accent,
                  onTap: () => onSelected('male'),
                ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideX(begin: 0.1, end: 0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _GenderCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 36),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(color: color.withValues(alpha: 0.25), width: 2),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}

// ==================== 风格问答 ====================
class _QuizStep extends StatelessWidget {
  final Map<String, Object> question;
  final int total;
  final int current;
  final ValueChanged<String> onAnswer;
  const _QuizStep({required this.question, required this.total, required this.current, required this.onAnswer});

  @override
  Widget build(BuildContext context) {
    final options = question['options'] as List<String>;
    final tags = question['tags'] as List<String>;
    final icon = question['icon'] as String;
    final q = question['q'] as String;

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // 进度条
          LinearProgressIndicator(
            value: current / total,
            minHeight: 6,
            backgroundColor: AppTheme.borderLight,
            valueColor: AlwaysStoppedAnimation(AppTheme.primary),
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 12),
          Text('$current / $total', style: const TextStyle(fontSize: 13, color: AppTheme.textMute)),
          const SizedBox(height: 32),
          Text(icon, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(q, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 28),
          Expanded(
            child: ListView.separated(
              itemCount: options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _OptionButton(
                text: options[i],
                onTap: () => onAnswer(tags[i]),
              ).animate().fadeIn(duration: 300.ms, delay: (i * 80).ms).slideY(begin: 0.1, end: 0),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _OptionButton({required this.text, required this.onTap});

  @override
  State<_OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<_OptionButton> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: 150.ms,
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(color: AppTheme.borderLight),
          boxShadow: _pressed ? [] : AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Expanded(child: Text(widget.text, style: const TextStyle(fontSize: 15, color: AppTheme.textPrimary))),
            const Icon(Icons.chevron_right, color: AppTheme.textMute, size: 20),
          ],
        ),
      ),
    );
  }
}

// ==================== 结果页 ====================
class _ResultStep extends StatelessWidget {
  final String gender;
  final String styleResult;
  final String skinKeyword;
  final VoidCallback onComplete;
  const _ResultStep({
    required this.gender,
    required this.styleResult,
    required this.skinKeyword,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isFemale = gender == 'female';
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.check, size: 44, color: Colors.white),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 32),
          Text('你的风格是', style: const TextStyle(fontSize: 15, color: AppTheme.textHint)),
          const SizedBox(height: 8),
          Text(styleResult,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isFemale ? Icons.face_retouching_natural : Icons.face,
                    size: 18, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text('护肤重点：$skinKeyword', style: const TextStyle(fontSize: 13, color: AppTheme.primary)),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
          const SizedBox(height: 40),
          Text('已为你定制专属变美方案\n包括妆容、穿搭、护肤、出片圣地推荐',
              style: const TextStyle(fontSize: 14, color: AppTheme.textHint, height: 1.8),
              textAlign: TextAlign.center),
          const SizedBox(height: 48),
          _NextButton(text: '进入我的变美管家', onTap: onComplete)
              .animate().fadeIn(delay: 500.ms, duration: 500.ms),
        ],
      ),
    );
  }
}

// ==================== 通用按钮 ====================
class _NextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const _NextButton({required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primary, AppTheme.accent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
          boxShadow: [
            BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Center(
          child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
      ),
    );
  }
}
