import 'package:flutter/material.dart';
import 'api.dart';
import 'entry.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Entry>> _future;
  List<Entry> _items = [];

  @override
  void initState() {
    super.initState();
    _future = fetchEntries();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    try {
      final items = await fetchEntries();
      if (!mounted) return;
      setState(() => _items = items);
    } catch (_) {}
  }

  Future<void> _refresh() async {
    final f = fetchEntries();
    setState(() => _future = f);
    try {
      final items = await f;
      if (!mounted) return;
      setState(() => _items = items);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tileHeight = isDark ? 88.0 : 64.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Journal'),
      ),
      body: FutureBuilder<List<Entry>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final items = _items.isNotEmpty ? _items : (snap.data ?? []);
          if (items.isEmpty) {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('No entries yet'),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _refresh, child: const Text('Refresh')),
              ]),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemCount: items.length,
              itemBuilder: (c, i) {
                final e = items[i];
                return SizedBox(
                  height: tileHeight,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isDark ? 12 : 8),
                    title: Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('${e.latitude.toStringAsFixed(5)}, ${e.longitude.toStringAsFixed(5)}'),
                    onTap: () => Navigator.pushNamed(context, '/detail', arguments: e),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.pushNamed(context, '/add');
          if (res is Entry) {
            setState(() => _items.insert(0, res));
          } else if (res == true) {
            await _refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: SizedBox(height: 56),
      ),
    );
  }
}
