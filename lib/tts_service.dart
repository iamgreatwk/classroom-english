import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// 朗读服务：口音、语速、慢速
class TtsService {
  TtsService._();

  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();

  String accent = 'en-US';
  double rate = 1.0;
  bool slow = false;

  bool _ready = false;
  bool _available = true;

  /// 浏览器/系统不支持朗读时为 false，UI 可据此提示
  bool get available => _available;

  String? _error;

  String? get lastError => _error;

  Future<void> init() async {
    if (_ready) return;
    try {
      _tts.setErrorHandler((msg) {
        _error = msg.toString();
        debugPrint('TTS error: $_error');
      });
      await _tts.setLanguage(accent);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _applyRate();
      _ready = true;
    } catch (e) {
      _error = e.toString();
      _available = false;
      debugPrint('TTS init failed: $e');
    }
  }

  Future<void> _applyRate() async {
    // flutter_tts 的语速基准为 0.5（0~1）
    final r = (0.5 * rate * (slow ? 0.7 : 1.0)).clamp(0.1, 1.0);
    await _tts.setSpeechRate(r);
  }

  Future<void> applySettings({
    required String accent,
    required double rate,
    required bool slow,
  }) async {
    this.accent = accent;
    this.rate = rate;
    this.slow = slow;
    if (!_ready) return;
    try {
      await _tts.setLanguage(accent);
      await _applyRate();
    } catch (e) {
      debugPrint('TTS applySettings failed: $e');
    }
  }

  Future<void> speak(String text) async {
    final t = text.trim();
    if (t.isEmpty) return;
    await init();
    if (!_available) return;
    try {
      await _tts.stop();
      await _tts.setLanguage(accent);
      await _applyRate();
      final result = await _tts.speak(t);
      debugPrint('TTS speak: $t -> $result');
    } catch (e) {
      _error = e.toString();
      debugPrint('TTS speak failed: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
