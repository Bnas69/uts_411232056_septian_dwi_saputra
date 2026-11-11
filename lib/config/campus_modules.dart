import 'package:flutter/material.dart';

class CampusModule {
  final String type;
  final String label;
  final String title;
  final IconData icon;
  final Color color;
  final Color darkColor;

  const CampusModule({
    required this.type,
    required this.label,
    required this.title,
    required this.icon,
    required this.color,
    required this.darkColor,
  });
}

class CampusModules {
  static const List<CampusModule> all = [
    CampusModule(
      type: 'facility',
      label: 'Fasilitas',
      title: 'Direktori Fasilitas Kampus',
      icon: Icons.apartment_rounded,
      color: Color(0xFF087F78),
      darkColor: Color(0xFF123B4A),
    ),
    CampusModule(
      type: 'event',
      label: 'Event & Agenda',
      title: 'Event dan Agenda Kampus',
      icon: Icons.event_rounded,
      color: Color(0xFF9860D8),
      darkColor: Color(0xFF6843A5),
    ),
    CampusModule(
      type: 'service',
      label: 'Layanan',
      title: 'Layanan Mahasiswa',
      icon: Icons.support_agent_rounded,
      color: Color(0xFF3478C7),
      darkColor: Color(0xFF224E86),
    ),
    CampusModule(
      type: 'umkm',
      label: 'UMKM & Kantin',
      title: 'UMKM dan Kantin Kampus',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFE08B32),
      darkColor: Color(0xFF9C571B),
    ),
    CampusModule(
      type: 'ukm',
      label: 'UKM & Komunitas',
      title: 'UKM dan Komunitas',
      icon: Icons.groups_rounded,
      color: Color(0xFFD65872),
      darkColor: Color(0xFF96384D),
    ),
  ];

  static CampusModule forType(String? type) {
    for (final module in all) {
      if (module.type == type) return module;
    }
    return all.first;
  }
}
