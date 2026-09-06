import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'audio_service.dart';

/// 一个可用的语音
class TtsVoice {
  const TtsVoice({required this.name, required this.locale});

  final String name;
  final String locale;

  @override
  String toString() => name;
}

/// 朗读服务：音色、口音、语速、慢速
class TtsService {
  TtsService._();

  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();

  String accent = 'en-US';
  double rate = 1.0;
  bool slow = false;

  /// 选中的音色名称，null/空 = 交给系统自动挑选
  String? voiceName;

  /// 设备上可用的英语语音
  final List<TtsVoice> voices = <TtsVoice>[];

  bool _ready = false;
  bool _available = true;

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
      await _loadVoices();
      await _applyVoice();
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _applyRate();
      _ready = true;
      debugPrint('TTS ready, 英语语音 ${voices.length} 个：'
          '${voices.map((v) => v.name).take(8).join(" / ")}');
    } catch (e) {
      _error = e.toString();
      _available = false;
      debugPrint('TTS init failed: $e');
    }
  }

  Future<void> _loadVoices() async {
    try {
      final raw = await _tts.getVoices;
      if (raw == null) return;
      voices
        ..clear()
        ..addAll(
          (raw as List)
              .whereType<Map>()
              .map(
                (m) => TtsVoice(
                  name: m['name']?.toString() ?? '',
                  locale: m['locale']?.toString() ?? '',
                ),
              )
              .where(
                (v) => v.name.isNotEmpty &&
                    v.locale.toLowerCase().startsWith('en'),
              )
              .toList(),
        );
      voices.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      debugPrint('TTS getVoices failed: $e');
    }
  }

  /// 应用当前音色设置（优先用指定音色，否则按口音交给系统挑）
  Future<void> _applyVoice() async {
    final v = voiceName;
    if (v != null && v.isNotEmpty) {
      final hit = voices.where((e) => e.name == v).toList();
      if (hit.isNotEmpty) {
        try {
          await _tts.setVoice({'name': hit.first.name, 'locale': hit.first.locale});
          return;
        } catch (e) {
          debugPrint('TTS setVoice failed: $e');
        }
      }
    }
    await _tts.setLanguage(accent);
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
    String? voiceName,
  }) async {
    this.accent = accent;
    this.rate = rate;
    this.slow = slow;
    if (voiceName != null) this.voiceName = voiceName;
    if (!_ready) return;
    try {
      await _applyVoice();
      await _applyRate();
    } catch (e) {
      debugPrint('TTS applySettings failed: $e');
    }
  }

  /// 朗读：优先离线音频（微软神经语音），没有则回退系统语音
  Future<void> speak(String text) async {
    final t = text.trim();
    if (t.isEmpty) return;

    final played = await AudioService.instance.play(accent, t);
    if (played) {
      debugPrint('TTS 离线音频：${audioSlug(t)}.mp3');
      return;
    }

    await init();
    if (!_available) return;
    try {
      await _tts.stop();
      await _applyVoice();
      await _applyRate();
      await _tts.speak(t);
    } catch (e) {
      _error = e.toString();
      debugPrint('TTS speak failed: $e');
    }
  }

  /// 重新检测可用语音（部分浏览器要等语音引擎就绪后才有列表）
  Future<void> refreshVoices() async {
    await _loadVoices();
    if (_ready) await _applyVoice();
  }

  /// 换个音色试听同一句，方便对比
  Future<void> preview(String voice, {String text = 'The projector is working now.'}) async {
    final old = voiceName;
    voiceName = voice;
    await speak(text);
    voiceName = old;
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
