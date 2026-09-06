import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// 分类（显示设备、音响设备……）
class CfeCategory {
  final String id;
  final String zh;
  final String en;
  final String ico;

  const CfeCategory({
    required this.id,
    required this.zh,
    required this.en,
    required this.ico,
  });

  factory CfeCategory.fromJson(Map<String, dynamic> j) => CfeCategory(
        id: j['id'] as String,
        zh: j['zh'] as String,
        en: (j['en'] as String?) ?? '',
        ico: (j['ico'] as String?) ?? '',
      );
}

/// 例句。role: 'ft' 外教常说（要听懂的）| 'me' 你可以说的
class Phrase {
  final String role;
  final String en;
  final String zh;

  const Phrase({required this.role, required this.en, required this.zh});

  bool get isStaff => role == 'me';

  factory Phrase.fromJson(Map<String, dynamic> j) => Phrase(
        role: (j['r'] as String?) ?? 'ft',
        en: j['en'] as String,
        zh: j['zh'] as String,
      );
}

/// 词条（教室设施设备）
class WordEntry {
  final String cat;
  final String en;
  final String ipa;
  final String zh;
  final List<Phrase> phrases;

  const WordEntry({
    required this.cat,
    required this.en,
    required this.ipa,
    required this.zh,
    required this.phrases,
  });

  String get favKey => 'w:$en';

  factory WordEntry.fromJson(Map<String, dynamic> j) => WordEntry(
        cat: j['c'] as String,
        en: j['en'] as String,
        ipa: (j['ipa'] as String?) ?? '',
        zh: j['zh'] as String,
        phrases: ((j['p'] as List?) ?? const [])
            .map((e) => Phrase.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// 常用短句
class Sentence {
  final String en;
  final String zh;

  const Sentence({required this.en, required this.zh});

  String get favKey => 's:$en';

  factory Sentence.fromJson(Map<String, dynamic> j) =>
      Sentence(en: j['en'] as String, zh: j['zh'] as String);
}

/// 短句分组（外教反馈故障 / 你指导外教操作 / 课堂沟通 / 应急安全）
class SentenceGroup {
  final String id;
  final String zh;
  final String ico;
  final List<Sentence> sentences;

  const SentenceGroup({
    required this.id,
    required this.zh,
    required this.ico,
    required this.sentences,
  });

  factory SentenceGroup.fromJson(Map<String, dynamic> j) => SentenceGroup(
        id: j['id'] as String,
        zh: j['zh'] as String,
        ico: (j['ico'] as String?) ?? '',
        sentences: ((j['s'] as List?) ?? const [])
            .map((e) => Sentence.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// 全部词表数据
class CfeData {
  final List<CfeCategory> cats;
  final List<WordEntry> words;
  final List<SentenceGroup> groups;

  const CfeData({
    required this.cats,
    required this.words,
    required this.groups,
  });

  int countOf(String catId) => words.where((w) => w.cat == catId).length;

  CfeCategory catOf(String id) => cats.firstWhere(
        (c) => c.id == id,
        orElse: () => const CfeCategory(id: '', zh: '其他', en: '', ico: ''),
      );

  factory CfeData.fromJson(Map<String, dynamic> j) => CfeData(
        cats: (j['cats'] as List)
            .map((e) => CfeCategory.fromJson(e as Map<String, dynamic>))
            .toList(),
        words: (j['words'] as List)
            .map((e) => WordEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        groups: (j['groups'] as List)
            .map((e) => SentenceGroup.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// 中英文双向匹配
bool wordMatches(WordEntry w, String query) {
  if (query.isEmpty) return true;
  final k = query.toLowerCase();
  if (w.en.toLowerCase().contains(k)) return true;
  if (w.zh.contains(query)) return true;
  return w.phrases
      .any((p) => p.en.toLowerCase().contains(k) || p.zh.contains(query));
}

bool sentenceMatches(Sentence s, String query) {
  if (query.isEmpty) return true;
  final k = query.toLowerCase();
  return s.en.toLowerCase().contains(k) || s.zh.contains(query);
}

/// 读取 assets/data/cfe.json
class DataRepository {
  DataRepository._();

  static CfeData? _cache;

  static Future<CfeData> load() async {
    final cached = _cache;
    if (cached != null) return cached;
    final text = await rootBundle.loadString('assets/data/cfe.json');
    final data = CfeData.fromJson(json.decode(text) as Map<String, dynamic>);
    _cache = data;
    return data;
  }
}
