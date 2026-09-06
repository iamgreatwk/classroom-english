import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'audio/audio_player.dart';

/// 文件名规则，必须与 tools/gen_audio.py 的 slug() 完全一致
String audioSlug(String text) {
  final s = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  final t = s.replaceFirst(RegExp(r'^_+'), '').replaceFirst(RegExp(r'_+$'), '');
  return t.length <= 60 ? t : t.substring(0, 60);
}

/// 离线发音：播放微软神经语音生成的 MP3（assets/audio/）
/// 没有对应音频时返回 false，交由系统朗读兜底
class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  /// Web 走浏览器原生 Audio，iOS/Android 走 audioplayers 原生播放器
  final PlatformAudioPlayer _player = PlatformAudioPlayer();
  final Map<String, Set<String>> _manifest = <String, Set<String>>{};

  bool _loaded = false;

  /// 是否优先使用离线音频
  bool enabled = true;

  double rate = 1.0;
  bool slow = false;

  /// 是否已打包离线音频
  bool get hasPack => _manifest.isNotEmpty;

  int countOf(String accent) => _manifest[accent]?.length ?? 0;

  Future<void> init() async {
    if (_loaded) return;
    try {
      final text = await rootBundle.loadString('assets/audio/manifest.json');
      final decoded = json.decode(text) as Map<String, dynamic>;
      for (final entry in decoded.entries) {
        final keys = (entry.value as Map).keys.map((k) => k.toString()).toSet();
        _manifest[entry.key] = keys;
      }
    } catch (e) {
      debugPrint('离线音频清单加载失败，全部走系统朗读：$e');
      _manifest.clear();
    }
    debugPrint(_manifest.isEmpty
        ? '离线音频清单：无'
        : '离线音频清单：${_manifest.entries.map((e) => '${e.key}=${e.value.length}').join(', ')}');
    _loaded = true;
  }

  bool has(String accent, String text) =>
      _manifest[accent]?.contains(audioSlug(text)) ?? false;

  /// 播放离线音频，成功返回 true；任何环节失败都回退到系统朗读
  Future<bool> play(String accent, String text) async {
    final name = '${audioSlug(text)}.mp3';
    if (!enabled) {
      debugPrint('离线音频已关闭：$name');
      return false;
    }
    if (!has(accent, text)) {
      debugPrint('没有这条离线音频：$accent/$name');
      return false;
    }
    try {
      // 传 pubspec 里登记的完整资源路径
      final ok = await _player.play('assets/audio/$accent/$name');
      debugPrint(ok
          ? '离线音频播放：$accent/$name'
          : '离线音频播放失败，回退系统朗读：$name');
      return ok;
    } catch (e) {
      debugPrint('离线音频不可用，回退系统朗读：$name -> $e');
      return false;
    }
  }

  Future<void> stop() => _player.stop();
}
