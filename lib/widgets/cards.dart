import 'package:flutter/material.dart';

import '../models.dart';

/// 可点击发音的文本行
class SpeakLine extends StatelessWidget {
  const SpeakLine({
    super.key,
    required this.text,
    required this.onSpeak,
    this.style,
    this.maxLines,
  });

  final String text;
  final ValueChanged<String> onSpeak;
  final TextStyle? style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onSpeak(text),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                Icons.volume_up_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: style,
                maxLines: maxLines,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 角色标签：外教 / 你说
class RoleChip extends StatelessWidget {
  const RoleChip({super.key, required this.isStaff});

  final bool isStaff;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = isStaff
        ? theme.colorScheme.tertiaryContainer
        : theme.colorScheme.primaryContainer;
    final fg = isStaff
        ? theme.colorScheme.onTertiaryContainer
        : theme.colorScheme.onPrimaryContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isStaff ? '你说' : '外教',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}

typedef SpeakCallback = void Function(String text);

/// 词条卡片
class WordCard extends StatelessWidget {
  const WordCard({
    super.key,
    required this.word,
    required this.hideZh,
    required this.isFav,
    required this.onSpeak,
    required this.onToggleFav,
    required this.onCopy,
  });

  final WordEntry word;
  final bool hideZh;
  final bool isFav;
  final SpeakCallback onSpeak;
  final VoidCallback onToggleFav;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpeakLine(
                        text: word.en,
                        onSpeak: onSpeak,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      if (word.ipa.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            word.ipa,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      if (!hideZh)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(word.zh, style: theme.textTheme.bodyMedium),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(isFav ? Icons.star_rounded : Icons.star_border_rounded),
                  color: isFav ? Colors.amber : theme.colorScheme.outline,
                  tooltip: '收藏',
                  onPressed: onToggleFav,
                ),
                IconButton(
                  icon: const Icon(Icons.copy_all_rounded),
                  color: theme.colorScheme.outline,
                  tooltip: '复制',
                  onPressed: () => onCopy(word.en),
                ),
              ],
            ),
            if (word.phrases.isNotEmpty) ...[
              const Divider(height: 18),
              ...word.phrases.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RoleChip(isStaff: p.isStaff),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SpeakLine(
                              text: p.en,
                              onSpeak: onSpeak,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            if (!hideZh)
                              Text(
                                p.zh,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: theme.colorScheme.outline),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 短句卡片
class SentenceCard extends StatelessWidget {
  const SentenceCard({
    super.key,
    required this.sentence,
    required this.hideZh,
    required this.isFav,
    required this.onSpeak,
    required this.onToggleFav,
    required this.onCopy,
  });

  final Sentence sentence;
  final bool hideZh;
  final bool isFav;
  final SpeakCallback onSpeak;
  final VoidCallback onToggleFav;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpeakLine(
                    text: sentence.en,
                    onSpeak: onSpeak,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (!hideZh)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(sentence.zh, style: theme.textTheme.bodyMedium),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(isFav ? Icons.star_rounded : Icons.star_border_rounded),
              color: isFav ? Colors.amber : theme.colorScheme.outline,
              tooltip: '收藏',
              onPressed: onToggleFav,
            ),
            IconButton(
              icon: const Icon(Icons.copy_all_rounded),
              color: theme.colorScheme.outline,
              tooltip: '复制',
              onPressed: () => onCopy(sentence.en),
            ),
          ],
        ),
      ),
    );
  }
}

/// 分组标题
class GroupHeader extends StatelessWidget {
  const GroupHeader({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.outline),
      ),
    );
  }
}

/// 空态
class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.text, this.icon = Icons.inbox_rounded});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.outlineVariant),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}

/// 搜索框
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = '搜索中文或英文',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 15),
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
        isDense: true,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
      ),
    );
  }
}
