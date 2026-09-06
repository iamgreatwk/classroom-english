// 平台音频播放后端的统一入口（条件导出）
// Web：dart:html 的 AudioElement（读 asset 转 Blob 播放，不依赖插件）
// iOS / Android：audioplayers（原生 AVPlayer / MediaPlayer）
export 'audio_player_stub.dart'
    if (dart.library.html) 'audio_player_web.dart'
    if (dart.library.io) 'audio_player_io.dart';
