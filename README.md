# 教室设施英语助手（Flutter）

给有外教上课的教室管理员用的**离线英语速查与发音 App**：教室设施设备整理成中英对照词条 + 常用沟通短句，点一下就能发音。

- **双向沟通**：既能"听懂外教在说什么"，也能"照着句子指导外教操作"
- **完全离线**：词表与朗读都不需要联网
- **一套代码**：Web（GitHub Pages 试效果）→ iOS（App 打包）

## 目录结构

```
lib/
  main.dart              应用入口、主题、底部导航
  models.dart            数据模型 + assets/data/cfe.json 读取
  settings_store.dart    收藏与设置（SharedPreferences）
  tts_service.dart       朗读服务（flutter_tts）
  pages/                 词汇 / 分类 / 短句 / 收藏 / 设置
  widgets/cards.dart     词条卡、短句卡、发音行、搜索框
assets/data/cfe.json     词表数据（改这里即可定制）
tools/export_data.py     从网页原型 index.html 导出词表（仅迁移时跑一次）
```

## 本地运行

```bash
export PATH=/home/kai/下载/flutter-linux/flutter/bin:$PATH

flutter pub get

# Web：本地浏览器调试
flutter run -d web-server --web-port 8080     # 然后浏览器打开 http://localhost:8080

# 构建
flutter build web --release                   # 产物在 build/web
flutter build web --release --web-renderer html   # 便于自动化测试定位文本
```

> 本机没有系统 Chrome 时，用 `flutter run -d web-server` 起服务，再用任意浏览器访问即可。

## 发音（两套，自动切换）

点单词或句子时：

1. **优先播离线 MP3** —— 微软 Edge 神经语音预生成的真人发音，`en-US-AriaNeural`（美音女）/ `en-GB-SoniaNeural`（英音女）
2. **没有 MP3 才用系统语音** —— 浏览器/系统自带的 TTS，可在「设置 → 音色」里挑

设置页有「离线真人发音」开关，并显示已打包条数。

### 重新生成 / 更换音色

```bash
python3 -m pip install --target /tmp/ttslib edge-tts

PYTHONPATH=/tmp/ttslib python3 tools/gen_audio.py --list          # 看会生成哪些
PYTHONPATH=/tmp/ttslib python3 tools/gen_audio.py --limit 5       # 试 5 条
PYTHONPATH=/tmp/ttslib python3 tools/gen_audio.py                 # 全部（美音+英音，7MB）
PYTHONPATH=/tmp/ttslib python3 tools/gen_audio.py --accent en-US  # 只要美音
PYTHONPATH=/tmp/ttslib python3 tools/gen_audio.py --voice en-US-GuyNeural --accent en-US  # 换男声
```

音色在 `tools/gen_audio.py` 顶部的 `VOICES` 里改（微软神经语音名，与
`agent-os/tts/tts.sh` 里验证过的是同一套服务）。

生成完要重新构建发布：

```bash
flutter build web --release --base-href "/classroom-english/"
# 然后把 build/web 推到 gh-pages 分支
```

### 平台差异

| 平台 | 播放方式 |
|---|---|
| Web | `dart:html` 的 AudioElement（读 asset 转 Blob 播放，不依赖插件） |
| iOS / Android | `audioplayers` 原生播放器（AVPlayer / MediaPlayer） |

代码见 `lib/audio/`（条件导入）。> 注意：`audioplayers` 6.x 在 Flutter 3.22 的 Web 端不兼容（插件注册失败），
> 所以 Web 端绕开了它；原生端不受影响。升级 Flutter 后可考虑统一。

### 新增口音目录要登记

Flutter 的 `assets:` 目录声明**不递归子目录**，`pubspec.yaml` 里每个口音目录都要单独写：

```yaml
    - assets/audio/manifest.json
    - assets/audio/en-US/
    - assets/audio/en-GB/
```

## 定制词表

直接编辑 `assets/data/cfe.json`（热重启生效）：

```json
{
  "cats": [{"id": "display", "zh": "显示设备", "en": "Display & Projection", "ico": "📽️"}],
  "words": [{
    "c": "display",
    "en": "document camera",
    "ipa": "/ˈdɑːkjəment ˈkæmərə/",
    "zh": "实物展台",
    "p": [
      {"r": "ft", "en": "How do I use the document camera?", "zh": "实物展台怎么用？"},
      {"r": "me", "en": "Put the paper here, it will show on screen.", "zh": "把纸放在这里，就会投到屏幕上。"}
    ]
  }],
  "groups": [{"id": "issue", "zh": "外教反馈故障", "ico": "🚨", "s": [{"en": "...", "zh": "..."}]}]
}
```

字段说明：`c` 分类 id、`r` 例句角色（`ft` 外教常说 / `me` 你可以说）。

## 部署到 GitHub Pages（手机试用）

```bash
# 仓库名换成你自己的，Pages 会从 gh-pages 分支发布
REPO=classroom-english

flutter build web --release --base-href "/$REPO/"
cp -r build/web /tmp/$REPO-pages

git init -b gh-pages /tmp/$REPO-pages-deploy   # 或用 worktree / 直接推分支
# 简化做法：把 build/web 内容推到远端 gh-pages 分支
```

仓库 → Settings → Pages → Source 选 `gh-pages` 分支 `/root`，稍等片刻即可用
`https://<用户名>.github.io/<仓库名>/` 访问。手机浏览器打开后「添加到主屏幕」，用起来跟 App 一样。

> 仓库设为 **Public** 才能免费使用 GitHub Pages（私有仓库需付费套餐）。词表不含任何敏感信息。

## 打包 iOS

本机是 Linux，无法直接打 iOS 包，用 GitHub Actions 构建（macOS runner）：

1. GitHub 仓库 → **Actions** → 「构建 iOS IPA」→ **Run workflow**
2. 跑完在仓库右侧 **Releases** → `ios-latest` 里下载 `classroom-english-unsigned.ipa`
   （也可在 Actions 的 Job Summary 里直接点下载链接）

产物只发 Release，**不使用 Actions artifact**（Release 附件不占用账户的 500MB Actions 存储配额）；
每次覆盖同一个 `ios-latest` 发布，不会堆积历史附件。

产出的是**未签名 IPA**，需用爱思助手 / AltStore 等工具签名后安装；若要上架或长期安装，
需在工作流里配置开发者证书与描述文件（把 `--no-codesign` 换成导出描述文件的方式）。

> ⚠️ macOS runner 按 **10 倍** 计费，每次构建约消耗账户 Actions 分钟数的 100~200 分钟
> （Free 账户每月 2000 分钟）。确认好再触发，别反复跑。

## 功能一览

| 页面 | 内容 |
|---|---|
| 词汇 | 8 大分类 96 个词条，含音标、中文、例句（分「外教」/「你说」） |
| 短句 | 39 句按场景分组：外教反馈故障 / 你指导操作 / 课堂沟通 / 应急安全 |
| 收藏 | 常用词句加星，存在本机 |
| 设置 | 美音/英音、语速 0.6–1.3×、慢速朗读、隐藏中文、试听 |

点单词或整句即可发音；搜索支持中英文双向。
