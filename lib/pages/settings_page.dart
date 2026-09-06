import 'package:flutter/material.dart';

import '../audio_service.dart';
import '../models.dart';
import '../settings_store.dart';
import '../tts_service.dart';

/// 设置页：口音 / 语速 / 慢速 / 隐藏中文 / 试听
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.data});

  final CfeData data;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsStore.instance,
      builder: (context, _) {
        final store = SettingsStore.instance;
        final tts = TtsService.instance;
        final phraseCount =
            data.words.fold<int>(0, (sum, w) => sum + w.phrases.length);
        final sentCount =
            data.groups.fold<int>(0, (sum, g) => sum + g.sentences.length);

        return Scaffold(
          appBar: AppBar(title: const Text('设置')),
          body: ListView(
            children: [
              const _SectionTitle('发音'),
              _OfflineAudioTile(store: store),
              ListTile(
                leading: const Icon(Icons.record_voice_over_rounded),
                title: const Text('口音'),
                trailing: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'en-US', label: Text('美音')),
                    ButtonSegment(value: 'en-GB', label: Text('英音')),
                  ],
                  selected: {store.accent},
                  onSelectionChanged: (s) => store.setAccent(s.first),
                ),
              ),
              _VoicePicker(store: store, tts: tts),
              ListTile(
                leading: const Icon(Icons.speed_rounded),
                title: Text('语速 ${store.rate.toStringAsFixed(1)}×'),
                subtitle: Slider(
                  value: store.rate,
                  min: 0.6,
                  max: 1.3,
                  divisions: 7,
                  label: store.rate.toStringAsFixed(1),
                  onChanged: (v) => store.setRate(v),
                ),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.slow_motion_video_rounded),
                title: const Text('慢速朗读'),
                subtitle: const Text('放慢句子，方便听清'),
                value: store.slow,
                onChanged: (v) => store.setSlow(v),
              ),
              ListTile(
                leading: const Icon(Icons.play_arrow_rounded),
                title: const Text('试听'),
                subtitle: Text(
                  tts.available ? '点右边试听一句' : '当前设备不支持朗读',
                  style: tts.available
                      ? null
                      : TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                trailing: IconButton.filledTonal(
                  icon: const Icon(Icons.volume_up_rounded),
                  onPressed: () =>
                      tts.speak('The projector is working now.'),
                ),
              ),
              const Divider(height: 8),
              const _SectionTitle('显示'),
              SwitchListTile(
                secondary: const Icon(Icons.translate_rounded),
                title: const Text('隐藏中文'),
                subtitle: const Text('给外教看 / 自测'),
                value: store.hideZh,
                onChanged: (v) => store.setHideZh(v),
              ),
              const Divider(height: 8),
              const _SectionTitle('关于'),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('词表规模'),
                subtitle: Text(
                  '${data.words.length} 个词条 · $phraseCount 条例句 · $sentCount 条短句',
                ),
              ),
              const ListTile(
                leading: Icon(Icons.offline_bolt_rounded),
                title: Text('完全离线'),
                subtitle: Text('词表与朗读都不需要联网，收藏保存在本机'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

/// 离线真人发音（微软神经语音 MP3）开关
class _OfflineAudioTile extends StatelessWidget {
  const _OfflineAudioTile({required this.store});

  final SettingsStore store;

  @override
  Widget build(BuildContext context) {
    final audio = AudioService.instance;
    final n = audio.countOf(store.accent);
    final accentName = store.accent == 'en-GB' ? '英音' : '美音';
    return SwitchListTile(
      secondary: const Icon(Icons.high_quality_rounded),
      title: const Text('离线真人发音'),
      subtitle: Text(
        audio.hasPack
            ? '微软神经语音，已打包$accentName $n 条'
            : '未打包离线音频，使用系统语音',
      ),
      value: store.offlineAudio && audio.hasPack,
      onChanged: audio.hasPack ? (v) => store.setOfflineAudio(v) : null,
    );
  }
}

/// 音色选择：列出设备上可用的英语语音
class _VoicePicker extends StatelessWidget {
  const _VoicePicker({required this.store, required this.tts});

  final SettingsStore store;
  final TtsService tts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StatefulBuilder(
      builder: (context, setLocal) {
        final voices = tts.voices;
        final names = voices.map((v) => v.name).toList();
        final current = names.contains(store.voiceName) ? store.voiceName : null;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded, size: 22),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text('音色', style: theme.textTheme.titleMedium),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await tts.refreshVoices();
                      setLocal(() {});
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('重新检测'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                voices.isEmpty
                    ? '当前设备没有可选的英语语音，用的是系统默认音。\n'
                        'iPhone：设置 → 辅助功能 → 朗读内容 → 声音 → 英语，'
                        '下载一个「增强」语音后回来点「重新检测」。'
                    : '选一个听着最舒服的，选完点下面的「试听」对比。',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline),
              ),
              if (voices.isNotEmpty) ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String?>(
                  value: current,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: <DropdownMenuItem<String?>>[
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('自动（系统挑选）'),
                    ),
                    ...voices.map(
                      (v) => DropdownMenuItem<String?>(
                        value: v.name,
                        child: Text(
                          v.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (v) => store.setVoice(v),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
