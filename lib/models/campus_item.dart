class CampusItem {
  static const Set<String> supportedTypes = {
    'facility',
    'event',
    'service',
    'umkm',
    'ukm',
  };

  final String id;
  final String type;
  final String category;
  final String title;
  final String description;
  final String location;
  final String schedule;
  final String contact;
  final String icon;
  final String? imageUrl;

  const CampusItem({
    required this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.description,
    required this.location,
    required this.schedule,
    required this.contact,
    required this.icon,
    this.imageUrl,
  });

  bool get isEvent => type == 'event';

  factory CampusItem.fromJson(Map<String, dynamic> json) {
    String requiredString(String key) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) return value;
      throw FormatException(
        'Field "$key" harus berupa teks yang tidak kosong.',
      );
    }

    final imageUrl = json['imageUrl'];
    if (imageUrl != null && imageUrl is! String) {
      throw const FormatException('Field "imageUrl" harus berupa teks.');
    }
    final type = requiredString('type');
    if (!supportedTypes.contains(type)) {
      throw FormatException('Jenis direktori "$type" tidak didukung.');
    }

    return CampusItem(
      id: requiredString('id'),
      type: type,
      category: requiredString('category'),
      title: requiredString('title'),
      description: requiredString('description'),
      location: requiredString('location'),
      schedule: requiredString('schedule'),
      contact: requiredString('contact'),
      icon: requiredString('icon'),
      imageUrl: imageUrl as String?,
    );
  }
}
