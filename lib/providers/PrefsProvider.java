import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsProvider extends ChangeNotifier {
  static const _keyTheme = "isDark";

  bool _isDark = false;
  bool get isDark => _isDark;

  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    _isDark = sp.getBool(_keyTheme) ?? false;
    notifyListeners();
  }

  Future<void> setDark(bool value) async {
    _isDark = value;
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_keyTheme, value);
    notifyListeners();
  }
}
