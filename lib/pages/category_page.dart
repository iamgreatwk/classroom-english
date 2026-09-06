import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import '../settings_store.dart';
import '../tts_service.dart';
import '../widgets/cards.dart';

/// 分类内的词条列表
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required this.category, required this.words});

  final CfeCategory category;
  final List<WordEntry> words;

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
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${category.ico} ${category.zh}'),
                if (category.en.isNotEmpty)
                  Text(
                    category.en,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          body: words.isEmpty
              ? const EmptyView(text: '这个分类还没有词条')
              : ListView(
                  children: [
                    const SizedBox(height: 6),
                    ...words.map(
                      (w) => WordCard(
                        key: ValueKey('c:${w.en}'),
                        word: w,
                        hideZh: store.hideZh,
                        isFav: store.isFav(w.favKey),
                        onSpeak: _speak,
                        onToggleFav: () => store.toggleFav(w.favKey),
                        onCopy: (t) => _copy(context, t),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
        );
      },
    );
  }
}
