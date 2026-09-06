import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tts_service.dart';

/// 收藏与设置的本地存储（收藏键：'w:单词' / 's:句子'）
class SettingsStore extends ChangeNotifier {
  SettingsStore._();

  static final SettingsStore instance = SettingsStore._();

  static const _kAccent = 'accent';
  static const _kRate = 'rate';
  static const _kSlow = 'slow';
  static const _kHideZh = 'hideZh';
  static const _kFavs = 'favs';

  String accent = 'en-US';
  double rate = 1.0;
  bool slow = false;
  bool hideZh = false;

  final Set<String> favs = <String>{};

  bool get isLoaded => _loaded;
  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    accent = prefs.getString(_kAccent) ?? accent;
    rate = prefs.getDouble(_kRate) ?? rate;
    slow = prefs.getBool(_kSlow) ?? slow;
    hideZh = prefs.getBool(_kHideZh) ?? hideZh;
    favs
      ..clear()
      ..addAll(prefs.getStringList(_kFavs) ?? const <String>[]);
    _loaded = true;
    await TtsService.instance.applySettings(
      accent: accent,
      rate: rate,
      slow: slow,
    );
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAccent, accent);
    await prefs.setDouble(_kRate, rate);
    await prefs.setBool(_kSlow, slow);
    await prefs.setBool(_kHideZh, hideZh);
    await prefs.setStringList(_kFavs, favs.toList());
  }

  Future<void> _applyTts() => TtsService.instance.applySettings(
        accent: accent,
        rate: rate,
        slow: slow,
      );

  Future<void> setAccent(String v) async {
    accent = v;
    notifyListeners();
    await _applyTts();
    await _save();
  }

  Future<void> setRate(double v) async {
    rate = v;
    notifyListeners();
    await _applyTts();
    await _save();
  }

  Future<void> setSlow(bool v) async {
    slow = v;
    notifyListeners();
    await _applyTts();
    await _save();
  }

  Future<void> setHideZh(bool v) async {
    hideZh = v;
    notifyListeners();
    await _save();
  }

  bool isFav(String key) => favs.contains(key);

  Future<void> toggleFav(String key) async {
    if (favs.contains(key)) {
      favs.remove(key);
    } else {
      favs.add(key);
    }
    notifyListeners();
    await _save();
  }
}
