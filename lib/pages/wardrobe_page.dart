import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/data_models.dart';
import '../models/ai_engine.dart';

/// 模块三：【智能衣橱】
/// - 电子衣柜：分类统计
/// - 一键搭配：自动生成3种搭配方案
/// - 断舍离建议：闲置衣物提醒
class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('智能衣橱'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textMute,
          indicatorColor: AppTheme.primary,
          tabs: const [
            Tab(text: '电子衣柜'),
            Tab(text: '一键搭配'),
            Tab(text: '断舍离'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _WardrobeTab(),
          _OutfitTab(),
          _CleanOutTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => _AddItemDialog(onAdd: (item) => app.addWardrobeItem(item)),
    );
  }
}

// ==================== 电子衣柜 ====================
class _WardrobeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final wardrobe = app.wardrobe;

    if (wardrobe.isEmpty) {
      return _emptyState('衣橱还是空的', '点击右下角添加你的第一件单品');
    }

    // 分类统计
    final categories = <String, List<WardrobeItem>>{};
    for (final item in wardrobe) {
      categories.putIfAbsent(item.category, () => []).add(item);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (_, ci) {
        final entry = categories.entries.elementAt(ci);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(children: [
                Text(entry.key, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                const SizedBox(width: 8),
                Text('${entry.value.length}件', style: const TextStyle(fontSize: 13, color: AppTheme.textHint)),
              ]),
            ),
            ...entry.value.map((item) => _WardrobeItemCard(item: item).animate().fadeIn(duration: 300.ms)),
          ],
        );
      },
    );
  }

  Widget _emptyState(String title, String subtitle) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.checkroom_outlined, size: 64, color: AppTheme.textMute),
      const SizedBox(height: 16),
      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
      const SizedBox(height: 8),
      Text(subtitle, style: const TextStyle(fontSize: 13, color: AppTheme.textHint)),
    ]));
  }
}

class _WardrobeItemCard extends StatelessWidget {
  final WardrobeItem item;
  const _WardrobeItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.checkroom, color: AppTheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text('${item.subCategory} · ${item.colors.join("/")}', style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
          const SizedBox(height: 4),
          Row(children: [
            Text('穿着${item.wearCount}次', style: const TextStyle(fontSize: 11, color: AppTheme.textMute)),
            const SizedBox(width: 12),
            if (item.idleRate > 0.5)
              Text('闲置率${(item.idleRate * 100).toInt()}%', style: const TextStyle(fontSize: 11, color: Colors.orange)),
          ]),
        ])),
        Column(children: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline, size: 20, color: AppTheme.primary),
            onPressed: () => app.recordWardrobeWorn(item.id),
            tooltip: '记录穿着',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 20, color: Colors.red.withValues(alpha: 0.5)),
            onPressed: () => app.removeWardrobeItem(item.id),
            tooltip: '删除',
          ),
        ]),
      ]),
    );
  }
}

// ==================== 一键搭配 ====================
class _OutfitTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final outfits = MatchingEngine.generateOutfits(wardrobe: app.wardrobe);

    if (outfits.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.auto_fix_high_outlined, size: 64, color: AppTheme.textMute),
        const SizedBox(height: 16),
        const Text('暂无搭配方案', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        const SizedBox(height: 8),
        const Text('添加至少一件上衣和一件下装', style: TextStyle(fontSize: 13, color: AppTheme.textHint)),
      ]));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: outfits.length,
      itemBuilder: (_, i) {
        final outfit = outfits[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text('搭配方案 ${i + 1}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (outfit.matchScore >= 80 ? Colors.green : outfit.matchScore >= 60 ? Colors.orange : Colors.red).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('匹配度 ${outfit.matchScore}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: outfit.matchScore >= 80 ? Colors.green : outfit.matchScore >= 60 ? Colors.orange : Colors.red)),
                ),
              ]),
              const SizedBox(height: 12),
              _outfitRow('上衣', outfit.top.name, outfit.top.colors.join('/')),
              _outfitRow('下装', outfit.bottom.name, outfit.bottom.colors.join('/')),
              if (outfit.outerwear != null) _outfitRow('外套', outfit.outerwear!.name, outfit.outerwear!.colors.join('/')),
              if (outfit.accessory != null) _outfitRow('配饰', outfit.accessory!.name, outfit.accessory!.colors.join('/')),
              const SizedBox(height: 8),
              Text('场合: ${outfit.occasion}', style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms, delay: (i * 100).ms).slideY(begin: 0.05, end: 0);
      },
    );
  }

  Widget _outfitRow(String label, String name, String color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        Container(
          width: 32, alignment: Alignment.center,
          child: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(name, style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary))),
        Text(color, style: const TextStyle(fontSize: 12, color: AppTheme.textMute)),
      ]),
    );
  }
}

