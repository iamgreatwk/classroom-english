import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import '../settings_store.dart';
import '../tts_service.dart';
import '../widgets/cards.dart';

/// 常用短句页
class SentencesPage extends StatefulWidget {
  const SentencesPage({super.key, required this.data});

  final CfeData data;

  @override
  State<SentencesPage> createState() => _SentencesPageState();
}

class _SentencesPageState extends State<SentencesPage> {
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
        final items = <Widget>[];
        var total = 0;

        for (final g in widget.data.groups) {
          final list = g.sentences
              .where((s) => sentenceMatches(s, q))
              .toList();
          if (list.isEmpty) continue;
          total += list.length;
          items.add(GroupHeader(text: '${g.ico} ${g.zh}'));
          for (final s in list) {
            items.add(SentenceCard(
              key: ValueKey('s:${s.en}'),
              sentence: s,
              hideZh: store.hideZh,
              isFav: store.isFav(s.favKey),
              onSpeak: _speak,
              onToggleFav: () => store.toggleFav(s.favKey),
              onCopy: _copy,
            ));
          }
        }

        return Scaffold(
          appBar: AppBar(title: const Text('常用短句')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                child: SearchField(
                  controller: _ctrl,
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              Expanded(
                child: total == 0
                    ? const EmptyView(
                        text: '没有匹配的句子',
                        icon: Icons.search_off_rounded,
                      )
                    : ListView(
                        children: [
                          const SizedBox(height: 6),
                          ...items,
                          const SizedBox(height: 24),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
