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

```bash
# 触发构建（workflow_dispatch），产出 IPA 并上传到 GitHub Release
git tag ios-latest && git push origin ios-latest
# 或在 GitHub 网页 Actions → Build iOS → Run workflow
```

CI 脚本见 `.github/workflows/build-ios.yml`，产出未签名 IPA，用爱思/AltStore 等工具安装；
若要上架或长期安装，需在 workflow 里配置开发者证书与描述文件。

## 功能一览

| 页面 | 内容 |
|---|---|
| 词汇 | 8 大分类 96 个词条，含音标、中文、例句（分「外教」/「你说」） |
| 短句 | 39 句按场景分组：外教反馈故障 / 你指导操作 / 课堂沟通 / 应急安全 |
| 收藏 | 常用词句加星，存在本机 |
| 设置 | 美音/英音、语速 0.6–1.3×、慢速朗读、隐藏中文、试听 |

点单词或整句即可发音；搜索支持中英文双向。
