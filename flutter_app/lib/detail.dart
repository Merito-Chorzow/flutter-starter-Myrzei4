import 'package:flutter/material.dart';
import 'entry.dart';

class DetailPage extends StatelessWidget {
  final Entry entry;
  const DetailPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(entry.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (entry.description.isNotEmpty) Text(entry.description, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          Text('Latitude: ${entry.latitude.toStringAsFixed(6)}'),
          Text('Longitude: ${entry.longitude.toStringAsFixed(6)}'),
        ]),
      ),
    );
  }
}
