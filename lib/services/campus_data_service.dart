import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/campus_item.dart';

class CampusDataService {
  static const String _dataPath = 'assets/data/campus_data.json';

  Future<List<CampusItem>> loadItems() async {
    final jsonString = await rootBundle.loadString(_dataPath);
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Data kampus harus berupa object JSON.');
    }

    final rawItems = decoded['items'];
    if (rawItems is! List<dynamic>) {
      throw const FormatException('Field "items" harus berupa daftar.');
    }

    return List<CampusItem>.generate(rawItems.length, (index) {
      final rawItem = rawItems[index];
      if (rawItem is! Map<String, dynamic>) {
        throw FormatException(
          'Data kampus ke-${index + 1} harus berupa object.',
        );
      }
      try {
        return CampusItem.fromJson(rawItem);
      } on FormatException catch (error) {
        throw FormatException(
          'Data kampus ke-${index + 1} tidak valid: ${error.message}',
        );
      }
    }, growable: false);
  }
}
