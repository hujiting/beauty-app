// ============================================================
// 第二层：智能中枢 — 诊断引擎 + 匹配算法
// ============================================================

import 'data_models.dart';

/// ==================== 诊断引擎 ====================

class DiagnosticEngine {
  /// AI 测脸 — 通过照片分析面部特征
  /// 返回 FaceProfile（当前为模拟逻辑，后续接入真实AI）
  static FaceProfile analyzeFace({
    required String imagePath,
    String? gender,
  }) {
    // TODO: 接入计算机视觉 API（如腾讯云人脸分析 / Face++）
    // 当前返回模拟结果
    return FaceProfile(
      faceShape: '鹅蛋脸',
      skinTone: '暖黄皮',
      skinUndertone: '暖调',
      eyeShape: '内双',
      lipShape: '标准',
      pupilColor: '深棕',
    );
  }

  /// AI 测身材 — 通过照片分析身体数据
  static BodyProfile analyzeBody({
    required String imagePath,
  }) {
    // TODO: 接入人体姿态识别 API
    return BodyProfile(
      height: 165,
      weight: 52,
      shoulderWidth: 38,
      legRatio: '中腿',
    );
  }

  /// 色彩季型测试
  static String colorSeasonTest(FaceProfile face) {
    return face.colorSeason;
  }

  /// 肤质分析 — 通过照片分析皮肤状态
  static SkinAnalysisResult analyzeSkin({
    required String imagePath,
  }) {
    // TODO: 接入皮肤检测 AI API
    return SkinAnalysisResult(
      type: '混合偏干',
      hydration: 42,
      oiliness: 55,
      smoothness: 68,
      sensitivity: 35,
      darkSpots: 15,
      pores: 40,
      summary: 'T区偏油，两颊偏干，整体水分不足，建议加强补水和分区护理。',
      recommendations: [
        '使用氨基酸洁面乳，避免过度清洁',
        'T区使用控油精华，两颊使用保湿面霜',
        '每周2次补水面膜',
        '注意防晒，预防色斑',
      ],
    );
  }

  /// 发质分析 — 通过照片分析头发状态
  static HairAnalysisResult analyzeHair({
    required String imagePath,
  }) {
    return HairAnalysisResult(
      type: '细软偏油',
      damage: '轻度受损',
      scalpCondition: '偏油',
      hairDensity: '正常',
      summary: '发质细软，头皮偏油，发尾有轻度受损，建议控油同时注意发尾修护。',
      recommendations: [
        '选择无硅油控油洗发水',
        '发尾使用护发精油',
        '减少烫染频率',
        '每周1次深层修护发膜',
      ],
    );
  }
}

/// 肤质分析结果
class SkinAnalysisResult {
  final String type;
  final int hydration;    // 水分 0-100
  final int oiliness;     // 油分 0-100
  final int smoothness;   // 平滑度 0-100
  final int sensitivity;  // 敏感度 0-100
  final int darkSpots;    // 色斑 0-100
  final int pores;        // 毛孔 0-100
  final String summary;
  final List<String> recommendations;

  const SkinAnalysisResult({
    required this.type, required this.hydration, required this.oiliness,
    required this.smoothness, required this.sensitivity,
    required this.darkSpots, required this.pores,
    required this.summary, required this.recommendations,
  });
}

/// 发质分析结果
class HairAnalysisResult {
  final String type;
  final String damage;
  final String scalpCondition;
  final String hairDensity;
  final String summary;
  final List<String> recommendations;

  const HairAnalysisResult({
    required this.type, required this.damage, required this.scalpCondition,
    required this.hairDensity, required this.summary, required this.recommendations,
  });
}

/// ==================== 匹配算法 ====================

class MatchingEngine {
  /// 相似博主匹配 — 根据用户脸型/身材匹配同类博主
  static List<KOLBlogger> matchBloggers({
    required String? faceShape,
    required String? bodyShape,
    required List<String> styleTags,
    List<KOLBlogger> allBloggers = mockBloggers,
  }) {
    var scored = allBloggers.map((b) {
      int score = 0;
      if (faceShape != null && b.faceShape == faceShape) score += 40;
      if (bodyShape != null && b.bodyShape == bodyShape) score += 30;
      if (styleTags.any((t) => b.styleTag.contains(t))) score += 20;
      if (b.specialties.contains('皮肤管理')) score += 10;
      return MapEntry(b, score);
    }).toList();

    scored.sort((a, b) => b.value.compareTo(a.value));
    return scored.where((e) => e.value > 0).map((e) => e.key).toList();
  }

