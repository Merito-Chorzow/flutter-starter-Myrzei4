import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'entry.dart';

class ApiService {
  ApiService._internal();
  static final ApiService instance = ApiService._internal();

  final List<Entry> _store = [];
  int _nextId = 1;
  static const _prefKey = 'geonotes_store';
  bool _loading = false;

  Future<void> _load() async {
    if (_store.isNotEmpty || _loading) return;
    _loading = true;
    try {
      final sp = await SharedPreferences.getInstance();
      final s = sp.getString(_prefKey);
      if (s == null) {
        _store.add(Entry(id: _nextId++, title: 'Demo', description: 'Local demo note', latitude: 23.93, longitude: 19.02));
        return;
      }
      final List data = jsonDecode(s);
      for (var item in data) {
        _store.add(Entry.fromJson(item as Map<String, dynamic>));
      }
      _nextId = (_store.map((e) => e.id ?? 0).fold(0, (a, b) => a > b ? a : b)) + 1;
    } catch (_) {
      _store.add(Entry(id: _nextId++, title: 'Demo', description: 'Local demo note', latitude: 23.93, longitude: 19.02));
    } finally {
      _loading = false;
    }
  }

  Future<void> _saveToPrefs() async {
    final sp = await SharedPreferences.getInstance();
    final s = jsonEncode(_store.map((e) => e.toJson()).toList());
    await sp.setString(_prefKey, s);
  }

  Future<List<Entry>> fetchEntries() async {
    await _load();
    await Future.delayed(const Duration(milliseconds: 150));
    return List<Entry>.from(_store);
  }

  Future<Entry> addEntry(Entry entry) async {
    await _load();
    await Future.delayed(const Duration(milliseconds: 150));
    final e = Entry(
      id: _nextId++,
      title: entry.title,
      description: entry.description,
      latitude: entry.latitude,
      longitude: entry.longitude,
    );
    _store.add(e);
    await _saveToPrefs();
    return e;
  }
}

Future<List<Entry>> fetchEntries() => ApiService.instance.fetchEntries();
Future<Entry> addEntry(Entry e) => ApiService.instance.addEntry(e);
