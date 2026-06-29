import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/data_models.dart';
import '../models/ai_engine.dart';

/// APP 全局状态管理 — 私人变美管家（四层架构版）
class AppState extends ChangeNotifier {
  // ============ 基础用户数据 ============
  String _userName = '变美管家';
  String get userName => _userName;

  String _userBio = '找到属于自己的美';
  String get userBio => _userBio;

  // ============ 首次启动引导 ============
  bool _onboardingComplete = false;
  bool get onboardingComplete => _onboardingComplete;

  String? _gender;
  String? get gender => _gender;
  bool get isFemale => _gender == 'female';

  String? _styleResult;
  String? get styleResult => _styleResult;

  String? _skinKeyword;
  String? get skinKeyword => _skinKeyword;

  // ============ 第一层：数据基石 ============
  BodyProfile _bodyProfile = const BodyProfile();
  BodyProfile get bodyProfile => _bodyProfile;

  FaceProfile _faceProfile = const FaceProfile();
  FaceProfile get faceProfile => _faceProfile;

  SkinHairProfile _skinHairProfile = const SkinHairProfile();
  SkinHairProfile get skinHairProfile => _skinHairProfile;

  StylePreference _stylePreference = const StylePreference();
  StylePreference get stylePreference => _stylePreference;

  // 动态衣橱
  final List<WardrobeItem> _wardrobe = [];
  List<WardrobeItem> get wardrobe => _wardrobe;

  // 场景数据
  String _userCity = '上海';
  String get userCity => _userCity;

  // ============ 第二层：分析历史 ============
  final List<SkinAnalysisResult> _skinAnalysisHistory = [];
  List<SkinAnalysisResult> get skinAnalysisHistory => _skinAnalysisHistory;

  final List<HairAnalysisResult> _hairAnalysisHistory = [];
  List<HairAnalysisResult> get hairAnalysisHistory => _hairAnalysisHistory;

  // ============ 第三层：每日护肤打卡 ============
  final Map<String, bool> _skincareToday = {};
  Map<String, bool> get skincareToday => _skincareToday;

  final List<String> _skincareSteps = [
    '洁面', '爽肤水', '精华', '乳液/面霜', '防晒',
  ];
  List<String> get skincareSteps => _skincareSteps;

  // ============ 第四层：运营 ============
  VipLevel _vipLevel = VipLevel.free;
  VipLevel get vipLevel => _vipLevel;
  bool get isVip => _vipLevel != VipLevel.free;

  // ============ 收藏 ============
  final Set<int> _favoriteProductIds = {};
  Set<int> get favoriteProductIds => _favoriteProductIds;
  bool isFavorite(int id) => _favoriteProductIds.contains(id);

  final Set<String> _favoriteSpots = {};
  Set<String> get favoriteSpots => _favoriteSpots;
  bool isSpotFavorite(String spotName) => _favoriteSpots.contains(spotName);

  // ============ 待办事项 ============
  final List<TodoItem> _todos = [];
  List<TodoItem> get todos => _todos;

  // ============ 初始化 ============
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? '变美管家';
    _userBio = prefs.getString('user_bio') ?? '找到属于自己的美';
    _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    _gender = prefs.getString('gender');
    _styleResult = prefs.getString('style_result');
    _skinKeyword = prefs.getString('skin_keyword');
    _userCity = prefs.getString('user_city') ?? '上海';

    // 加载档案数据
    final bodyJson = prefs.getString('body_profile');
    if (bodyJson != null) _bodyProfile = BodyProfile.fromJson(jsonDecode(bodyJson));
    final faceJson = prefs.getString('face_profile');
    if (faceJson != null) _faceProfile = FaceProfile.fromJson(jsonDecode(faceJson));
    final skinHairJson = prefs.getString('skin_hair_profile');
    if (skinHairJson != null) _skinHairProfile = SkinHairProfile.fromJson(jsonDecode(skinHairJson));
    final stylePrefJson = prefs.getString('style_preference');
    if (stylePrefJson != null) _stylePreference = StylePreference.fromJson(jsonDecode(stylePrefJson));