  /// 衣橱搭配算法 — 基于已有衣服生成 OOTD
  static List<OutfitSuggestion> generateOutfits({
    required List<WardrobeItem> wardrobe,
    String? occasion,
    String? weather,
  }) {
    final tops = wardrobe.where((i) => i.category == '上衣').toList();
    final bottoms = wardrobe.where((i) => i.category == '下装').toList();
    final outerwears = wardrobe.where((i) => i.category == '外套').toList();
    final accessories = wardrobe.where((i) => i.category == '配饰').toList();

    final outfits = <OutfitSuggestion>[];
    var idx = 0;
    for (final top in tops.take(5)) {
      for (final bottom in bottoms.take(3)) {
        final outer = outerwears.isNotEmpty && idx % 2 == 0 ? outerwears[idx % outerwears.length] : null;
        final acc = accessories.isNotEmpty ? accessories[idx % accessories.length] : null;
        outfits.add(OutfitSuggestion(
          id: 'outfit_$idx',
          top: top, bottom: bottom,
          outerwear: outer, accessory: acc,
          occasion: occasion ?? '日常',
          matchScore: _calcMatchScore(top, bottom, outer),
        ));
        idx++;
        if (outfits.length >= 3) break;
      }
      if (outfits.length >= 3) break;
    }
    return outfits;
  }

  /// 计算搭配匹配度
  static int _calcMatchScore(WardrobeItem top, WardrobeItem bottom, WardrobeItem? outer) {
    int score = 60;
    // 颜色搭配
    if (top.colors.any((c) => bottom.colors.contains(c))) score -= 10; // 同色扣分
    if (top.colors.any((c) => _isComplementColor(c, bottom.colors))) score += 15;
    // 风格一致
    if (top.tags.any((t) => bottom.tags.contains(t))) score += 15;
    // 材质搭配
    if (top.material == bottom.material) score += 5;
    if (outer != null && outer.tags.any((t) => top.tags.contains(t))) score += 10;
    return score.clamp(0, 100);
  }

  static bool _isComplementColor(String color, List<String> others) {
    const complementMap = {
      '白': ['黑', '藏蓝', '卡其'],
      '黑': ['白', '灰', '红'],
      '蓝': ['白', '米色', '黄'],
      '红': ['黑', '白', '藏蓝'],
      '绿': ['白', '米色', '棕'],
      '粉': ['白', '灰', '藏蓝'],
    };
    final complements = complementMap[color] ?? [];
    return others.any((o) => complements.contains(o));
  }

  /// 护肤成分分析 — 根据肤质过滤产品
  static List<Product> filterSkincareProducts({
    required SkinHairProfile profile,
    List<Product> allProducts = mockProducts,
  }) {
    final avoid = profile.avoidIngredients;
    return allProducts.where((p) {
      if (p.category != '护肤') return false;
      // 检查是否含有需避开的成分
      if (p.ingredients.any((ing) => avoid.any((a) => ing.contains(a)))) {
        return false;
      }
      // 检查是否适合用户肤质
      if (p.suitableSkinTypes.isNotEmpty &&
          !p.suitableSkinTypes.contains(profile.skinType)) {
        return false;
      }
      return true;
    }).toList();
  }

  /// 出片圣地推荐 — 根据风格匹配拍摄地
  static List<PhotoSpot> recommendSpots({
    required List<String> styleTags,
    required String city,
    List<PhotoSpot> allSpots = mockSpots,
  }) {
    var scored = allSpots.where((s) => s.city == city || s.city == '全国').map((s) {
      int score = s.heat ~/ 100;
      if (s.suitableStyles.any((st) => styleTags.any((t) => st.contains(t)))) {
        score += 50;
      }
      return MapEntry(s, score);
    }).toList();

    scored.sort((a, b) => b.value.compareTo(a.value));
    return scored.map((e) => e.key).toList();
  }
}

