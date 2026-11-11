import 'package:flutter/material.dart';

import '../config/campus_modules.dart';
import '../models/campus_item.dart';

class DetailData extends StatelessWidget {
  final CampusItem item;

  const DetailData({super.key, required this.item});

  void _goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final module = CampusModules.forType(item.type);
    final accent = module.color;
    final scheduleLabel = switch (item.type) {
      'event' => 'Waktu kegiatan',
      'service' => 'Jam layanan',
      'ukm' => 'Jadwal kegiatan',
      _ => 'Jam operasional',
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => _goBack(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Detail Informasi',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [module.darkColor, module.color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      module.title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.17),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Icon(module.icon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      height: 1.16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.category,
                    style: const TextStyle(
                      color: Color(0xFFE3F2F0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 23),
            const Text(
              'Tentang',
              style: TextStyle(
                color: Color(0xFF152C3B),
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              item.description,
              style: const TextStyle(
                color: Color(0xFF53636C),
                fontSize: 14,
                height: 1.65,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Informasi',
              style: TextStyle(
                color: Color(0xFF152C3B),
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _DetailInfoRow(
                      icon: Icons.place_outlined,
                      label: 'Lokasi',
                      value: item.location,
                      accent: accent,
                    ),
                    const Divider(height: 1, color: Color(0xFFE8EEF0)),
                    _DetailInfoRow(
                      icon: item.type == 'event'
                          ? Icons.event_available_outlined
                          : Icons.schedule_rounded,
                      label: scheduleLabel,
                      value: item.schedule,
                      accent: accent,
                    ),
                    const Divider(height: 1, color: Color(0xFFE8EEF0)),
                    _DetailInfoRow(
                      icon: Icons.contact_support_outlined,
                      label: 'Kontak',
                      value: item.contact,
                      accent: accent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _goBack(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Kembali ke direktori'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF087F78),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Color(0xFFB8D8D4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  const _DetailInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF8A989F),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF263E4C),
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
