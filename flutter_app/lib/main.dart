import 'package:flutter/material.dart';
import 'home.dart';
import 'add.dart';
import 'detail.dart';
import 'entry.dart';
import 'theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Journal',
      theme: buildDarkTheme(),
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/add': (_) => const AddPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail' && settings.arguments is Entry) {
          final e = settings.arguments as Entry;
          return MaterialPageRoute(builder: (_) => DetailPage(entry: e));
        }
        return null;
      },
    );
  }
}
