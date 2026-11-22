import 'dart:math';

import '../models.dart';

/// 练习题型
enum QuizType { picChoice, picFill, listenChoice, listenSentence, listenFill }

class QuizTypeOption {
  final QuizType type;
  final String label;
  final String desc;

  const QuizTypeOption(this.type, this.label, this.desc);
}

const List<QuizTypeOption> quizTypeOptions = [
  QuizTypeOption(QuizType.picChoice, '看图选词', '看图形，4 选 1 英文'),
  QuizTypeOption(QuizType.picFill, '看图填空', '看图形和中文，拼写英文'),
  QuizTypeOption(QuizType.listenChoice, '听音选词', '听发音，4 选 1 英文'),
  QuizTypeOption(QuizType.listenSentence, '听音选句', '听英文句子，选中文意思'),
  QuizTypeOption(QuizType.listenFill, '听音填空', '听发音，拼写单词'),
];

/// 一道练习题
class QuizQuestion {
  const QuizQuestion({
    required this.type,
    required this.prompt,
    required this.answer,
    required this.answerZh,
    this.emoji,
    this.audioText,
    this.hint,
    this.options = const [],
    this.word,
  });

  final QuizType type;
  final String? emoji;
  final String? audioText;
  final String prompt;
  final String? hint;
  final String answer;
  final String answerZh;
  final List<String> options;
  final WordEntry? word;

  bool get isChoice => options.isNotEmpty;
}

/// 从词表自动出题
class QuizBank {
  QuizBank._();

  static List<QuizQuestion> build({
    required CfeData data,
    required List<QuizType> types,
    required Set<String> favs,
    String? catId,
    bool favsOnly = false,
    int count = 10,
    Random? rng,
  }) {
    final r = rng ?? Random();
    final words = data.words
        .where((w) => catId == null || w.cat == catId)
        .where((w) => !favsOnly || favs.contains(w.favKey))
        .toList();
    final sentences = <Sentence>[];
    for (final g in data.groups) {
      sentences.addAll(g.sentences);
    }
    if (words.isEmpty) return const [];

    final questions = <QuizQuestion>[];
    final pool = types
        .where((t) => t != QuizType.listenSentence || sentences.isNotEmpty)
        .toList();
    if (pool.isEmpty) return questions;

    for (var i = 0; i < count; i++) {
      final type = pool[r.nextInt(pool.length)];
      final q = _make(type, words, sentences, r);
      if (q != null) questions.add(q);
    }
    return questions;
  }

  static QuizQuestion? _make(
    QuizType type,
    List<WordEntry> words,
    List<Sentence> sentences,
    Random r,
  ) {
    final w = words[r.nextInt(words.length)];
    switch (type) {
      case QuizType.picChoice:
        return QuizQuestion(
          type: type,
          emoji: w.ico,
          prompt: '这个图形对应的设备是？',
          answer: w.en,
          answerZh: w.zh,
          options: _options(w.en, words.map((e) => e.en).toList(), r),
          word: w,
        );
      case QuizType.picFill:
        return QuizQuestion(
          type: type,
          emoji: w.ico,
          prompt: '看图拼写：这个设备的英文是？',
          hint: w.zh,
          answer: w.en,
          answerZh: w.zh,
          word: w,
        );
      case QuizType.listenChoice:
        return QuizQuestion(
          type: type,
          audioText: w.en,
          prompt: '听发音，选出对应的设备',
          answer: w.en,
          answerZh: w.zh,
          options: _options(w.en, words.map((e) => e.en).toList(), r),
          word: w,
        );
      case QuizType.listenSentence:
        if (sentences.isEmpty) return null;
        final s = sentences[r.nextInt(sentences.length)];
        return QuizQuestion(
          type: type,
          audioText: s.en,
          prompt: '听句子，选出它的中文意思',
          answer: s.zh,
          answerZh: s.en,
          options: _options(
              s.zh, sentences.map((e) => e.zh).toList(), r),
          word: null,
        );
      case QuizType.listenFill:
        return QuizQuestion(
          type: type,
          audioText: w.en,
          prompt: '听发音，拼写这个设备',
          hint: w.zh,
          answer: w.en,
          answerZh: w.zh,
          word: w,
        );
    }
  }

  /// 生成 4 个选项（含正确答案），随机排序
  static List<String> _options(String answer, List<String> pool, Random r) {
    final opts = <String>{answer};
    final shuffled = pool.toList()..shuffle(r);
    for (final p in shuffled) {
      if (opts.length >= 4) break;
      if (p != answer) opts.add(p);
    }
    return opts.toList()..shuffle(r);
  }

  /// 填空答案判定：忽略大小写、空格与句末标点
  static bool checkFill(String input, String answer) {
    String norm(String s) =>
        s.toLowerCase().replaceAll(RegExp(r'[\s.!?，。]+'), '').trim();
    return norm(input) == norm(answer);
  }
}
