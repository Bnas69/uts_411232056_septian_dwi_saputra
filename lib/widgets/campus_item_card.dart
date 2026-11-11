import 'package:flutter/material.dart';

import '../config/campus_modules.dart';
import '../models/campus_item.dart';

class CampusItemCard extends StatelessWidget {
  final CampusItem item;
  final VoidCallback onTap;

  const CampusItemCard({super.key, required this.item, required this.onTap});

  static const Map<String, IconData> _icons = {
    'local_library': Icons.local_library_rounded,
    'computer': Icons.computer_rounded,
    'sports_basketball': Icons.sports_basketball_rounded,
    'groups': Icons.groups_rounded,
    'apartment': Icons.apartment_rounded,
    'lightbulb': Icons.lightbulb_rounded,
    'code': Icons.code_rounded,
    'palette': Icons.palette_rounded,
    'diversity_3': Icons.diversity_3_rounded,
    'support_agent': Icons.support_agent_rounded,
    'school': Icons.school_rounded,
    'psychology': Icons.psychology_rounded,
    'restaurant': Icons.restaurant_rounded,
    'coffee': Icons.coffee_rounded,
    'bakery_dining': Icons.bakery_dining_rounded,
    'music_note': Icons.music_note_rounded,
    'forum': Icons.forum_rounded,
    'brush': Icons.brush_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final module = CampusModules.forType(item.type);
    final accent = module.color;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: SizedBox(
                  height: 132,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildImage(accent),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x990D202A)],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        bottom: 11,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.category,
                            style: TextStyle(
                              color: accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(module.icon, color: accent, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF152C3B),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_outward_rounded,
                          size: 17,
                          color: Color(0xFF8A989F),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          size: 15,
                          color: Color(0xFF77858E),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF77858E),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF53636C),
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(Color accent) {
    final imageUrl = item.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildImagePlaceholder(accent);
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          _buildImagePlaceholder(accent),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _buildImagePlaceholder(accent);
      },
    );
  }

  Widget _buildImagePlaceholder(Color accent) {
    return Container(
      color: accent.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Icon(
        _icons[item.icon] ?? Icons.place_rounded,
        color: accent,
        size: 42,
      ),
    );
  }
}
