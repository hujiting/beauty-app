import 'package:flutter/material.dart';
import '../data.dart';

class StylePage extends StatefulWidget {
  const StylePage({super.key});

  @override
  State<StylePage> createState() => _StylePageState();
}

class _StylePageState extends State<StylePage> {
  String _view = 'entry';
  int _quizStep = 0;
  List<String> _answers = [];
  StyleResult? _result;

  @override
  Widget build(BuildContext context) {
    if (_view == 'quiz') return _buildQuizView();
    if (_view == 'result') return _buildResultView();
    return _buildEntryView();
  }

  // ===== Entry View =====
  Widget _buildEntryView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF0E6D6), Colors.white],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: const Icon(Icons.emoji_events_outlined, size: 32, color: Color(0xFFB8860B)),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '发现你的专属风格',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF222222)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '完成测试，解锁最适合你的穿搭方案',
                      style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _view = 'quiz';
                            _quizStep = 0;
                            _answers = [];
                            _result = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          elevation: 0,
                        ),
                        child: const Text('开始风格测试', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 风格探索 section
              const Text(
                '风格探索',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF222222)),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _buildStyleCard('极简知性', [const Color(0xFFE8E8E8), const Color(0xFFF8F8F8)]),
                  _buildStyleCard('法式浪漫', [const Color(0xFFFFD6E0), const Color(0xFFFFF0F3)]),
                  _buildStyleCard('酷飒街头', [const Color(0xFFD8D8D8), const Color(0xFFF0F0F0)]),
                  _buildStyleCard('优雅气质', [const Color(0xFFE8D5A8), const Color(0xFFFDF6E3)]),
                ],
              ),

              const SizedBox(height: 28),

              // 体态优化 section
              const Text(
                '体态优化',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF222222)),
              ),
              const SizedBox(height: 12),
              _buildPostureCard('改善圆肩驼背', '每天10分钟挺拔身姿', '体态'),
              _buildPostureCard('优化站姿走姿', '走出自信优雅', '仪态'),
              _buildPostureCard('颈部线条塑造', '天鹅颈养成计划', '塑形'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyleCard(String title, List<Color> gradient) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradient),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
      ),
    );
  }

  Widget _buildPostureCard(String title, String subtitle, String tag) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAF8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEA)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF222222))),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF999999))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F0E8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(tag, style: const TextStyle(fontSize: 11, color: Color(0xFFB8860B))),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC)),
        ],
      ),
    );
  }

  // ===== Quiz View =====
  Widget _buildQuizView() {
    final q = quizQuestions[_quizStep];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _view = 'entry'),
                    child: const Icon(Icons.close, size: 24, color: Color(0xFF333333)),
                  ),
                  const Spacer(),
                  const Text('风格测试', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF222222))),
                  const Spacer(),
                  const SizedBox(width: 24),
                ],
              ),

              const SizedBox(height: 32),

              // Progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  return Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < _quizStep ? Colors.black : const Color(0xFFE0E0E0),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Question
              Text(q.question, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF222222))),

              const SizedBox(height: 24),

              // Options
              ...q.options.map((opt) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _selectAnswer(opt.style),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF333333),
                      side: const BorderSide(color: Color(0xFFE8E8E4)),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(opt.text, style: const TextStyle(fontSize: 15)),
                  ),
                ),
              )),

              const Spacer(),

              // Counter
              Center(
                child: Text(
                  '${_quizStep + 1} / 4',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectAnswer(String answer) {
    setState(() {
      _answers.add(answer);
      _quizStep++;
      if (_quizStep >= 4) {
        _calculateResult();
        _view = 'result';
      }
    });
  }

  void _calculateResult() {
    final counts = <String, int>{};
    for (final a in _answers) {
      counts[a] = (counts[a] ?? 0) + 1;
    }
    String most = counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    _result = styleResults[most] ?? styleResults.values.first;
  }

  // ===== Result View =====
  Widget _buildResultView() {
    final r = _result!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _view = 'entry'),
                    child: const Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF333333)),
                  ),
                  const SizedBox(width: 12),
                  const Text('风格诊断结果', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF222222))),
                ],
              ),

              const SizedBox(height: 20),

              // Style card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF0E6D6), Colors.white],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.emoji_events_outlined, size: 40, color: Color(0xFFB8860B)),
                    const SizedBox(height: 12),
                    Text(
                      '你的风格：${r.name}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF222222)),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [r.name].map((k) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(k, style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
                      )).toList(),
                    ),
                    const SizedBox(height: 12),
                    Text(r.description, style: const TextStyle(fontSize: 13, color: Color(0xFF666666), height: 1.6), textAlign: TextAlign.center),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 推荐色彩
              const Text('推荐色彩', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF222222))),
              const SizedBox(height: 12),
              Row(
                children: r.colors.map((c) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Container(
                          height: 48,
                          decoration: BoxDecoration(color: c.color, borderRadius: BorderRadius.circular(12)),
                        ),
                        const SizedBox(height: 6),
                        Text(c.name, style: const TextStyle(fontSize: 11, color: Color(0xFF666666))),
                      ],
                    ),
                  ),
                )).toList(),
              ),

              const SizedBox(height: 24),

              // 推荐单品
              const Text('推荐单品', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF222222))),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: r.items.map((item) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAF8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFEEEEEA)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.checkroom, size: 28, color: Color(0xFFB8860B)),
                      const SizedBox(height: 8),
                      Text(item, style: const TextStyle(fontSize: 13, color: Color(0xFF333333))),
                    ],
                  ),
                )).toList(),
              ),

              const SizedBox(height: 24),

              // 整体造型建议
              const Text('整体造型建议', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF222222))),
              const SizedBox(height: 12),
              _buildAdviceRow(Icons.diamond_outlined, '配饰', r.accessories),
              _buildAdviceRow(Icons.content_cut, '发型', r.hair),
              _buildAdviceRow(Icons.local_florist_outlined, '美甲', r.nails),

              const SizedBox(height: 24),

              // 重新测试
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _view = 'entry';
                      _quizStep = 0;
                      _answers = [];
                      _result = null;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE8E8E4)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('重新测试', style: TextStyle(fontSize: 15, color: Color(0xFF333333))),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdviceRow(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAF8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEA)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFFB8860B)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF222222))),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF999999))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
