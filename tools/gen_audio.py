#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
用微软 Edge 神经语音批量生成离线发音包。

服务与 agent-os/tts/edge_tts.mjs 相同（speech.platform.bing.com + Sec-MS-GEC），
音色沿用 tts.sh 里验证过的清单，但直接输出 MP3（无需 webm/opus 解码转码）。

准备：
    python3 -m pip install --target /tmp/ttslib edge-tts

用法：
    PYTHONPATH=/tmp/ttslib python3 tools/gen_audio.py --list          # 看会生成哪些
    PYTHONPATH=/tmp/ttslib python3 tools/gen_audio.py --limit 5       # 先试 5 条
    PYTHONPATH=/tmp/ttslib python3 tools/gen_audio.py                 # 全部（美音+英音）
    PYTHONPATH=/tmp/ttslib python3 tools/gen_audio.py --accent en-US  # 只要美音
    PYTHONPATH=/tmp/ttslib python3 tools/gen_audio.py --proxy http://127.0.0.1:7890

产物：
    assets/audio/en-US/<slug>.mp3
    assets/audio/en-GB/<slug>.mp3
    assets/audio/manifest.json     App 据此判断哪些词有离线音频
"""
import argparse
import asyncio
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA = os.path.join(ROOT, 'assets', 'data', 'cfe.json')
OUT_DIR = os.path.join(ROOT, 'assets', 'audio')

# 音色（与 tts.sh 中验证过的微软神经语音一致）
VOICES = {
    'en-US': 'en-US-AriaNeural',   # 英文女声
    'en-GB': 'en-GB-SoniaNeural',  # 英式女声
}
# 备选：en-US-GuyNeural（英文男声）、en-US-JennyNeural、en-GB-RyanNeural


def slug(text):
    """文件名规则，必须与 Dart 侧 audioSlug() 完全一致"""
    s = re.sub(r'[^a-z0-9]+', '_', text.lower()).strip('_')
    return s[:60]


def collect(json_path):
    """收集所有需要朗读的英文文本"""
    data = json.load(open(json_path, encoding='utf-8'))
    texts = []
    for w in data['words']:
        texts.append(w['en'])
        for p in w.get('p', []):
            texts.append(p['en'])
    for g in data['groups']:
        for s in g.get('s', []):
            texts.append(s['en'])
    seen, out = set(), []
    for t in texts:
        t = t.strip()
        if t and t not in seen:
            seen.add(t)
            out.append(t)
    return out, data


def write_manifest(manifest):
    os.makedirs(OUT_DIR, exist_ok=True)
    path = os.path.join(OUT_DIR, 'manifest.json')
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(manifest, f, ensure_ascii=False, indent=0, sort_keys=True)
    return path


async def synth_one(sem, tts_mod, text, voice, path, proxy, force, rate):
    if os.path.exists(path) and os.path.getsize(path) > 800 and not force:
        return 'skip'
    async with sem:
        for attempt in range(3):
            try:
                kwargs = {'rate': rate, 'volume': '+0%', 'pitch': '+0Hz'}
                if proxy:
                    kwargs['proxy'] = proxy
                try:
                    comm = tts_mod.Communicate(text, voice, **kwargs)
                except TypeError:
                    kwargs.pop('proxy', None)
                    comm = tts_mod.Communicate(text, voice, **kwargs)
                tmp = path + '.part'
                await comm.save(tmp)
                if os.path.getsize(tmp) > 800:
                    os.replace(tmp, path)
                    return 'ok'
                os.remove(tmp)
            except Exception as e:  # noqa: BLE001
                if attempt == 2:
                    return 'fail:%s' % e
                await asyncio.sleep(1.5 * (attempt + 1))
        return 'fail:empty'


async def run(args, texts):
    sys.path.insert(0, '/tmp/ttslib')
    import edge_tts

    manifest = {}
    mpath = os.path.join(OUT_DIR, 'manifest.json')
    if os.path.exists(mpath):
        try:
            manifest = json.load(open(mpath, encoding='utf-8'))
        except Exception:  # noqa: BLE001
            manifest = {}

    items = texts[: args.limit] if args.limit else texts
    accents = [a.strip() for a in args.accent.split(',') if a.strip()]

    for acc in accents:
        voice = args.voice if (args.voice and len(accents) == 1) else VOICES.get(acc, VOICES['en-US'])
        d = os.path.join(OUT_DIR, acc)
        os.makedirs(d, exist_ok=True)

        sem = asyncio.Semaphore(args.jobs)
        tasks, pairs = [], []
        for t in items:
            name = slug(t)
            if not name:
                continue
            pairs.append((name, t))
            tasks.append(
                synth_one(sem, edge_tts, t, voice, os.path.join(d, name + '.mp3'),
                          args.proxy, args.force, args.rate)
            )
        results = await asyncio.gather(*tasks)

        ok = skip = fail = 0
        good = {}
        for (name, t), r in zip(pairs, results):
            if r == 'ok':
                ok += 1
                good[name] = t
            elif r == 'skip':
                skip += 1
                good[name] = t
            else:
                fail += 1
                print('  × %s -> %s' % (name, r))
        merged = dict(manifest.get(acc, {}))
        merged.update(good)
        if fail:
            for name in list(merged):
                if name in dict(pairs) and name not in good:
                    merged.pop(name, None)
        manifest[acc] = merged
        print('[%s/%s] 新增 %d · 已存在 %d · 失败 %d' % (acc, voice, ok, skip, fail))

    write_manifest(manifest)
    return manifest


def main():
    ap = argparse.ArgumentParser(description='生成微软神经语音离线发音包')
    ap.add_argument('--data', default=DATA)
    ap.add_argument('--accent', default='en-US,en-GB')
    ap.add_argument('--voice', default='', help='指定音色，如 en-US-GuyNeural')
    ap.add_argument('--rate', default='+0%', help='语速，如 -10%% 慢一点')
    ap.add_argument('--limit', type=int, default=0)
    ap.add_argument('--jobs', type=int, default=6, help='并发数')
    ap.add_argument('--force', action='store_true')
    ap.add_argument('--proxy', default=os.environ.get('HTTPS_PROXY') or os.environ.get('HTTP_PROXY') or '')
    ap.add_argument('--list', action='store_true')
    args = ap.parse_args()

    if not os.path.exists(args.data):
        sys.exit('找不到词表：%s' % args.data)

    texts, data = collect(args.data)
    n_phrase = sum(len(w.get('p', [])) for w in data['words'])
    n_sent = sum(len(g.get('s', [])) for g in data['groups'])
    print('词条 %d · 例句 %d · 短句 %d = 待合成 %d 条'
          % (len(data['words']), n_phrase, n_sent, len(texts)))

    if args.list:
        for t in texts[: args.limit or len(texts)]:
            print('%s\t%s.mp3' % (t, slug(t)))
        return

    if args.proxy:
        print('代理：%s' % args.proxy)
    manifest = asyncio.run(run(args, texts))
    for acc in manifest:
        print('%s：%d 条' % (acc, len(manifest[acc])))
    print('清单：assets/audio/manifest.json')


if __name__ == '__main__':
    main()
