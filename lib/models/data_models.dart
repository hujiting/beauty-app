// ============================================================
// 第一层：数据基石 — 完整数据模型定义
// ============================================================

/// ==================== 静态档案库 ====================

/// 身体数据
class BodyProfile {
  final double? height; // cm
  final double? weight; // kg
  final double? bust;   // 胸围
  final double? waist;  // 腰围
  final double? hip;    // 臀围
  final double? shoulderWidth; // 肩宽
  final String? legRatio;      // 腿长比例: '短腿/中腿/长腿'

  const BodyProfile({
    this.height, this.weight, this.bust, this.waist, this.hip,
    this.shoulderWidth, this.legRatio,
  });

  /// 体型判断
  String get bodyShape {
    if (waist == null || hip == null || bust == null) return '未知';
    final whRatio = waist! / hip!;
    final bwRatio = bust! / waist!;
    if (whRatio < 0.7 && bwRatio > 1.05) return '沙漏型';
    if (whRatio > 0.85 && bwRatio < 0.95) return '苹果型';
    if (whRatio < 0.75 && bwRatio < 0.95) return '梨型';
    if (whRatio >= 0.75 && whRatio <= 0.85 && bwRatio >= 0.95 && bwRatio <= 1.05) return '直筒型';
    return '标准型';
  }

  /// BMI
  double? get bmi {
    if (height == null || weight == null) return null;
    return weight! / ((height! / 100) * (height! / 100));
  }

  Map<String, dynamic> toJson() => {
    'height': height, 'weight': weight, 'bust': bust,
    'waist': waist, 'hip': hip, 'shoulderWidth': shoulderWidth,
    'legRatio': legRatio,
  };

  factory BodyProfile.fromJson(Map<String, dynamic> json) => BodyProfile(
    height: (json['height'] as num?)?.toDouble(),
    weight: (json['weight'] as num?)?.toDouble(),
    bust: (json['bust'] as num?)?.toDouble(),
    waist: (json['waist'] as num?)?.toDouble(),
    hip: (json['hip'] as num?)?.toDouble(),
    shoulderWidth: (json['shoulderWidth'] as num?)?.toDouble(),
    legRatio: json['legRatio'] as String?,
  );
}

/// 面部数据
class FaceProfile {
  final String? faceShape;     // 圆/方/长/心形/鹅蛋
  final String? skinTone;      // 冷白/暖黄/橄榄/小麦
  final String? skinUndertone; // 冷调/暖调/中性调
  final String? eyeShape;      // 肿泡眼/单眼皮/双眼皮/内双
  final String? lipShape;      // 厚唇/薄唇/标准
  final String? pupilColor;    // 黑/棕/深棕

  const FaceProfile({
    this.faceShape, this.skinTone, this.skinUndertone,
    this.eyeShape, this.lipShape, this.pupilColor,
  });

  /// 色彩季型
  String get colorSeason {
    if (skinUndertone == null || skinTone == null) return '未知';
    final isCool = skinUndertone == '冷调';
    if (isCool) {
      if (skinTone!.contains('白')) return '冬季型（冷白）';
      return '夏季型（冷柔）';
    } else {
      if (skinTone!.contains('小麦') || skinTone!.contains('深')) return '秋季型（暖深）';
      return '春季型（暖亮）';
    }
  }

  Map<String, dynamic> toJson() => {
    'faceShape': faceShape, 'skinTone': skinTone,
    'skinUndertone': skinUndertone, 'eyeShape': eyeShape,
    'lipShape': lipShape, 'pupilColor': pupilColor,
  };

  factory FaceProfile.fromJson(Map<String, dynamic> json) => FaceProfile(
    faceShape: json['faceShape'] as String?,
    skinTone: json['skinTone'] as String?,
    skinUndertone: json['skinUndertone'] as String?,
    eyeShape: json['eyeShape'] as String?,
    lipShape: json['lipShape'] as String?,
    pupilColor: json['pupilColor'] as String?,
  );
}

