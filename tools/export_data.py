#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
把网页原型 index.html 里的词表数据导出为 assets/data/cfe.json。

只需在「原型 → Flutter 应用」迁移时跑一次；之后直接编辑 JSON 即可定制词表。

    python tools/export_data.py
    python tools/export_data.py --src ../index.html --out assets/data/cfe.json
"""
import argparse
import json
import os
import re
import sys

UNESCAPE = re.compile(r'\\(.)')
Q = r"(['\"])"


def clean(s):
    return UNESCAPE.sub(r'\1', s).strip()


def parse_cats(html):
    out = []
    for cid, zh, en, ico in re.findall(
            r"\{id:'(\w+)',\s*zh:'([^']*)',\s*en:'([^']*)',\s*ico:'([^']*)'\}", html):
        out.append({'id': cid, 'zh': zh, 'en': en, 'ico': ico})
    return out


def parse_words(html):
    words = []
    # 每个词条：{c:'xx',en:...,ipa:...,zh:...,p:[ ... ]}
    for m in re.finditer(
            r"\{c:'(\w+)',\s*en:" + Q + r"(.*?)" + Q + r",\s*ipa:" + Q + r"(.*?)" + Q +
            r",\s*zh:" + Q + r"(.*?)" + Q + r",\s*p:\[(.*?)\]\s*\}", html, re.S):
        # 组号：1=分类 3=en 6=ipa 9=zh 11=例句块（引号本身也占组）
        cat, en, ipa, zh, body = m.group(1), m.group(3), m.group(6), m.group(9), m.group(11)
        phrases = []
        for pm in re.finditer(r"\{r:'(\w+)',\s*en:" + Q + r"(.*?)" + Q + r",\s*zh:" + Q + r"(.*?)" + Q + r"\}",
                              body, re.S):
            # 组号：1=角色 3=英文 6=中文
            phrases.append({'r': pm.group(1), 'en': clean(pm.group(3)), 'zh': clean(pm.group(6))})
        words.append({'c': cat, 'en': clean(en), 'ipa': clean(ipa), 'zh': clean(zh), 'p': phrases})
    return words


def parse_groups(html):
    groups = []
    for m in re.finditer(r"\{id:'(\w+)',\s*zh:'([^']*)',\s*ico:'([^']*)',\s*s:\[(.*?)\]\s*\}", html, re.S):
        gid, zh, ico, body = m.group(1), m.group(2), m.group(3), m.group(4)
        sents = []
        for sm in re.finditer(r"\[" + Q + r"(.*?)" + Q + r",\s*" + Q + r"(.*?)" + Q + r"\]", body, re.S):
            # 组号：2=英文 5=中文
            sents.append({'en': clean(sm.group(2)), 'zh': clean(sm.group(5))})
        groups.append({'id': gid, 'zh': zh, 'ico': ico, 's': sents})
    return groups


def main():
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    ap = argparse.ArgumentParser()
    ap.add_argument('--src', default=os.path.join(root, '..', 'index.html'))
    ap.add_argument('--out', default=os.path.join(root, 'assets', 'data', 'cfe.json'))
    args = ap.parse_args()

    src = os.path.normpath(args.src)
    if not os.path.exists(src):
        sys.exit('找不到源文件：%s' % src)

    html = open(src, encoding='utf-8').read()
    data = {
        'version': 1,
        'cats': parse_cats(html),
        'words': parse_words(html),
        'groups': parse_groups(html),
    }

    n_sent = sum(len(g['s']) for g in data['groups'])
    n_phr = sum(len(w['p']) for w in data['words'])
    print('分类 %d / 词条 %d / 词条例句 %d / 短句 %d'
          % (len(data['cats']), len(data['words']), n_phr, n_sent))
    if not data['cats'] or not data['words'] or not data['groups']:
        sys.exit('解析结果为空，请检查源文件格式')

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print('已写入 %s' % os.path.normpath(args.out))


if __name__ == '__main__':
    main()