/// 穿搭建议
class OutfitSuggestion {
  final String id;
  final WardrobeItem top;
  final WardrobeItem bottom;
  final WardrobeItem? outerwear;
  final WardrobeItem? accessory;
  final String occasion;
  final int matchScore; // 0-100

  const OutfitSuggestion({
    required this.id, required this.top, required this.bottom,
    this.outerwear, this.accessory, required this.occasion, required this.matchScore,
  });
}

// ==================== Mock 数据 ====================

const mockBloggers = [
  KOLBlogger(id: 'b1', name: '小鹿酱', avatar: '🦌', bodyShape: '梨型', faceShape: '圆脸',
    styleTag: '法式浪漫', followers: 89000, intro: '法式风格爱好者，专注温柔系穿搭',
    specialties: ['皮肤管理', '穿搭'], isVerified: true),
  KOLBlogger(id: 'b2', name: '潮人阿K', avatar: '🎤', bodyShape: '直筒型', faceShape: '方脸',
    styleTag: '街头潮流', followers: 156000, intro: '街头风穿搭达人，分享潮流单品',
    specialties: ['穿搭', '发型'], isVerified: true),
  KOLBlogger(id: 'b3', name: '知性姐姐', avatar: '📚', bodyShape: '沙漏型', faceShape: '鹅蛋脸',
    styleTag: '极简知性', followers: 210000, intro: '职场穿搭博主，极简主义践行者',
    specialties: ['皮肤管理', '穿搭', '发型'], isVerified: true),
  KOLBlogger(id: 'b4', name: '甜心喵', avatar: '🐱', bodyShape: '苹果型', faceShape: '心形脸',
    styleTag: '甜美可爱', followers: 67000, intro: '甜美系美妆护肤博主',
    specialties: ['皮肤管理', '妆容'], isVerified: true),
  KOLBlogger(id: 'b5', name: '型男Leo', avatar: '🦁', bodyShape: '标准型', faceShape: '长脸',
    styleTag: '简约干净', followers: 132000, intro: '男士穿搭与理容博主',
    specialties: ['穿搭', '皮肤管理'], isVerified: true),
  KOLBlogger(id: 'b6', name: '日系学长', avatar: '🌿', bodyShape: '直筒型', faceShape: '圆脸',
    styleTag: '日系慵懒', followers: 98000, intro: '日系复古风格，City Boy穿搭',
    specialties: ['穿搭', '发型'], isVerified: true),
];

const mockSpots = [
  PhotoSpot(id: 's1', name: '武康大楼', city: '上海', category: '街拍',
    address: '上海市徐汇区武康路',
    description: '上海标志性街拍地点，法式风情浓郁，适合知性优雅风。',
    suitableStyles: ['法式浪漫', '极简知性'], rating: 4.8, heat: 9800),
  PhotoSpot(id: 's2', name: '安福路', city: '上海', category: '咖啡馆',
    address: '上海市徐汇区安福路',
    description: '网红咖啡馆聚集地，街拍圣地，适合潮流和休闲风。',
    suitableStyles: ['街头潮流', '日系慵懒'], rating: 4.6, heat: 8500),
  PhotoSpot(id: 's3', name: '外滩源', city: '上海', category: '艺术展',
    address: '上海市黄浦区外滩源',
    description: '复古建筑与现代艺术结合，适合高级感大片。',
    suitableStyles: ['极简知性', '法式浪漫'], rating: 4.7, heat: 7600),
  PhotoSpot(id: 's4', name: '三里屯', city: '北京', category: '街拍',
    address: '北京市朝阳区三里屯',
    description: '北京最潮街拍地点，潮流达人必去。',
    suitableStyles: ['街头潮流', '简约干净'], rating: 4.7, heat: 9200),
  PhotoSpot(id: 's5', name: '798艺术区', city: '北京', category: '艺术展',
    address: '北京市朝阳区酒仙桥',
    description: '工业风艺术区，适合个性大片和文艺风。',
    suitableStyles: ['日系慵懒', '极简知性'], rating: 4.5, heat: 6800),
  PhotoSpot(id: 's6', name: '东山口', city: '广州', category: '街拍',
    address: '广州市越秀区东山口',
    description: '复古洋楼街区，适合法式复古和甜美风。',
    suitableStyles: ['法式浪漫', '甜美可爱'], rating: 4.6, heat: 7200),
  PhotoSpot(id: 's7', name: 'OCT创意园', city: '深圳', category: '艺术展',
    address: '深圳市南山区华侨城',
    description: '创意园区，现代感十足，适合极简和潮流风。',
    suitableStyles: ['极简知性', '街头潮流'], rating: 4.4, heat: 5500),
  PhotoSpot(id: 's8', name: '太古里', city: '成都', category: '街拍',
    address: '成都市锦江区太古里',
    description: '成都时尚地标，各类风格都适合出片。',
    suitableStyles: ['街头潮流', '法式浪漫', '甜美可爱'], rating: 4.7, heat: 8800),
];

