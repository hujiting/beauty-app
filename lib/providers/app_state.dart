import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data.dart';

/// APP 全局状态管理
/// 管理用户数据、收藏、购物车等
class AppState extends ChangeNotifier {
  // ============ 用户数据 ============
  String _userName = 'Beauty用户';
  String get userName => _userName;

  String _userBio = '找到属于自己的美';
  String get userBio => _userBio;

  // ============ 收藏 ============
  final Set<int> _favoriteProductIds = {};
  Set<int> get favoriteProductIds => _favoriteProductIds;

  bool isFavorite(int productId) => _favoriteProductIds.contains(productId);

  // ============ 风格测试结果 ============
  String? _styleResult;
  String? get styleResult => _styleResult;

  // ============ 拍照记录 ============
  final List<String> _captureHistory = [];
  List<String> get captureHistory => _captureHistory;

  // ============ 初始化 ============
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? 'Beauty用户';
    _userBio = prefs.getString('user_bio') ?? '找到属于自己的美';
    _styleResult = prefs.getString('style_result');
    final favIds = prefs.getStringList('favorite_ids') ?? [];
    _favoriteProductIds.addAll(favIds.map(int.parse));
    _captureHistory.addAll(prefs.getStringList('capture_history') ?? []);
    notifyListeners();
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

  // ============ 保存风格测试 ============
  Future<void> saveStyleResult(String result) async {
    _styleResult = result;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('style_result', result);
  }

  // ============ 添加拍照记录 ============
  Future<void> addCapture(String imagePath) async {
    _captureHistory.insert(0, imagePath);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('capture_history', _captureHistory);
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
