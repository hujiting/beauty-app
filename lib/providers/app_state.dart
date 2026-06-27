import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data.dart';

/// APP 全局状态管理 — 私人变美管家
class AppState extends ChangeNotifier {
  // ============ 基础用户数据 ============
  String _userName = '变美管家';
  String get userName => _userName;

  String _userBio = '找到属于自己的美';
  String get userBio => _userBio;

  // ============ 首次启动引导 ============
  bool _onboardingComplete = false;
  bool get onboardingComplete => _onboardingComplete;

  String? _gender; // 'male' or 'female'
  String? get gender => _gender;
  bool get isFemale => _gender == 'female';

  String? _styleResult;
  String? get styleResult => _styleResult;

  String? _skinKeyword;
  String? get skinKeyword => _skinKeyword;

  // ============ 收藏 ============
  final Set<int> _favoriteProductIds = {};
  Set<int> get favoriteProductIds => _favoriteProductIds;
  bool isFavorite(int id) => _favoriteProductIds.contains(id);

  // ============ 肤质/发质分析历史 ============
  final List<Map<String, dynamic>> _skinAnalysisHistory = [];
  List<Map<String, dynamic>> get skinAnalysisHistory => _skinAnalysisHistory;

  final List<Map<String, dynamic>> _hairAnalysisHistory = [];
  List<Map<String, dynamic>> get hairAnalysisHistory => _hairAnalysisHistory;

  // ============ 每日护肤打卡 ============
  final Map<String, bool> _skincareToday = {};
  Map<String, bool> get skincareToday => _skincareToday;

  final List<String> _skincareSteps = [
    '洁面',
    '爽肤水',
    '精华',
    '乳液/面霜',
    '防晒',
  ];
  List<String> get skincareSteps => _skincareSteps;

  // ============ 出片圣地收藏 ============
  final Set<String> _favoriteSpots = {};
  Set<String> get favoriteSpots => _favoriteSpots;
  bool isSpotFavorite(String spotName) => _favoriteSpots.contains(spotName);

  // ============ 初始化 ============
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? '变美管家';
    _userBio = prefs.getString('user_bio') ?? '找到属于自己的美';
    _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    _gender = prefs.getString('gender');
    _styleResult = prefs.getString('style_result');
    _skinKeyword = prefs.getString('skin_keyword');

    // 护肤今日打卡
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final skincareKey = 'skincare_$today';
    final skincareDone = prefs.getStringList(skincareKey) ?? [];
    for (final step in _skincareSteps) {
      _skincareToday[step] = skincareDone.contains(step);
    }

    // 肤质分析历史
    final skinHistory = prefs.getStringList('skin_history') ?? [];
    for (final item in skinHistory) {
      final parts = item.split('|');
      if (parts.length >= 3) {
        _skinAnalysisHistory.add({
          'date': parts[0],
          'result': parts[1],
          'summary': parts[2],
        });
      }
    }

    // 发质分析历史
    final hairHistory = prefs.getStringList('hair_history') ?? [];
    for (final item in hairHistory) {
      final parts = item.split('|');
      if (parts.length >= 3) {
        _hairAnalysisHistory.add({
          'date': parts[0],
          'result': parts[1],
          'summary': parts[2],
        });
      }
    }

    notifyListeners();
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

  // ============ 切换收藏 ============
  Future<void> toggleFavorite(int productId) async {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favorite_ids',
      _favoriteProductIds.map((id) => id.toString()).toList(),
    );
  }

  // ============ 肤质分析记录 ============
  Future<void> addSkinAnalysis({
    required String result,
    required String summary,
  }) async {
    final date = DateTime.now().toIso8601String().substring(0, 10);
    _skinAnalysisHistory.insert(0, {
      'date': date,
      'result': result,
      'summary': summary,
    });
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final history = _skinAnalysisHistory.map((e) => '${e['date']}|${e['result']}|${e['summary']}').toList();
    await prefs.setStringList('skin_history', history);
  }

  // ============ 发质分析记录 ============
  Future<void> addHairAnalysis({
    required String result,
    required String summary,
  }) async {
    final date = DateTime.now().toIso8601String().substring(0, 10);
    _hairAnalysisHistory.insert(0, {
      'date': date,
      'result': result,
      'summary': summary,
    });
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final history = _hairAnalysisHistory.map((e) => '${e['date']}|${e['result']}|${e['summary']}').toList();
    await prefs.setStringList('hair_history', history);
  }

  // ============ 护肤打卡 ============
  Future<void> toggleSkincareStep(String step) async {
    _skincareToday[step] = !(_skincareToday[step] ?? false);
    notifyListeners();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final prefs = await SharedPreferences.getInstance();
    final done = _skincareToday.entries.where((e) => e.value).map((e) => e.key).toList();
    await prefs.setStringList('skincare_$today', done);
  }

  // ============ 出片圣地收藏 ============
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
}