/// 发肤数据
class SkinHairProfile {
  final String? skinType;    // 干/油/混/敏
  final String? hairType;    // 细软/粗硬/中性
  final String? hairDamage;  // 健康/轻度受损/严重受损
  final List<String> skinConcerns; // 皮肤问题：痘痘/暗沉/细纹/敏感

  const SkinHairProfile({
    this.skinType, this.hairType, this.hairDamage,
    this.skinConcerns = const [],
  });

  /// 护肤重点
  String get skincareFocus {
    if (skinType == null) return '基础护理';
    switch (skinType) {
      case '干': return '补水保湿';
      case '油': return '控油祛痘';
      case '敏': return '舒缓修护';
      case '混': return '分区护理';
      default: return '平衡护理';
    }
  }

  /// 需要避开的成分
  List<String> get avoidIngredients {
    final list = <String>[];
    if (skinType == '敏') {
      list.addAll(['酒精', '果酸', '水杨酸', '香精']);
    }
    if (skinType == '干') {
      list.add('高浓度酒精');
    }
    if (skinType == '油') {
      list.add('矿物油');
    }
    return list;
  }

  Map<String, dynamic> toJson() => {
    'skinType': skinType, 'hairType': hairType,
    'hairDamage': hairDamage, 'skinConcerns': skinConcerns,
  };

  factory SkinHairProfile.fromJson(Map<String, dynamic> json) => SkinHairProfile(
    skinType: json['skinType'] as String?,
    hairType: json['hairType'] as String?,
    hairDamage: json['hairDamage'] as String?,
    skinConcerns: (json['skinConcerns'] as List<dynamic>?)?.cast<String>() ?? [],
  );
}

/// 风格偏好
class StylePreference {
  final List<String> styleTags;    // 极简/复古/街头/法式/日系
  final List<String> favoriteStars; // 喜欢的明星
  final String? budget;             // 预算区间

  const StylePreference({
    this.styleTags = const [],
    this.favoriteStars = const [],
    this.budget,
  });

  Map<String, dynamic> toJson() => {
    'styleTags': styleTags, 'favoriteStars': favoriteStars, 'budget': budget,
  };

  factory StylePreference.fromJson(Map<String, dynamic> json) => StylePreference(
    styleTags: (json['styleTags'] as List<dynamic>?)?.cast<String>() ?? [],
    favoriteStars: (json['favoriteStars'] as List<dynamic>?)?.cast<String>() ?? [],
    budget: json['budget'] as String?,
  );
}

/// ==================== 动态衣橱库 ====================

/// 衣物单品
class WardrobeItem {
  final String id;
  final String name;
  final String category;    // 上衣/下装/外套/配饰/鞋
  final String subCategory; // T恤/衬衫/牛仔裤/连衣裙...
  final List<String> colors;
  final String? material;   // 棉/麻/丝/聚酯
  final String? brand;
  final String? imagePath;
  final DateTime addedDate;
  int wearCount;            // 穿着次数
  DateTime? lastWornDate;
  final List<String> tags;  // 休闲/正式/运动

  WardrobeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategory,
    this.colors = const [],
    this.material, this.brand, this.imagePath,
    required this.addedDate,
    this.wearCount = 0,
    this.lastWornDate,
    this.tags = const [],
  });

  /// 闲置率 (0~1)
  double get idleRate {
    final daysSinceAdded = DateTime.now().difference(addedDate).inDays;
    if (daysSinceAdded < 30) return 0;
    if (wearCount == 0) return 1.0;
    final expectedWear = daysSinceAdded / 30; // 理想每月穿1次
    final actual = wearCount.toDouble();
    return (1 - (actual / expectedWear)).clamp(0.0, 1.0);
  }

  /// 是否建议断舍离
  bool get shouldRemove {
    final daysSinceAdded = DateTime.now().difference(addedDate).inDays;
    return daysSinceAdded > 365 && wearCount < 3;
  }

  void recordWorn() {
    wearCount++;
    lastWornDate = DateTime.now();
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'category': category, 'subCategory': subCategory,
    'colors': colors, 'material': material, 'brand': brand, 'imagePath': imagePath,
    'addedDate': addedDate.toIso8601String(), 'wearCount': wearCount,
    'lastWornDate': lastWornDate?.toIso8601String(), 'tags': tags,
  };

  factory WardrobeItem.fromJson(Map<String, dynamic> json) => WardrobeItem(
    id: json['id'] as String, name: json['name'] as String,
    category: json['category'] as String, subCategory: json['subCategory'] as String,
    colors: (json['colors'] as List<dynamic>?)?.cast<String>() ?? [],
    material: json['material'] as String?, brand: json['brand'] as String?,
    imagePath: json['imagePath'] as String?,
    addedDate: DateTime.parse(json['addedDate'] as String),
    wearCount: json['wearCount'] as int? ?? 0,
    lastWornDate: json['lastWornDate'] != null ? DateTime.parse(json['lastWornDate'] as String) : null,
    tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
  );
}