    // 加载衣橱
    final wardrobeJson = prefs.getStringList('wardrobe') ?? [];
    for (final item in wardrobeJson) {
      _wardrobe.add(WardrobeItem.fromJson(jsonDecode(item)));
    }

    // 护肤打卡
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final skincareDone = prefs.getStringList('skincare_$today') ?? [];
    for (final step in _skincareSteps) {
      _skincareToday[step] = skincareDone.contains(step);
    }

    // 分析历史
    _loadSkinHistory(prefs);
    _loadHairHistory(prefs);

    // 收藏
    final favIds = prefs.getStringList('favorite_ids') ?? [];
    _favoriteProductIds.addAll(favIds.map((id) => int.parse(id)));
    final favSpots = prefs.getStringList('favorite_spots') ?? [];
    _favoriteSpots.addAll(favSpots);

    // 待办
    _generateTodos();

    notifyListeners();
  }

  void _loadSkinHistory(SharedPreferences prefs) {
    final history = prefs.getStringList('skin_history') ?? [];
    for (final item in history) {
      final parts = item.split('|');
      if (parts.length >= 3) {
        _skinAnalysisHistory.insert(0, SkinAnalysisResult(
          type: parts[1], hydration: 50, oiliness: 50, smoothness: 50,
          sensitivity: 30, darkSpots: 20, pores: 30,
          summary: parts[2], recommendations: [],
        ));
      }
    }
  }

  void _loadHairHistory(SharedPreferences prefs) {
    final history = prefs.getStringList('hair_history') ?? [];
    for (final item in history) {
      final parts = item.split('|');
      if (parts.length >= 3) {
        _hairAnalysisHistory.insert(0, HairAnalysisResult(
          type: parts[1], damage: '轻度受损', scalpCondition: '正常',
          hairDensity: '正常', summary: parts[2], recommendations: [],
        ));
      }
    }
  }

  void _generateTodos() {
    _todos.clear();
    // 护肤提醒
    if (_skincareToday.values.any((v) => !v)) {
      _todos.add(TodoItem(title: '完成今日护肤步骤', icon: Icons.spa_outlined, type: TodoType.skincare));
    }
    // 去角质提醒（每2周）
    _todos.add(TodoItem(title: '该去角质的日子到了', icon: Icons.face_retouching_natural, type: TodoType.exfoliate));
    // 理发提醒（每月）
    _todos.add(TodoItem(title: '该剪头发了', icon: Icons.cut, type: TodoType.haircut));
    // 衣橱整理提醒
    if (_wardrobe.any((w) => w.shouldRemove)) {
      final count = _wardrobe.where((w) => w.shouldRemove).length;
      _todos.add(TodoItem(title: '$count件衣物建议断舍离', icon: Icons.delete_outline, type: TodoType.wardrobe));
    }
  }

  // ============ 完成引导 ============
  Future<void> completeOnboarding({
    required String gender,
    required String styleResult,
    required String skinKeyword,
  }) async {
    _onboardingComplete = true;
    _gender = gender;
    _styleResult = styleResult;
    _skinKeyword = skinKeyword;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    await prefs.setString('gender', gender);
    await prefs.setString('style_result', styleResult);
    await prefs.setString('skin_keyword', skinKeyword);
  }

  // ============ 更新档案 ============
  Future<void> updateBodyProfile(BodyProfile profile) async {
    _bodyProfile = profile;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('body_profile', jsonEncode(profile.toJson()));
  }

  Future<void> updateFaceProfile(FaceProfile profile) async {
    _faceProfile = profile;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('face_profile', jsonEncode(profile.toJson()));
  }

  Future<void> updateSkinHairProfile(SkinHairProfile profile) async {
    _skinHairProfile = profile;
    _skinKeyword = profile.skincareFocus;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('skin_hair_profile', jsonEncode(profile.toJson()));
    await prefs.setString('skin_keyword', profile.skincareFocus);
  }

  Future<void> updateStylePreference(StylePreference pref) async {
    _stylePreference = pref;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('style_preference', jsonEncode(pref.toJson()));
  }

  Future<void> updateCity(String city) async {
    _userCity = city;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_city', city);
  }

  // ============ 衣橱管理 ============
  Future<void> addWardrobeItem(WardrobeItem item) async {
    _wardrobe.insert(0, item);
    _generateTodos();
    notifyListeners();
    await _saveWardrobe();
  }

  Future<void> removeWardrobeItem(String id) async {
    _wardrobe.removeWhere((w) => w.id == id);
    notifyListeners();
    await _saveWardrobe();
  }

  Future<void> recordWardrobeWorn(String id) async {
    final item = _wardrobe.firstWhere((w) => w.id == id);
    item.recordWorn();
    notifyListeners();
    await _saveWardrobe();
  }

  Future<void> _saveWardrobe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'wardrobe', _wardrobe.map((w) => jsonEncode(w.toJson())).toList(),
    );
  }

  // ============ 肤质分析记录 ============
  Future<void> addSkinAnalysis(SkinAnalysisResult result) async {
    _skinAnalysisHistory.insert(0, result);
    _generateTodos();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final history = _skinAnalysisHistory.map((e) =>
      '${DateTime.now().toIso8601String().substring(0,10)}|${e.type}|${e.summary}'
    ).toList();
    await prefs.setStringList('skin_history', history);
  }

  // ============ 发质分析记录 ============
  Future<void> addHairAnalysis(HairAnalysisResult result) async {
    _hairAnalysisHistory.insert(0, result);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final history = _hairAnalysisHistory.map((e) =>
      '${DateTime.now().toIso8601String().substring(0,10)}|${e.type}|${e.summary}'
    ).toList();
    await prefs.setStringList('hair_history', history);
  }

  // ============ 护肤打卡 ============
  Future<void> toggleSkincareStep(String step) async {
    _skincareToday[step] = !(_skincareToday[step] ?? false);
    _generateTodos();
    notifyListeners();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final prefs = await SharedPreferences.getInstance();
    final done = _skincareToday.entries.where((e) => e.value).map((e) => e.key).toList();
    await prefs.setStringList('skincare_$today', done);
  }

  // ============ 收藏 ============
  Future<void> toggleFavorite(int productId) async {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favorite_ids', _favoriteProductIds.map((id) => id.toString()).toList(),
    );
  }

  Future<void> toggleSpotFavorite(String spotName) async {
    if (_favoriteSpots.contains(spotName)) {
      _favoriteSpots.remove(spotName);
    } else {
      _favoriteSpots.add(spotName);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_spots', _favoriteSpots.toList());
  }

  // ============ 更新风格结果 ============
  Future<void> updateStyleResult(String result) async {
    _styleResult = result;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('style_result', result);
  }

  // ============ 更新用户信息 ============
  Future<void> updateUser({String? name, String? bio}) async {
    if (name != null) _userName = name;
    if (bio != null) _userBio = bio;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _userName);
    await prefs.setString('user_bio', _userBio);
  }

  // ============ VIP ============
  Future<void> upgradeToVip(VipLevel level) async {
    _vipLevel = level;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('vip_level', level.index);
  }
}

/// 待办事项
class TodoItem {
  final String title;
  final IconData icon;
  final TodoType type;
  final bool done;

  const TodoItem({
    required this.title, required this.icon, required this.type, this.done = false,
  });

  TodoItem copyWith({bool? done}) => TodoItem(
    title: title, icon: icon, type: type, done: done ?? this.done,
  );
}

enum TodoType { skincare, exfoliate, haircut, wardrobe }