const mockProducts = [
  Product(id: 1, name: '氨基酸温和洁面乳', brand: '珂润', price: 89, category: '护肤',
    suitableSkinTypes: ['干', '敏'], ingredients: ['氨基酸', '神经酰胺'],
    rating: 4.7, sales: 12000),
  Product(id: 2, name: '烟酰胺控油精华', brand: 'The Ordinary', price: 78, originalPrice: 128,
    category: '护肤', suitableSkinTypes: ['油', '混'],
    ingredients: ['烟酰胺', '透明质酸'], rating: 4.5, sales: 8500),
  Product(id: 3, name: '玻尿酸保湿面膜', brand: '春雨', price: 65, category: '护肤',
    suitableSkinTypes: ['干', '混', '敏'], ingredients: ['玻尿酸', '蜂蜜'],
    rating: 4.8, sales: 25000),
  Product(id: 4, name: '维C亮肤精华', brand: '修丽可', price: 580, category: '护肤',
    suitableSkinTypes: ['混', '油'], ingredients: ['维C', '阿魏酸'],
    rating: 4.6, sales: 3400),
  Product(id: 5, name: '丝绸衬衫', brand: 'COS', price: 399, category: '服饰',
    suitableStyles: ['极简知性', '法式浪漫'], sizeRange: 'XS-L', rating: 4.5, sales: 1800),
  Product(id: 6, name: '高腰直筒牛仔裤', brand: 'Levis', price: 459, category: '服饰',
    suitableStyles: ['街头潮流', '日系慵懒', '极简知性'], sizeRange: '24-32', rating: 4.6, sales: 5200),
  Product(id: 7, name: '珍珠耳环', brand: 'APM', price: 299, category: '配饰',
    suitableStyles: ['极简知性', '法式浪漫'], rating: 4.7, sales: 3400),
  Product(id: 8, name: '丝绒口红', brand: 'MAC', price: 180, category: '彩妆',
    suitableStyles: ['法式浪漫', '甜美可爱'], rating: 4.8, sales: 15000),
];

const mockCommunityPosts = [
  CommunityPost(id: 'p1', userId: 'u1', userName: '小红薯', userAvatar: '🍠',
    userBodyShape: '梨型', userFaceShape: '圆脸',
    title: '梨形身材显瘦穿搭实测',
    content: '作为一个经典梨形身材，分享3套亲测显瘦的穿搭！A字裙+修身针织衫绝了...',
    imagePaths: [], category: '真人实测', likes: 2340, comments: 156,
    createdAt: null),
  CommunityPost(id: 'p2', userId: 'u2', userName: '美妆小白', userAvatar: '🐰',
    userBodyShape: '直筒型', userFaceShape: '肿泡眼',
    title: '肿泡眼终于画出大眼妆了！',
    content: '跟着博主的教程练了一周，终于成功了！分享我的练习心得...',
    imagePaths: [], category: '作业打卡', likes: 1200, comments: 89,
    createdAt: null),
  CommunityPost(id: 'p3', userId: 'u3', userName: '纠结症患者', userAvatar: '🤔',
    userBodyShape: '方圆脸', userFaceShape: '方脸',
    title: '方圆脸适合戴棒球帽吗？',
    content: '最近想买棒球帽但是怕显脸更方...有同款脸型的姐妹推荐吗？',
    imagePaths: [], category: '互助问答', likes: 456, comments: 78,
    createdAt: null),
];
