/// 兜底实现（理论上不会被选中，仅保证条件导出一定有实现）
class PlatformAudioPlayer {
  Future<bool> play(String assetPath) async => false;

  Future<void> stop() async {}
}
