import 'package:flutter/material.dart';
import '../quiz/quiz_bank.dart';
import '../tts_service.dart';
import '../widgets/cards.dart';

/// 答题页：逐题作答 → 即时反馈 → 成绩回顾
class QuizRunPage extends StatefulWidget {
  const QuizRunPage({
    super.key,
    required this.questions,
    required this.subtitle,
  });

  final List<QuizQuestion> questions;
  final String subtitle;

  @override
  State<QuizRunPage> createState() => _QuizRunPageState();
}

enum _Phase { answering, revealed, finished }

class _QuizRunPageState extends State<QuizRunPage> {
  int _index = 0;
  _Phase _phase = _Phase.answering;

  String? _picked; // 选择题已选的选项
  bool _lastCorrect = false;

  int _correct = 0;
  final List<QuizQuestion> _wrong = <QuizQuestion>[];

  final TextEditingController _fillCtrl = TextEditingController();
  final FocusNode _fillFocus = FocusNode();

  QuizQuestion get _q => widget.questions[_index];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onShowQuestion());
  }

  @override
  void dispose() {
    _fillCtrl.dispose();
    _fillFocus.dispose();
    super.dispose();
  }

  void _onShowQuestion() {
    _fillCtrl.clear();
    _picked = null;
        if (_q.audioText != null) {
      TtsService.instance.speak(_q.audioText!);
    }
  }

  void _answer(String? picked, bool correct) {
    setState(() {
      _picked = picked;
      _phase = _Phase.revealed;
      _lastCorrect = correct;
      if (correct) {
        _correct++;
      } else {
        _wrong.add(_q);
      }
    });
  }

  void _submitFill() {
    if (_phase != _Phase.answering) return;
    final text = _fillCtrl.text.trim();
    if (text.isEmpty) return;
    _answer(text, QuizBank.checkFill(text, _q.answer));
    _fillFocus.unfocus();
  }

  void _next() {
    if (_index + 1 >= widget.questions.length) {
      setState(() => _phase = _Phase.finished);
      return;
    }
    setState(() {
      _index++;
      _phase = _Phase.answering;
    });
    _onShowQuestion();
  }

  void _restart() {
    setState(() {
      _index = 0;
      _phase = _Phase.answering;
      _correct = 0;
      _wrong.clear();
    });
    _onShowQuestion();
  }

  void _speak(String text) => TtsService.instance.speak(text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('练习'),
            Text(widget.subtitle, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
      body: _phase == _Phase.finished
          ? _buildResult(theme)
          : _buildQuestion(theme),
    );
  }

  // ---------- 答题 ----------

  Widget _buildQuestion(ThemeData theme) {
    final q = _q;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (_index + 1) / widget.questions.length,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${_index + 1}/${widget.questions.length} · 对 $_correct',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(q.prompt, style: theme.textTheme.titleMedium),
              const SizedBox(height: 20),
              _buildStem(theme),
              const SizedBox(height: 24),
              if (q.isChoice)
                ..._buildChoices(theme)
              else ...[
                _buildFill(theme),
                const SizedBox(height: 12),
              ],
              if (_phase == _Phase.revealed) ...[
                const SizedBox(height: 8),
                _buildFeedback(theme),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _phase == _Phase.revealed ? _next : null,
              icon: Icon(_index + 1 >= widget.questions.length
                  ? Icons.emoji_events_rounded
                  : Icons.arrow_forward_rounded),
              label: Text(_phase == _Phase.revealed
                  ? (_index + 1 >= widget.questions.length
                      ? '查看成绩'
                      : '下一题')
                  : _pickHint()),
            ),
          ),
        ),
      ],
    );
  }

  String _pickHint() {
    if (_q.isChoice) return '点上方选项作答';
    return '输入后点「提交」或按回车';
  }

  /// 题干：大图形 或 播放按钮
  Widget _buildStem(ThemeData theme) {
    final isListen =
        _q.type == QuizType.listenChoice ||
            _q.type == QuizType.listenSentence ||
            _q.type == QuizType.listenFill;
    return Center(
      child: Column(
        children: [
          if (_q.emoji != null)
            Text(_q.emoji!, style: const TextStyle(fontSize: 84)),
          if (_q.audioText != null)
            Column(
              children: [
                IconButton.filledTonal(
                  onPressed: () => _speak(_q.audioText!),
                  icon: const Icon(Icons.volume_up_rounded, size: 36),
                ),
                const SizedBox(height: 4),
                Text(
                  '点一下再听一遍',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
                if (isListen && _q.type == QuizType.listenFill &&
                    _phase == _Phase.answering) ...[
                  const SizedBox(height: 6),
                  Text('提示：${_q.hint ?? ''}',
                      style: theme.textTheme.bodySmall),
                ],
              ],
            ),
          if (_q.emoji != null && _q.hint != null && _phase == _Phase.answering)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('提示：${_q.hint}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline)),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildChoices(ThemeData theme) {
    return _q.options.map((opt) {
      final revealed = _phase == _Phase.revealed;
      final isAnswer = opt == _q.answer;
      final isPicked = opt == _picked;
      Color? bg;
      Color? fg;
      if (revealed && isAnswer) {
        bg = Colors.green.shade100;
        fg = Colors.green.shade900;
      } else if (revealed && isPicked && !isAnswer) {
        bg = Colors.red.shade100;
        fg = Colors.red.shade900;
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: bg ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: revealed ? null : () => _answer(opt, opt == _q.answer),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      opt,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: fg,
                      ),
                    ),
                  ),
                  if (revealed && isAnswer)
                    Icon(Icons.check_circle_rounded,
                        color: Colors.green.shade700, size: 20),
                  if (revealed && isPicked && !isAnswer)
                    Icon(Icons.cancel_rounded,
                        color: Colors.red.shade700, size: 20),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildFill(ThemeData theme) {
    final revealed = _phase == _Phase.revealed;
    return Column(
      children: [
        TextField(
          controller: _fillCtrl,
          focusNode: _fillFocus,
          enabled: !revealed,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submitFill(),
          decoration: InputDecoration(
            hintText: '输入英文（不区分大小写）',
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 10),
        if (!revealed)
          FilledButton(
            onPressed: _submitFill,
            child: const Text('提交'),
          ),
      ],
    );
  }

  Widget _buildFeedback(ThemeData theme) {
    final ok = _lastCorrect;
    return Card(
      color: ok ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  ok ? Icons.check_circle_rounded : Icons.info_rounded,
                  color: ok ? Colors.green.shade700 : Colors.red.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  ok ? '答对了！' : '答错了',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: ok ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                ),
                const Spacer(),
                if (ok)
                  Text(
                    '已连对 $_correct',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _q.isChoice && !ok ? '正确答案：${_q.answer}' : _q.answer,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(_q.answerZh, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: () => _speak(_q.audioText ?? _q.answer),
              icon: const Icon(Icons.volume_up_rounded, size: 18),
              label: Text(_q.audioText != null ? '再听一遍' : '读一遍'),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- 成绩 ----------

  Widget _buildResult(ThemeData theme) {
    final total = widget.questions.length;
    final rate = total == 0 ? 0 : (_correct * 100 ~/ total);
    final msg = rate >= 90
        ? '太棒了！🎉'
        : rate >= 70
            ? '不错，继续保持！'
            : '多练几遍就熟了';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  '$_correct / $total',
                  style: theme.textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text('正确率 $rate% · $msg',
                    style: theme.textTheme.titleMedium),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_wrong.isNotEmpty) ...[
          const GroupHeader(text: '📕 错题回顾（点击可发音）'),
          ..._wrong.map((w) => Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  leading: Text(w.emoji ?? '📦',
                      style: const TextStyle(fontSize: 26)),
                  title: Text(w.answer,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(w.answerZh),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up_rounded),
                    onPressed: () => _speak(w.audioText ?? w.answer),
                  ),
                ),
              )),
        ] else ...[
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text('全部答对，太厉害了！🌟')),
            ),
          ),
        ],
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _restart,
          icon: const Icon(Icons.replay_rounded),
          label: const Text('再来一轮'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
          label: const Text('返回设置'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
