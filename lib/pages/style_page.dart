import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../providers/app_state.dart';

class StylePage extends StatefulWidget {
  const StylePage({super.key});

  @override
  State<StylePage> createState() => _StylePageState();
}

class _StylePageState extends State<StylePage> {
  int _currentQ = 0;
  final _answers = <int>[];
  bool _showResult = false;
  String _resultStyle = '';

  final _questions = [
    _Question(
      q: '你更喜欢哪种穿搭风格？',
      options: ['优雅知性', '休闲运动', '街头潮流', '甜美可爱'],
    ),
    _Question(
      q: '日常出门你更看重什么？',
      options: ['舒适度', '时尚感', '实用性', '个性化'],
    ),
    _Question(
      q: '你偏爱的色彩是？',
      options: ['莫兰迪色系', '黑白灰经典', '明亮彩色', '柔和粉嫩'],
    ),
    _Question(
      q: '如果选择一件单品，你会选？',
      options: ['丝绸衬衫', '牛仔外套', '设计感卫衣', '蕾丝连衣裙'],
    ),
  ];

  final _styleMap = {
    0: '优雅知性风',
    1: '休闲运动风',
    2: '街头潮流风',
    3: '甜美可爱风',
  };

  void _selectAnswer(int optionIdx) {
    setState(() {
      if (_answers.length <= _currentQ) {
        _answers.add(optionIdx);
      } else {
        _answers[_currentQ] = optionIdx;
      }
    });
  }

  void _next() {
    if (_currentQ < _questions.length - 1) {
      setState(() => _currentQ++);
    } else {
      _calculateResult();
    }
  }

  void _calculateResult() {
    // 简单统计：取出现次数最多的 option index
    final freq = <int, int>{};
    for (final a in _answers) {
      freq[a] = (freq[a] ?? 0) + 1;
    }
    final maxEntry = freq.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );
    setState(() {
      _resultStyle = _styleMap[maxEntry.key] ?? '优雅知性风';
      _showResult = true;
    });
    context.read<AppState>().saveStyleResult(_resultStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('风格诊断'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_showResult) {
              setState(() {
                _showResult = false;
                _currentQ = 0;
                _answers.clear();
              });
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _showResult
              ? _buildResult()
              : _buildQuiz(),
        ),
      ),
    );
  }

  Widget _buildQuiz() {
    final q = _questions[_currentQ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 进度条
        LinearProgressIndicator(
          value: (_currentQ + 1) / _questions.length,
          minHeight: 6,
          backgroundColor: AppTheme.primary.withOpacity(0.1),
          valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
        ).animate().fadeIn(duration: 300.ms),

        const SizedBox(height: 24),

        // 题号
        Text('第 ${_currentQ + 1}/${_questions.length} 题',
            style: const TextStyle(fontSize: 13, color: AppTheme.textHint)),

        const SizedBox(height: 8),

        // 问题
        Text(q.q,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary)),

        const SizedBox(height: 32),

        // 选项
        Expanded(
          child: ListView.separated(
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: q.options.length,
            itemBuilder: (context, i) {
              final selected = _answers.length > _currentQ &&
                  _answers[_currentQ] == i;
              return GestureDetector(
                onTap: () => _selectAnswer(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: selected ? AppTheme.primary : Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    border: Border.all(
                      color: selected
                          ? AppTheme.primary
                          : AppTheme.borderLight,
                    ),
                    boxShadow: selected ? AppTheme.cardShadow : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected
                              ? Colors.white.withOpacity(0.3)
                              : AppTheme.primary.withOpacity(0.1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          String.fromCharCode(65 + i), // A, B, C, D
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: selected ? Colors.white : AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          q.options[i],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: selected
                                ? Colors.white
                                : AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(
                    duration: 300.ms,
                    delay: (i * 80).ms,
                  ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        // 下一题 / 查看结果 按钮
        ElevatedButton(
          onPressed: _answers.length > _currentQ ? _next : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            ),
          ),
          child: Text(
              _currentQ < _questions.length - 1 ? '下一题' : '查看结果'),
        ),
      ],
    );
  }

  Widget _buildResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.accent],
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.auto_awesome,
              size: 48, color: Colors.white),
        ).animate().scale(
              duration: 600.ms,
              curve: Curves.elasticOut,
            ),

        const SizedBox(height: 28),

        const Text('你的风格是',
            style: TextStyle(fontSize: 16, color: AppTheme.textHint)),

        const SizedBox(height: 8),

        Text(_resultStyle,
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary)),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            children: [
              const Text('风格特征',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                _getStyleDesc(_resultStyle),
                style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.6),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(
              begin: 0.2,
              end: 0,
              duration: 400.ms,
            ),

        const SizedBox(height: 32),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showResult = false;
                    _currentQ = 0;
                    _answers.clear();
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textPrimary,
                  side: const BorderSide(color: AppTheme.borderLight),
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  ),
                ),
                child: const Text('重新测试'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  ),
                ),
                child: const Text('返回首页'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getStyleDesc(String style) {
    switch (style) {
      case '优雅知性风':
        return '你适合简约高级的穿搭，\n注重面料质感和剪裁，\n感性而内敛，散发知性魅力。';
      case '休闲运动风':
        return '你适合舒适自在的穿搭，\n运动元素和休闲单品是你的首选，\n活力满满，随性自然。';
      case '街头潮流风':
        return '你适合个性鲜明的穿搭，\n喜欢尝试新潮单品和混搭，\n敢于表达自我，引领潮流。';
      case '甜美可爱风':
        return '你适合温柔甜美的穿搭，\n蕾丝、蝴蝶结等少女元素很适合你，\n温柔可人，让人心生好感。';
      default:
        return '专属你的风格正在生成中...';
    }
  }
}

class _Question {
  final String q;
  final List<String> options;
  const _Question({required this.q, required this.options});
}
