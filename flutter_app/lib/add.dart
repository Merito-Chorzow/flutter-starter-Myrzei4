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
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      final r = await Geolocator.requestPermission();
      return r == LocationPermission.always || r == LocationPermission.whileInUse;
    }
    return status == LocationPermission.always || status == LocationPermission.whileInUse;
  }

  Future<void> _getLocation() async {
    final ok = await _checkPermission();
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission required')));
      return;
    }
    try {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        lat = pos.latitude;
        lon = pos.longitude;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location error: $e')));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || lat == null || lon == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill title and get coordinates')));
      return;
    }
    setState(() => _saving = true);
    try {
      final entry = Entry(title: _title.text, description: _desc.text, latitude: lat!, longitude: lon!);
      await addEntry(entry);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save error: $e')));
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
      appBar: AppBar(title: const Text('Add')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _title,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter title' : null,
                  ),
                  TextFormField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _getLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('Get coordinates'),
            ),
            if (lat != null) Text('Coordinates: $lat, $lon'),
            const Spacer(),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving ? const CircularProgressIndicator() : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
