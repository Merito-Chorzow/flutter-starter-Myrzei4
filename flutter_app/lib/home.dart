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

  @override
  void initState() {
    super.initState();
    _future = fetchEntries();
  }

  Future<void> _refresh() async {

    final f = fetchEntries();
    setState(() {
      _future = f;
    });

    try {
      await f;
      
    } catch (_) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GeoNotes')),
      body: FutureBuilder<List<Entry>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          } else if (snap.data == null || snap.data!.isEmpty) {
            return Center(
              child: TextButton(
                onPressed: _refresh,
                child: const Text('No entries. Tap to refresh'),
              ),
            );
          }
          final items = snap.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (c, i) {
                final e = items[i];
                return ListTile(
                  title: Text(e.title),
                  subtitle: Text('${e.latitude}, ${e.longitude}'),
                  onTap: () => Navigator.pushNamed(context, '/detail', arguments: e),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
