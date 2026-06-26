import 'package:flutter/material.dart';

// 模型类定义
class Inspiration {
  final String title;
  final String category;
  final String views;
  const Inspiration({required this.title, required this.category, required this.views});
}

class Tutorial {
  final String title;
  final String level;
  final String duration;
  const Tutorial({required this.title, required this.level, required this.duration});
}

class Blogger {
  final String name;
  final String fans;
  final String style;
  const Blogger({required this.name, required this.fans, required this.style});
}

class Product {
  final String name;
  final String category;
  final int price;
  final int originalPrice;
  const Product({required this.name, required this.category, required this.price, required this.originalPrice});
}

class PhotoSpot {
  final String city;
  final String location;
  final String style;
  const PhotoSpot({required this.city, required this.location, required this.style});
}

class Template {
  final String name;
  final String platform;
  final int count;
  const Template({required this.name, required this.platform, required this.count});
}

class Article {
  final String title;
  final String category;
  final String reads;
  const Article({required this.title, required this.category, required this.reads});
}

class QuizOption {
  final String text;
  final String style;
  const QuizOption({required this.text, required this.style});
}

class QuizQuestion {
  final String question;
  final List<QuizOption> options;
  const QuizQuestion({required this.question, required this.options});
}

class StyleColor {
  final String name;
  final Color color;
  const StyleColor({required this.name, required this.color});
}

class StyleResult {
  final String name;
  final String keywords;
  final List<StyleColor> colors;
  final String description;
  final List<String> items;
  final String accessories;
  final String hair;
  final String nails;
  const StyleResult({
    required this.name,
    required this.keywords,
    required this.colors,
    required this.description,
    required this.items,
    required this.accessories,
    required this.hair,
    required this.nails,
  });
}

class FaceMakeup {
  final String title;
  final String advice;
  const FaceMakeup({required this.title, required this.advice});
}

// 颜色常量
const Color pink = Color(0xFFD4A5A5);
const Color gold = Color(0xFFC9B99A);
const Color softPink = Color(0xFFE8D5D5);
const Color softGold = Color(0xFFF0E6D6);
const Color pinkDark = Color(0xFFB88A8A);

// 灵感数据
const List<Inspiration> inspirations = [
  Inspiration(title: '早秋极简穿搭灵感', category: '穿搭', views: '3.2k'),
  Inspiration(title: '职场淡妆五分钟搞定', category: '妆容', views: '5.1k'),
  Inspiration(title: '找到你的专属风格', category: '风格', views: '8.7k'),
  Inspiration(title: '身体是最好的投资', category: '健康', views: '2.8k'),
];

// 教程数据
const List<Tutorial> tutorials = [
  Tutorial(title: '清透日常淡妆', level: '新手友好', duration: '10min'),
  Tutorial(title: '韩系水光妆', level: '进阶', duration: '20min'),
  Tutorial(title: '知性通勤妆', level: '新手友好', duration: '15min'),
  Tutorial(title: '温柔约会妆', level: '进阶', duration: '25min'),
  Tutorial(title: '气场红唇妆', level: '高阶', duration: '30min'),
];

// 博主数据
const List<Blogger> bloggers = [
  Blogger(name: '苏苏的穿搭日记', fans: '52万', style: '极简风'),
  Blogger(name: 'Lily美妆分享', fans: '38万', style: '日常妆'),
  Blogger(name: '一衣多穿', fans: '67万', style: '通勤风'),
  Blogger(name: '小鹿的护肤笔记', fans: '45万', style: '护肤'),
];

// 产品数据
const List<Product> products = [
  Product(name: '极简主义手提包', category: '包袋', price: 599, originalPrice: 799),
  Product(name: '珍珠耳环套装', category: '配饰', price: 128, originalPrice: 168),
  Product(name: '丝绒发夹组合', category: '发饰', price: 68, originalPrice: 88),
  Product(name: '裸色系甲油套装', category: '美甲', price: 89, originalPrice: 129),
  Product(name: '真丝方巾', category: '配饰', price: 299, originalPrice: 399),
  Product(name: '极简银项链', category: '首饰', price: 168, originalPrice: 228),
  Product(name: '法式贝雷帽', category: '帽子', price: 139, originalPrice: 189),
  Product(name: '莫兰迪色围巾', category: '配饰', price: 199, originalPrice: 259),
];

// 拍照地点数据
const List<PhotoSpot> photoSpots = [
  PhotoSpot(city: '上海', location: '武康路法式街区', style: '法式优雅'),
  PhotoSpot(city: '杭州', location: '西湖断桥残雪', style: '清冷文艺'),
  PhotoSpot(city: '成都', location: '太古里潮流街区', style: '时尚街拍'),
  PhotoSpot(city: '厦门', location: '沙坡尾艺术西区', style: '清新文艺'),
];

// 模板数据
const List<Template> templates = [
  Template(name: '高级感九宫格', platform: '朋友圈', count: 9),
  Template(name: '穿搭Vlog脚本', platform: '抖音', count: 15),
  Template(name: '极简产品展示', platform: '小红书', count: 6),
  Template(name: '旅行打卡合集', platform: '朋友圈', count: 9),
];

// 文章数据
const List<Article> articles = [
  Article(title: '容貌焦虑？你本来就很美', category: '心理', reads: '12.5k'),
  Article(title: '科学护肤：成分全解析', category: '护肤', reads: '8.3k'),
  Article(title: '好好吃饭比什么都重要', category: '营养', reads: '6.7k'),
  Article(title: '睡眠是最好的美容', category: '养生', reads: '9.1k'),
  Article(title: '运动让皮肤会发光', category: '运动', reads: '5.4k'),
  Article(title: '拒绝身材PUA', category: '心理', reads: '15.2k'),
];

