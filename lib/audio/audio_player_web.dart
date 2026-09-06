// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/services.dart' show rootBundle;

/// Web 端：用浏览器原生 Audio 播放，不依赖任何插件
class PlatformAudioPlayer {
  html.AudioElement? _el;

  Future<bool> play(String assetPath) async {
    try {
      await stop();
      // 直接读 asset 字节转成 Blob URL，避免依赖 assetBase 拼接规则
      final data = await rootBundle.load(assetPath);
      final bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      final url = html.Url.createObjectUrlFromBlob(
        html.Blob([bytes], 'audio/mpeg'),
      );
      final el = html.AudioElement(url);
      _el = el;
      await el.play();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> stop() async {
    final el = _el;
    _el = null;
    if (el == null) return;
    try {
      el.pause();
      el.currentTime = 0;
    } catch (_) {}
  }
}
