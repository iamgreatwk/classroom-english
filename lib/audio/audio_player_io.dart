import 'package:audioplayers/audioplayers.dart';

/// iOS / Android：用 audioplayers 走原生播放器
class PlatformAudioPlayer {
  AudioPlayer? _player;

  Future<bool> play(String assetPath) async {
    try {
      final player = _player ??= AudioPlayer();
      await player.stop();
      await player.play(AssetSource(assetPath));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _player?.stop();
    } catch (_) {}
  }
}