// ==================== 断舍离 ====================
class _CleanOutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final toRemove = app.wardrobe.where((w) => w.shouldRemove).toList();
    final idle = app.wardrobe.where((w) => w.idleRate > 0.5 && !w.shouldRemove).toList();

    if (app.wardrobe.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.auto_delete_outlined, size: 64, color: AppTheme.textMute),
        const SizedBox(height: 16),
        const Text('暂无数据', style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
      ]));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (toRemove.isNotEmpty) ...[
          const Text('建议处理', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 4),
          const Text('超过一年未穿或穿着次数极少', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
          const SizedBox(height: 8),
          ...toRemove.map((item) => _CleanOutCard(item: item, urgent: true)),
        ],
        if (idle.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('闲置提醒', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange)),
          const SizedBox(height: 4),
          const Text('闲置率较高，建议增加穿着频率', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
          const SizedBox(height: 8),
          ...idle.map((item) => _CleanOutCard(item: item, urgent: false)),
        ],
        if (toRemove.isEmpty && idle.isEmpty) ...[
          const SizedBox(height: 80),
          Center(child: Column(children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text('衣橱状况良好', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            const SizedBox(height: 8),
            const Text('没有需要断舍离的衣物', style: TextStyle(fontSize: 13, color: AppTheme.textHint)),
          ])),
        ],
      ],
    );
  }
}

class _CleanOutCard extends StatelessWidget {
  final WardrobeItem item;
  final bool urgent;
  const _CleanOutCard({required this.item, required this.urgent});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: (urgent ? Colors.red : Colors.orange).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: (urgent ? Colors.red : Colors.orange).withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: (urgent ? Colors.red : Colors.orange).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(urgent ? Icons.delete : Icons.warning_amber, color: urgent ? Colors.red : Colors.orange, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text('穿着${item.wearCount}次 · 闲置率${(item.idleRate * 100).toInt()}%', style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
        ])),
        TextButton(
          onPressed: () => app.removeWardrobeItem(item.id),
          child: Text('处理', style: TextStyle(fontSize: 13, color: urgent ? Colors.red : Colors.orange)),
        ),
      ]),
    );
  }
}

// ==================== 添加单品弹窗 ====================
class _AddItemDialog extends StatefulWidget {
  final Function(WardrobeItem) onAdd;
  const _AddItemDialog({required this.onAdd});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final _nameCtrl = TextEditingController();
  String _category = '上衣';
  String _subCategory = 'T恤';
  String _color = '白色';
  String _material = '棉';

  final _categories = {
    '上衣': ['T恤', '衬衫', '针织衫', '卫衣'],
    '下装': ['牛仔裤', '休闲裤', '半裙', '短裤'],
    '外套': ['夹克', '大衣', '西装', '风衣'],
    '配饰': ['帽子', '围巾', '包包', '首饰'],
    '鞋': ['运动鞋', '靴子', '高跟鞋', '平底鞋'],
  };

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加衣物', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: '衣物名称', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(labelText: '品类', border: OutlineInputBorder()),
            items: _categories.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() { _category = v!; _subCategory = _categories[v]!.first; }),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _subCategory,
            decoration: const InputDecoration(labelText: '子品类', border: OutlineInputBorder()),
            items: _categories[_category]!.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _subCategory = v!),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _color,
            decoration: const InputDecoration(labelText: '颜色', border: OutlineInputBorder()),
            items: ['白色', '黑色', '蓝色', '红色', '绿色', '粉色', '灰色', '卡其色']
                .map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _color = v!),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _material,
            decoration: const InputDecoration(labelText: '材质', border: OutlineInputBorder()),
            items: ['棉', '麻', '丝', '羊毛', '聚酯', '牛仔']
                .map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _material = v!),
          ),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
        ElevatedButton(
          onPressed: () {
            if (_nameCtrl.text.isEmpty) return;
            widget.onAdd(WardrobeItem(
              id: 'w_${DateTime.now().millisecondsSinceEpoch}',
              name: _nameCtrl.text,
              category: _category,
              subCategory: _subCategory,
              colors: [_color],
              material: _material,
              addedDate: DateTime.now(),
              tags: ['休闲'],
            ));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
          child: const Text('添加'),
        ),
      ],
    );
  }
}
