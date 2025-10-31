class Entry {
  final int? id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  Entry({
    this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory Entry.fromJson(Map<String, dynamic> j) => Entry(
        id: j['id'],
        title: j['title'] ?? '',
        description: j['description'] ?? '',
        latitude: (j['latitude'] as num).toDouble(),
        longitude: (j['longitude'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
      };
}