/// ==================== 场景数据库 ====================

/// 打卡点
class PhotoSpot {
  final String id;
  final String name;
  final String city;
  final String category;   // 咖啡馆/艺术展/公园/网红墙/街拍
  final String address;
  final String description;
  final List<String> suitableStyles; // 适合的风格标签
  final String? imagePath;
  final double rating;
  final int heat;          // 热度值

  const PhotoSpot({
    required this.id, required this.name, required this.city,
    required this.category, required this.address, required this.description,
    this.suitableStyles = const [], this.imagePath, this.rating = 4.5, this.heat = 0,
  });
}

/// ==================== 社区模型 ====================

/// 社区帖子
class CommunityPost {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String userBodyShape;  // 发布者身材类型
  final String userFaceShape;  // 发布者脸型
  final String title;
  final String content;
  final List<String> imagePaths;
  final String category;       // 真人实测/作业打卡/互助问答
  final int likes;
  final int comments;
  final DateTime? createdAt;

  const CommunityPost({
    required this.id, required this.userId, required this.userName,
    required this.userAvatar, required this.userBodyShape, required this.userFaceShape,
    required this.title, required this.content, this.imagePaths = const [],
    required this.category, this.likes = 0, this.comments = 0,
    this.createdAt,
  });
}

/// ==================== 商城模型 ====================

/// 商城商品
class Product {
  final int id;
  final String name;
  final String brand;
  final double price;
  final double? originalPrice;
  final String category;    // 护肤/彩妆/服饰/配饰
  final String? imagePath;
  final List<String> suitableStyles;
  final List<String> suitableSkinTypes;
  final List<String> ingredients;   // 成分列表（护肤类）
  final String? sizeRange;          // 尺码范围
  final double rating;
  final int sales;

  const Product({
    required this.id, required this.name, required this.brand,
    required this.price, this.originalPrice, required this.category,
    this.imagePath, this.suitableStyles = const [],
    this.suitableSkinTypes = const [], this.ingredients = const [],
    this.sizeRange, this.rating = 4.5, this.sales = 0,
  });
}

/// ==================== 运营模型 ====================

/// KOL 博主
class KOLBlogger {
  final String id;
  final String name;
  final String avatar;
  final String bodyShape;    // 身材类型
  final String faceShape;    // 脸型
  final String styleTag;     // 风格标签
  final int followers;
  final String intro;
  final List<String> specialties; // 专长：皮肤管理/穿搭/发型
  final bool isVerified;

  const KOLBlogger({
    required this.id, required this.name, required this.avatar,
    required this.bodyShape, required this.faceShape, required this.styleTag,
    this.followers = 0, required this.intro, this.specialties = const [],
    this.isVerified = false,
  });
}

/// VIP 等级
enum VipLevel { free, vip, svip }

extension VipLevelExt on VipLevel {
  String get label => switch (this) {
    VipLevel.free => '普通用户',
    VipLevel.vip => 'VIP会员',
    VipLevel.svip => 'SVIP会员',
  };

  bool get canUseAITryOn => this != VipLevel.free;
  bool get hasPersonalStylist => this == VipLevel.svip;
  int get aiAnalysisLimit => switch (this) {
    VipLevel.free => 3,
    VipLevel.vip => 30,
    VipLevel.svip => -1, // 无限
  };
}
