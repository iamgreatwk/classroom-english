import 'dart:convert';

import 'package:classroom_english/models.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('词表 JSON 可解析且结构完整', () async {
    final text = await rootBundle.loadString('assets/data/cfe.json');
    final data = CfeData.fromJson(json.decode(text) as Map<String, dynamic>);

    expect(data.cats.length, 8);
    expect(data.words.length, greaterThan(50));
    expect(data.groups.length, 8);

    // 每个词条的分类必须存在于分类表
    final ids = data.cats.map((c) => c.id).toSet();
    for (final w in data.words) {
      expect(ids.contains(w.cat), isTrue, reason: '未知分类：${w.cat}');
      expect(w.en, isNotEmpty);
      expect(w.zh, isNotEmpty);
    }

    // 例句角色只能是 ft / me
    for (final w in data.words) {
      for (final p in w.phrases) {
        expect(['ft', 'me'], contains(p.role));
      }
    }

    // 短句数量与数据一致（故障/指导/课堂/应急/问候/礼貌/失物/找教室）
    final n = data.groups.fold<int>(0, (s, g) => s + g.sentences.length);
    expect(n, 89);
  });
}
