import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import '../settings_store.dart';
import '../tts_service.dart';
import '../widgets/cards.dart';
import 'category_page.dart';

/// 词汇页：分类网格 + 搜索
class WordsPage extends StatefulWidget {
  const WordsPage({super.key, required this.data});

  final CfeData data;

  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {
  final TextEditingController _ctrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _speak(String text) => TtsService.instance.speak(text);

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
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
        final q = _query.trim();
        final searching = q.isNotEmpty;
        final results = searching
            ? widget.data.words.where((w) => wordMatches(w, q)).toList()
            : <WordEntry>[];

        return Scaffold(
          appBar: AppBar(
            title: const Text('教室设施英语'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: SearchField(
                  controller: _ctrl,
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
            ),
          ),
          body: searching
              ? _buildResults(results, store)
              : _buildCategories(context),
        );
      },
    );
  }

  Widget _buildCategories(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 190,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.25,
      ),
      itemCount: widget.data.cats.length,
      itemBuilder: (context, i) {
        final cat = widget.data.cats[i];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CategoryPage(
                  category: cat,
                  words: widget.data.words
                      .where((w) => w.cat == cat.id)
                      .toList(),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cat.ico, style: const TextStyle(fontSize: 26)),
                  const SizedBox(height: 6),
                  Text(
                    cat.zh,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cat.en,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${widget.data.countOf(cat.id)} 个词条',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResults(List<WordEntry> results, SettingsStore store) {
    if (results.isEmpty) {
      return const EmptyView(
        text: '没有匹配的词条\n换个中文或英文关键词试试',
        icon: Icons.search_off_rounded,
      );
    }
    // 按分类分组
    final groups = <String, List<WordEntry>>{};
    for (final w in results) {
      groups.putIfAbsent(w.cat, () => <WordEntry>[]).add(w);
    }
    final items = <Widget>[];
    for (final entry in groups.entries) {
      final cat = widget.data.catOf(entry.key);
      items.add(GroupHeader(text: '${cat.ico} ${cat.zh}'));
      for (final w in entry.value) {
        items.add(WordCard(
          key: ValueKey('w:${w.en}'),
          word: w,
          hideZh: store.hideZh,
          isFav: store.isFav(w.favKey),
          onSpeak: _speak,
          onToggleFav: () => store.toggleFav(w.favKey),
          onCopy: _copy,
        ));
      }
    }
    items.add(const SizedBox(height: 24));
    return ListView(children: items);
  }
}
