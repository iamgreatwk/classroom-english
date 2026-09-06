import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import '../settings_store.dart';
import '../tts_service.dart';
import '../widgets/cards.dart';

/// 收藏页：收藏的单词 + 句子
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key, required this.data});

  final CfeData data;

  void _speak(String text) => TtsService.instance.speak(text);

  Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已复制：$text'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsStore.instance,
      builder: (context, _) {
        final store = SettingsStore.instance;
        final words =
            data.words.where((w) => store.isFav(w.favKey)).toList();
        final sentences = <Sentence>[];
        for (final g in data.groups) {
          for (final s in g.sentences) {
            if (store.isFav(s.favKey)) sentences.add(s);
          }
        }

        if (words.isEmpty && sentences.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('收藏')),
            body: const EmptyView(
              text: '还没有收藏\n点词条右上角的 ☆ 添加常用内容',
              icon: Icons.star_border_rounded,
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('收藏 (${words.length + sentences.length})'),
          ),
          body: ListView(
            children: [
              if (words.isNotEmpty) ...[
                GroupHeader(text: '📗 单词 (${words.length})'),
                ...words.map(
                  (w) => WordCard(
                    key: ValueKey('f:${w.en}'),
                    word: w,
                    hideZh: store.hideZh,
                    isFav: true,
                    onSpeak: _speak,
                    onToggleFav: () => store.toggleFav(w.favKey),
                    onCopy: (t) => _copy(context, t),
                  ),
                ),
              ],
              if (sentences.isNotEmpty) ...[
                GroupHeader(text: '💬 句子 (${sentences.length})'),
                ...sentences.map(
                  (s) => SentenceCard(
                    key: ValueKey('fs:${s.en}'),
                    sentence: s,
                    hideZh: store.hideZh,
                    isFav: true,
                    onSpeak: _speak,
                    onToggleFav: () => store.toggleFav(s.favKey),
                    onCopy: (t) => _copy(context, t),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
