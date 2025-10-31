import 'dart:async';
import 'entry.dart';

class ApiService {
  ApiService._internal();
  static final ApiService instance = ApiService._internal();

  final List<Entry> _store = [
    Entry(id: 1, title: 'Demo 1', description: 'Local demo note', latitude: 50.26, longitude: 19.02),
  ];
  int _nextId = 2;

  Future<List<Entry>> fetchEntries() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List<Entry>.from(_store);
  }

  Future<void> addEntry(Entry entry) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final e = Entry(
      id: _nextId++,
      title: entry.title,
      description: entry.description,
      latitude: entry.latitude,
      longitude: entry.longitude,
    );
    _store.add(e);
  }
}

// Facade functions used by UI
Future<List<Entry>> fetchEntries() => ApiService.instance.fetchEntries();
Future<void> addEntry(Entry e) => ApiService.instance.addEntry(e);
