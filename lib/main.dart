import 'package:flutter/material.dart';

import 'models.dart';
import 'pages/favorites_page.dart';
import 'pages/sentences_page.dart';
import 'pages/settings_page.dart';
import 'pages/words_page.dart';
import 'settings_store.dart';
import 'tts_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsStore.instance.load();
  await TtsService.instance.init();
  runApp(const ClassroomEnglishApp());
}

class ClassroomEnglishApp extends StatelessWidget {
  const ClassroomEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF2B6CB0);
    return MaterialApp(
      title: '教室设施英语助手',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  late final Future<CfeData> _future;

  @override
  void initState() {
    super.initState();
    _future = DataRepository.load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CfeData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('词表加载失败：${snapshot.error}'),
              ),
            ),
          );
        }
        final data = snapshot.data!;
        return Scaffold(
          body: IndexedStack(
            index: _index,
            children: [
              WordsPage(data: data),
              SentencesPage(data: data),
              FavoritesPage(data: data),
              SettingsPage(data: data),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book_rounded),
                label: '词汇',
              ),
              NavigationDestination(
                icon: Icon(Icons.forum_outlined),
                selectedIcon: Icon(Icons.forum_rounded),
                label: '短句',
              ),
              NavigationDestination(
                icon: Icon(Icons.star_border_rounded),
                selectedIcon: Icon(Icons.star_rounded),
                label: '收藏',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded),
                label: '设置',
              ),
            ],
          ),
        );
      },
    );
  }
}
