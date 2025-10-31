import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'entry.dart';
import 'api.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  double? lat, lon;
  bool _saving = false;

  Future<bool> _checkPermission() async {
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
    }
    return status == LocationPermission.always || status == LocationPermission.whileInUse;
  }

  Future<void> _getLocation() async {
    final ok = await _checkPermission();
    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission required')));
      return;
    }
    try {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (!mounted) return;
      setState(() {
        lat = pos.latitude;
        lon = pos.longitude;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (lat == null || lon == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please get coordinates first')));
      return;
    }
    setState(() => _saving = true);
    try {
      final entry = Entry(title: _title.text.trim(), description: _desc.text.trim(), latitude: lat!, longitude: lon!);
      final saved = await addEntry(entry);
      if (!mounted) return;
      Navigator.pop(context, saved);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
              ),
              TextFormField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
            ]),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _getLocation,
            icon: const Icon(Icons.my_location),
            label: const Text('Get coordinates'),
          ),
          if (lat != null) Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Coordinates: ${lat!.toStringAsFixed(6)}, ${lon!.toStringAsFixed(6)}'),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save'),
            ),
          ),
        ]),
      ),
    );
  }
}
