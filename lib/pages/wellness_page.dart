import 'package:flutter/material.dart';
import '../data.dart' show articles, softPink, softGold, pink, gold, pinkDark, Article;

class WellnessPage extends StatelessWidget {
  const WellnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildHeader(context),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAffirmationCard(),
                    const SizedBox(height: 20),
                    _buildCategoryPills(),
                    const SizedBox(height: 20),
                    _buildArticleList(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          const Text(
            '\u5065\u5eb7 & \u81ea\u6211\u5173\u7231',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment(-0.5, -0.5),
          end: Alignment(0.5, 0.5),
          colors: [Color(0xFFE8D5D5), Color(0xFFF0E6D6)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '\u6bcf\u4e00\u79cd\u8eab\u6750\u90fd\u503c\u5f97\u88ab\u7231\uff0c\u6bcf\u4e00\u5f20\u8138\u90fd\u6709\u72ec\u7279\u7684\u7f8e\u3002',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '\u60a6\u5df1\u5ba3\u8a00',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPills() {
    const categories = ['\u5168\u90e8', '\u5fc3\u7406', '\u62a4\u80a4', '\u8425\u517b', '\u8fd0\u52a8', '\u517b\u751f'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categories.length, (index) {
          final isActive = index == 0;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isActive
                    ? null
                    : const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF666666),
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildArticleList() {
    return Column(
      children: List.generate(
        articles.length,
        (index) {
          final article = articles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildArticleCard(article, index),
          );
        },
      ),
    );
  }

  static const List<List<Color>> _articleGradients = [
    [Color(0xFFD4A5A5), Color(0xFFE8D5D5)],
    [Color(0xFFC9B99A), Color(0xFFF0E6D6)],
    [Color(0xFFE8D5D5), Color(0xFFD4A5A5)],
    [Color(0xFFB88A8A), Color(0xFFD4A5A5)],
    [Color(0xFFF0E6D6), Color(0xFFC9B99A)],
    [Color(0xFFD4A5A5), Color(0xFFB88A8A)],
  ];

  Widget _buildArticleCard(Article article, int index) {
    final colors = _articleGradients[index % _articleGradients.length];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 110,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.menu_book,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0E6D6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    article.category,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8B7355),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.visibility,
                      size: 14,
                      color: Color(0xFFBBBBBB),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      article.reads,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFBBBBBB),
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
}
