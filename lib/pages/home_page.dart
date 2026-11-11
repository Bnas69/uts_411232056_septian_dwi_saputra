import 'package:flutter/material.dart';

import '../config/campus_modules.dart';
import '../models/campus_item.dart';
import '../services/campus_data_service.dart';
import '../widgets/campus_item_card.dart';
import '../widgets/gradient_action_button.dart';
import '../widgets/section_header.dart';

class CampusGoHomePage extends StatefulWidget {
  const CampusGoHomePage({super.key});

  @override
  State<CampusGoHomePage> createState() => _CampusGoHomePageState();
}

class _CampusGoHomePageState extends State<CampusGoHomePage> {
  final CampusDataService _dataService = CampusDataService();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<CampusItem>> _itemsFuture;
  String? _selectedType;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _itemsFuture = _dataService.loadItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _retryLoading() {
    setState(() {
      _itemsFuture = _dataService.loadItems();
    });
  }

  Future<void> _refresh() async {
    final future = _dataService.loadItems();
    setState(() => _itemsFuture = future);
    try {
      await future;
    } catch (_) {
      // FutureBuilder shows the error state after the refresh completes.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF087F78),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.explore_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'CampusGo',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Informasi kampus',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Jelajahi lima direktori informasi kampus.'),
              ),
            ),
            icon: const Icon(Icons.info_outline_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<CampusItem>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorState();
          }

          final items = snapshot.data ?? const <CampusItem>[];
          return RefreshIndicator(
            onRefresh: _refresh,
            color: const Color(0xFF087F78),
            child: _buildContent(items),
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE9E5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: Color(0xFFC45143),
                size: 34,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Data belum dapat dimuat',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            const Text(
              'Periksa berkas data kampus, lalu coba lagi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF77858E), height: 1.45),
            ),
            const SizedBox(height: 20),
            GradientActionButton(
              label: 'Coba Lagi',
              icon: Icons.refresh_rounded,
              onPressed: _retryLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<CampusItem> allItems) {
    final normalizedQuery = _query.trim().toLowerCase();
    final items = allItems
        .where((item) {
          final matchesType =
              _selectedType == null || item.type == _selectedType;
          final searchableText = [
            item.title,
            item.category,
            item.location,
            item.description,
            item.schedule,
            item.contact,
          ].join(' ').toLowerCase();
          return matchesType && searchableText.contains(normalizedQuery);
        })
        .toList(growable: false);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        const Text(
          'Jelajahi kampusmu',
          style: TextStyle(
            color: Color(0xFF152C3B),
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Akses fasilitas, layanan, kuliner, kegiatan, dan komunitas kampus.',
          style: TextStyle(color: Color(0xFF77858E), fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildWelcomeCard(allItems.length, CampusModules.all.length),
        const SizedBox(height: 23),
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Cari fasilitas, layanan, kantin, atau UKM',
            hintStyle: const TextStyle(color: Color(0xFF9BA7AC)),
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _query.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Hapus pencarian',
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
          ),
        ),
        const SizedBox(height: 19),
        const SectionHeader(
          title: 'Pilih kebutuhanmu',
          subtitle: 'Lima direktori kampus dalam satu aplikasi',
        ),
        const SizedBox(height: 12),
        _buildFilters(allItems),
        const SizedBox(height: 23),
        SectionHeader(
          title: _selectedType == null
              ? 'Direktori Kampus'
              : CampusModules.forType(_selectedType).title,
          subtitle: '${items.length} informasi tersedia',
          actionLabel: _selectedType != null || _query.isNotEmpty
              ? 'Lihat Semua'
              : null,
          onAction: _selectedType != null || _query.isNotEmpty
              ? () {
                  _searchController.clear();
                  setState(() {
                    _selectedType = null;
                    _query = '';
                  });
                }
              : null,
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          _buildEmptyState()
        else
          ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CampusItemCard(
                  item: item,
                  onTap: () =>
                      Navigator.pushNamed(context, '/detail', arguments: item),
                ),
              );
            },
          ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Informasi kampus untuk aktivitas yang lebih mudah.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF9BA7AC), fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(int itemCount, int moduleCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF123B4A), Color(0xFF087F78)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'CAMPUS GUIDE',
              style: TextStyle(
                color: Color(0xFFBDF5E9),
                fontSize: 10,
                letterSpacing: 1.3,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Semua informasi\nkampus, lebih dekat.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              height: 1.15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Temukan fasilitas, layanan, kuliner, komunitas, dan agenda kampus.',
            style: TextStyle(
              color: Color(0xFFD5E9E8),
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              _buildCountBadge(Icons.list_alt_rounded, '$itemCount informasi'),
              const SizedBox(width: 9),
              _buildCountBadge(
                Icons.category_rounded,
                '$moduleCount direktori',
              ),
              const Spacer(),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.explore_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFBDF5E9), size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(List<CampusItem> items) {
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: [
        _buildFilterChip(
          label: 'Semua',
          icon: Icons.grid_view_rounded,
          count: items.length,
          value: null,
          accent: const Color(0xFF087F78),
        ),
        ...CampusModules.all.map((module) {
          final count = items.where((item) => item.type == module.type).length;
          return _buildFilterChip(
            label: module.label,
            icon: module.icon,
            count: count,
            value: module.type,
            accent: module.color,
          );
        }),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required int count,
    required String? value,
    required Color accent,
  }) {
    final selected = _selectedType == value;
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => setState(() => _selectedType = value),
      showCheckmark: false,
      avatar: Icon(icon, size: 17, color: selected ? Colors.white : accent),
      label: Text('$label  $count'),
      labelStyle: TextStyle(
        color: selected ? Colors.white : const Color(0xFF53636C),
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      backgroundColor: Colors.white,
      selectedColor: accent,
      side: BorderSide(color: selected ? accent : const Color(0xFFE8EEF0)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EEF0)),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, size: 38, color: Color(0xFF9BA7AC)),
          SizedBox(height: 10),
          Text(
            'Informasi tidak ditemukan',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text(
            'Coba kata kunci atau kategori lain.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF77858E), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