// 测验问题数据
const List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    question: '你的身材形状是？',
    options: [
      QuizOption(text: '纤细修长', style: 'minimal'),
      QuizOption(text: '曲线玲珑', style: 'elegant'),
      QuizOption(text: '匀称适中', style: 'french'),
      QuizOption(text: '骨架偏大', style: 'street'),
    ],
  ),
  QuizQuestion(
    question: '你的肩宽是？',
    options: [
      QuizOption(text: '窄', style: 'french'),
      QuizOption(text: '适中', style: 'minimal'),
      QuizOption(text: '宽', style: 'street'),
      QuizOption(text: '不确定', style: 'elegant'),
    ],
  ),
  QuizQuestion(
    question: '你最困扰的问题是？',
    options: [
      QuizOption(text: '比例不好', style: 'elegant'),
      QuizOption(text: '找不到风格', style: 'french'),
      QuizOption(text: '穿衣显胖', style: 'minimal'),
      QuizOption(text: '没困扰', style: 'street'),
    ],
  ),
  QuizQuestion(
    question: '你更喜欢哪种穿衣感觉？',
    options: [
      QuizOption(text: '简约利落', style: 'minimal'),
      QuizOption(text: '浪漫柔美', style: 'french'),
      QuizOption(text: '帅气个性', style: 'street'),
      QuizOption(text: '优雅知性', style: 'elegant'),
    ],
  ),
];

// 风格结果数据
const Map<String, StyleResult> styleResults = {
  'minimal': StyleResult(
    name: '极简知性风',
    keywords: '干净利落高级感',
    colors: [
      StyleColor(name: '黑', color: Colors.black),
      StyleColor(name: '白', color: Colors.white),
      StyleColor(name: '灰', color: Colors.grey),
      StyleColor(name: '驼', color: Color(0xFFD2B48C)),
    ],
    description: '你适合简洁线条、质感面料的穿搭。少即是多，一件好的大衣胜过十件花哨的上衣。',
    items: ['修身西装外套', '高腰阔腿裤', '纯色羊绒衫', '尖头平底鞋'],
    accessories: '极简金属首饰、结构感手提包',
    hair: '利落短发或低马尾',
    nails: '裸色或法式美甲',
  ),
  'french': StyleResult(
    name: '法式浪漫风',
    keywords: '慵懒浪漫女人味',
    colors: [
      StyleColor(name: '奶白', color: Color(0xFFFFFDD0)),
      StyleColor(name: '雾蓝', color: Color(0xFFB0C4DE)),
      StyleColor(name: '浅粉', color: Color(0xFFFFB6C1)),
      StyleColor(name: '碎花', color: Color(0xFFDB7093)),
    ],
    description: '你适合带有法式慵懒感的穿搭。碎花裙、针织衫、贝雷帽都是你的好伙伴。',
    items: ['碎花连衣裙', '针织开衫', '高腰A字裙', '芭蕾平底鞋'],
    accessories: '珍珠首饰、丝巾、草编包',
    hair: '自然卷发或侧编发',
    nails: '豆沙色或莫兰迪色系',
  ),
  'street': StyleResult(
    name: '酷飒街头风',
    keywords: '个性帅气自由',
    colors: [
      StyleColor(name: '黑', color: Colors.black),
      StyleColor(name: '军绿', color: Color(0xFF556B2F)),
      StyleColor(name: '银灰', color: Color(0xFFC0C0C0)),
      StyleColor(name: '撞色', color: Color(0xFFFF4500)),
    ],
    description: '你适合帅气有个性的穿搭。Oversize外套、工装裤、厚底鞋展现你的态度。',
    items: ['Oversize夹克', '工装阔腿裤', '印花T恤', '厚底靴'],
    accessories: '链条项链、宽腰带、墨镜',
    hair: '挑染或高马尾',
    nails: '暗色系或几何图案',
  ),
  'elegant': StyleResult(
    name: '优雅气质风',
    keywords: '温柔知性得体',
    colors: [
      StyleColor(name: '米色', color: Color(0xFFF5F5DC)),
      StyleColor(name: '香槟', color: Color(0xFFF7E7CE)),
      StyleColor(name: '藕粉', color: Color(0xFFE6CFCF)),
      StyleColor(name: '烟灰', color: Color(0xFFA9A9A9)),
    ],
    description: '你适合优雅得体的穿搭。真丝面料、柔和色调、精致剪裁让你散发成熟魅力。',
    items: ['真丝衬衫', '铅笔裙', '小香风外套', '细高跟鞋'],
    accessories: '精致锁骨链、丝绒手拿包',
    hair: '低盘发或大波浪',
    nails: '裸粉色渐变或猫眼',
  ),
};

// 面部特征数据
const List<String> faceFeatures = [
  '额头与下巴宽度接近',
  '面部线条柔和流畅',
  '颧骨不突出',
  '脸型比例匀称',
];

// 面部化妆建议数据
const List<FaceMakeup> faceMakeupRecs = [
  FaceMakeup(title: '自然清透底妆', advice: '轻薄粉底液重点遮瑕即可'),
  FaceMakeup(title: '柔和眉形', advice: '自然弯眉最适合鹅蛋脸避免过于棱角'),
  FaceMakeup(title: '腮红位置', advice: '苹果肌偏上扫腮红增添好气色'),
  FaceMakeup(title: '唇妆建议', advice: '几乎所有唇形都适合大胆尝试'),
];

// 面部建议数据
const List<String> faceTips = [
  '你的脸型很百搭各种妆容都能驾驭',
  '可以尝试不同风格的眉形找到最爱',
  '修容重点在下颌线和鼻侧',
  '发型方面几乎没有禁忌',
];
