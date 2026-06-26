import 'dart:async';
import 'package:flutter/material.dart';
import '../data.dart';

// ---------------------------------------------------------------------------
// MakeupPage — AI 脸型分析 (Entry view + Result view)
// ---------------------------------------------------------------------------

class MakeupPage extends StatefulWidget {
  const MakeupPage({super.key});

  @override
  State<MakeupPage> createState() => _MakeupPageState();
}

class _MakeupPageState extends State<MakeupPage> {
  bool _showResult = false;
  double _progress = 0;
  bool _analyzing = false;

  // ---------------------------------------------------------------------------
  // Analysis Timer
  // ---------------------------------------------------------------------------

  void _startAnalysis() {
    setState(() {
      _analyzing = true;
      _progress = 0;
    });

    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _progress += 1;
      });
      if (_progress >= 100) {
        timer.cancel();
        setState(() {
          _analyzing = false;
          _showResult = true;
        });
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: SafeArea(
        child: _showResult ? _buildResultView() : _buildEntryView(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ENTRY VIEW
  // ---------------------------------------------------------------------------

  Widget _buildEntryView() {
    return CustomScrollView(
      slivers: [
        // ---- App Bar ----
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              'AI 妆容',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ---- Top Analysis Card ----
              _buildAnalysisCard(),
              const SizedBox(height: 24),

              // ---- 妆容教程 Section Header ----
              _buildSectionHeader('妆容教程'),
              const SizedBox(height: 12),
            ]),
          ),
        ),

        // ---- Tutorials Horizontal List ----
        SliverToBoxAdapter(
          child: SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: tutorials.length,
              itemBuilder: (context, index) =>
                  _buildTutorialCard(tutorials[index]),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 12),
              // ---- 推荐博主 Section Header ----
              _buildSectionHeader('推荐博主'),
              const SizedBox(height: 12),
              // ---- Bloggers Vertical List ----
              ...bloggers.map((b) => _buildBloggerItem(b)),
            ]),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Analysis Card (gradient #E8D5D5 → white)
  // ---------------------------------------------------------------------------

  Widget _buildAnalysisCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE8D5D5), Colors.white],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Sparkles icon in circle
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: softPink,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome, color: pink, size: 28),
          ),
          const SizedBox(height: 14),
          const Text(
            'AI 脸型分析',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '上传一张照片，AI 将为你分析脸型并推荐最适合的妆容方案',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF999999),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // Buttons or progress bar
          if (_analyzing && !_showResult) ...[
            _buildProgressBar(),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: _buildAnalysisButton(
                    icon: Icons.camera_alt,
                    label: '拍照分析',
                    filled: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAnalysisButton(
                    icon: Icons.upload,
                    label: '上传照片',
                    filled: false,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Progress Bar
  // ---------------------------------------------------------------------------

  Widget _buildProgressBar() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: _progress / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(pink),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '正在分析中… ${_progress.toInt()}%',
          style: TextStyle(fontSize: 13, color: pink),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Analysis Buttons
  // ---------------------------------------------------------------------------

  Widget _buildAnalysisButton({
    required IconData icon,
    required String label,
    required bool filled,
  }) {
    return GestureDetector(
      onTap: _startAnalysis,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: filled ? pink : Colors.white,
          borderRadius: BorderRadius.circular(23),
          border: filled ? null : Border.all(color: pink, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: filled ? Colors.white : pink),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: filled ? Colors.white : pink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 妆容教程 — Tutorial Card
  // ---------------------------------------------------------------------------

  Widget _buildTutorialCard(Tutorial tutorial) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient top (110h) with play icon
          Container(
            height: 110,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [pink, gold],
              ),
            ),
            child: Center(
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),

          // Title + level + minutes
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tutorial.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: softGold,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tutorial.level,
                        style: TextStyle(fontSize: 10, color: pinkDark),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.schedule,
                      size: 12,
                      color: Color(0xFF999999),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      tutorial.duration,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 推荐博主 — Blogger Item
  // ---------------------------------------------------------------------------

  Widget _buildBloggerItem(Blogger blogger) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar circle (44, gradient)
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [pink, gold],
              ),
            ),
            child: Center(
              child: Text(
                blogger.name.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name + fans + tag
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blogger.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 13,
                      color: Color(0xFF999999),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${blogger.fans}粉丝',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: softPink,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        blogger.style,
                        style: TextStyle(fontSize: 10, color: pinkDark),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 关注 button
          GestureDetector(
            onTap: () {},
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: pink,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                '关注',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section Header
  // ---------------------------------------------------------------------------

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const Icon(
          Icons.chevron_right,
          color: Color(0xFF999999),
          size: 20,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // RESULT VIEW
  // ---------------------------------------------------------------------------

  Widget _buildResultView() {
    return CustomScrollView(
      slivers: [
        // ---- Back arrow ----
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
              onPressed: () {
                setState(() {
                  _showResult = false;
                  _analyzing = false;
                  _progress = 0;
                });
              },
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ---- Face Type Card ----
              _buildFaceTypeCard(),
              const SizedBox(height: 24),

              // ---- 推荐妆容 Section ----
              _buildSectionHeader('推荐妆容'),
              const SizedBox(height: 12),
              ...List.generate(faceMakeupRecs.length, (i) {
                return _buildMakeupRecCard(i + 1, faceMakeupRecs[i]);
              }),
              const SizedBox(height: 24),

              // ---- 变美小贴士 Section ----
              _buildSectionHeader('变美小贴士'),
              const SizedBox(height: 12),
              ...faceTips.map((tip) => _buildTipItem(tip)),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Face Type Card
  // ---------------------------------------------------------------------------

  Widget _buildFaceTypeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [pink, gold],
        ),
        boxShadow: [
          BoxShadow(
            color: pink.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // 🥚 emoji in circle
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🥚', style: TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '鹅蛋脸',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '脸型比例匀称，线条流畅',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 16),
          // Feature chips from faceFeatures
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: faceFeatures
                .map(
                  (feature) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      feature,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 推荐妆容 — Numbered Card
  // ---------------------------------------------------------------------------

  Widget _buildMakeupRecCard(int index, FaceMakeup rec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Number circle
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [pink, gold],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rec.advice,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 变美小贴士 — Tip Item
  // ---------------------------------------------------------------------------

  Widget _buildTipItem(String tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: pink, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
