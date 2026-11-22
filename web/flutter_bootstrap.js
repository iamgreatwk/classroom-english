{{flutter_js}}
{{flutter_build_config}}

// 自定义 bootstrap：不注册 Service Worker，
// 内容更新后刷新页面立即生效（避免“改了词表还是旧版”的缓存困扰）
_flutter.loader.load({});
