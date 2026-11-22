import 'package:flutter/material.dart';

import '../models.dart';
import '../quiz/quiz_bank.dart';
import '../settings_store.dart';
import '../tts_service.dart';
import 'quiz_run_page.dart';

/// 练习入口：选择范围与题型
class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.data});

  final CfeData data;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String? _catId; // null = 全部分类
  bool _favsOnly = false;
  final Set<QuizType> _types = {...QuizType.values};
  bool _starting = false;

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _start() async {
    debugPrint('QUIZ: start pressed, types=$_types');
    if (_types.isEmpty) {
      _toast('请至少选择一种题型');
      return;
    }
    setState(() => _starting = true);
    try {
      await TtsService.instance.init(); // 听音题需要朗读就绪
      final questions = QuizBank.build(
        data: widget.data,
        types: _types.toList(),
        favs: SettingsStore.instance.favs,
        catId: _catId,
        favsOnly: _favsOnly,
        count: 10,
      );
      debugPrint('QUIZ: built ${questions.length} questions');
      if (!mounted) return;
      if (questions.isEmpty) {
        _toast(_favsOnly ? '收藏里没有可练习的内容，先去收藏几个吧' : '词表为空');
        return;
      }
      final catName =
          _catId == null ? '全部分类' : widget.data.catOf(_catId!).zh;
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => QuizRunPage(
          questions: questions,
          subtitle: '$catName · ${questions.length} 题',
        ),
      ));
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favCount = SettingsStore.instance.favs.length;

    return ListenableBuilder(
      listenable: SettingsStore.instance,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('练习')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
            children: [
              _section(theme, '范围', Icons.filter_alt_rounded, _rangeCard(theme, favCount)),
              _section(theme, '题型', Icons.checklist_rounded, _typeCard(theme)),
              const SizedBox(height: 4),
              FilledButton.icon(
                onPressed: _starting ? null : _start,
                icon: _starting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: Text(_starting ? '出题中…' : '开始练习（10 题）'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '题目从词表自动生成 · 每次随机\n答错的题结束后可以回顾',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _section(
      ThemeData theme, String title, IconData icon, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 14, 4, 6),
          child: Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(title,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Card(child: child),
      ],
    );
  }

  Widget _rangeCard(ThemeData theme, int favCount) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.category_rounded),
          title: const Text('词条分类'),
          trailing: DropdownButton<String?>(
            value: _catId,
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text('全部（${widget.data.words.length} 词）'),
              ),
              ...widget.data.cats.map(
                (c) => DropdownMenuItem<String?>(
                  value: c.id,
                  child: Text('${c.zh}（${widget.data.countOf(c.id)} 词）'),
                ),
              ),
            ],
            onChanged: (v) => setState(() => _catId = v),
          ),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.star_rounded),
          title: Text('只练收藏（$favCount 条）'),
          value: _favsOnly,
          onChanged: (v) => setState(() => _favsOnly = v),
        ),
      ],
    );
  }

  Widget _typeCard(ThemeData theme) {
    return Column(
      children: [
        for (final opt in quizTypeOptions)
          CheckboxListTile(
            secondary: Icon(_iconOf(opt.type), size: 24),
            title: Text(opt.label),
            subtitle: Text(opt.desc, style: theme.textTheme.bodySmall),
            value: _types.contains(opt.type),
            onChanged: (v) => setState(() {
              v! ? _types.add(opt.type) : _types.remove(opt.type);
            }),
          ),
      ],
    );
  }

  IconData _iconOf(QuizType t) {
    switch (t) {
      case QuizType.picChoice:
        return Icons.image_rounded;
      case QuizType.picFill:
        return Icons.edit_note_rounded;
      case QuizType.listenChoice:
        return Icons.headphones_rounded;
      case QuizType.listenSentence:
        return Icons.graphic_eq_rounded;
      case QuizType.listenFill:
        return Icons.keyboard_rounded;
    }
  }
}
