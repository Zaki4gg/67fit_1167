import 'package:flutter/material.dart';

import '../main.dart' as app;
import '../models/clothing_model.dart';
import '../models/history_wishlist_model.dart';
import '../models/mock_data.dart';
import '../models/outfit_model.dart';
import '../widgets/mock_item_image.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  // 0 = Items, 1 = Outfits, 2 = Wishlist
  int _selectedTabIndex = 0;
  String _searchQuery = '';
  bool _filterFavoriteOnly = false;

  List<Item> get _filteredItems => MockData.items.where((item) {
    final matchesSearch = item.nama.toLowerCase().contains(
      _searchQuery.toLowerCase(),
    );
    final matchesFavorite = !_filterFavoriteOnly || item.isFavorite;
    return !item.isArchived && matchesSearch && matchesFavorite;
  }).toList();

  List<Outfit> get _filteredOutfits => MockData.outfits.where((outfit) {
    final matchesSearch = outfit.nama.toLowerCase().contains(
      _searchQuery.toLowerCase(),
    );
    final matchesFavorite = !_filterFavoriteOnly || outfit.isFavorite;
    return !outfit.isArchived && matchesSearch && matchesFavorite;
  }).toList();

  List<Wishlist> get _filteredWishlist => MockData.wishlist.where((w) {
    final q = _searchQuery.toLowerCase();
    final matchesSearch =
        w.nama.toLowerCase().contains(q) || w.kategori.toLowerCase().contains(q);
    return matchesSearch;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header Motif Navy & Kartu Tab Mengambang
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: double.infinity,
                  height: 140,
                  color: const Color(0xFF1C2C46),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Text(
                        'Your Collection',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                  ),
                ),

                // Kartu Tab Putih Mengambang (Items, Outfits, Wishlist)
                Positioned(
                  bottom: -28,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTabCapsule(
                          index: 0,
                          count: MockData.items
                              .where((item) => !item.isArchived)
                              .length,
                          label: 'Items',
                        ),
                        const SizedBox(width: 8),
                        _buildTabCapsule(
                          index: 1,
                          count: MockData.outfits
                              .where((outfit) => !outfit.isArchived)
                              .length,
                          label: 'outfits',
                        ),
                        const SizedBox(width: 8),
                        _buildTabCapsule(
                          index: 2,
                          count: MockData.wishlist.length,
                          label: 'wishlist',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 44),
            // 2. Baris Pencarian & Tombol Aksi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Kolom Search
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.black87,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tombol Favorit & Arsip: hanya untuk tab item (wishlist)
                  if (_selectedTabIndex != 2) ...[
                    // Tombol Favorit
                    _buildSquareActionButton(
                      icon: _filterFavoriteOnly
                          ? Icons.favorite
                          : Icons.favorite_border,
                      iconColor: _filterFavoriteOnly
                          ? Colors.redAccent
                          : Colors.black87,
                      onTap: () {
                        setState(() {
                          _filterFavoriteOnly = !_filterFavoriteOnly;
                        });
                      },
                    ),
                    const SizedBox(width: 10),

                    // Tombol Arsip: buka halaman koleksi arsip.
                    _buildSquareActionButton(
                      icon: Icons.archive_outlined,
                      onTap: () => Navigator.pushNamed(
                        context,
                        app.AppRoute.archive,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),
            // 3. Kisi Item (Lookbook Grid)
            Expanded(
              child: switch (_selectedTabIndex) {
                0 => _filteredItems.isEmpty
                    ? _buildEmptyState()
                    : _buildGrid(
                        itemCount: _filteredItems.length,
                        childAspectRatio: 0.9,
                        buildCard: (_, i) => _buildItemCard(_filteredItems[i]),
                      ),
                1 => _filteredOutfits.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada outfit, mari kita buat',
                          style: TextStyle(color: Colors.black45),
                        ),
                      )
                    : _buildGrid(
                        itemCount: _filteredOutfits.length,
                        childAspectRatio: 0.9,
                        buildCard: (_, i) =>
                            _buildOutfitCard(_filteredOutfits[i]),
                      ),
                _ => _filteredWishlist.isEmpty
                    ? _buildEmptyState()
                    : _buildGrid(
                        itemCount: _filteredWishlist.length,
                        childAspectRatio: 1.0,
                        buildCard: (_, i) =>
                            _buildWishlistCard(_filteredWishlist[i]),
                      ),
              },
            ),
          ],
        ),
      ),
    );
  }

  // Desain Tab
  Widget _buildTabCapsule({
    required int index,
    required int count,
    required String label,
  }) {
    final isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Colors.black87, width: 1.5)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tombol Aksi Kotak Putih
  Widget _buildSquareActionButton({
    required IconData icon,
    Color iconColor = Colors.black87,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: 20),
        onPressed: onTap,
      ),
    );
  }

  // Grid generik: container putih rasio kartu + delegate
  Widget _buildGrid({
    required int itemCount,
    required double childAspectRatio,
    required Widget Function(BuildContext, int) buildCard,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: buildCard,
    );
  }

  // Card item putih gambar di tengah.
  Widget _buildItemCard(Item item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, app.AppRoute.clothingDetail, arguments: item);
      },
      onLongPress: () => _showItemOptions(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(child: MockItemImage(assetPath: item.imagePath)),
      ),
    );
  }

  // Kartu outfit (gambar memenuhi kartu).
  Widget _buildOutfitCard(Outfit outfit) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, app.AppRoute.outfitDetail, arguments: outfit);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Center(
          child: MockItemImage(
            assetPath: outfit.imagePath,
            fallbackIconSize: 44,
          ),
        ),
      ),
    );
  }

  // Kartu wishlist
  Widget _buildWishlistCard(Wishlist w) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, app.AppRoute.wishlistDetail, arguments: w);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: w.imagePath == null
                    ? const Icon(
                        Icons.checkroom,
                        size: 44,
                        color: Colors.black26,
                      )
                    : MockItemImage(
                        assetPath: w.imagePath!,
                        fallbackIconSize: 44,
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              w.nama,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _formatHarga(w.harga),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Color(0xFF1C2C46),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Format 199000 -> "Rp 199.000" (pemisah ribuan titik)
  String _formatHarga(int harga) {
    final s = harga.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final sisa = s.length - i;
      buffer.write(s[i]);
      if (sisa > 1 && sisa % 3 == 1) buffer.write('.');
    }
    return 'Rp $buffer';
  }

  // Modal Opsi saat Foto Ditahan (Hapus / Favorit)
  void _showItemOptions(Item item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Hapus Pakaian',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  // Mockup: hapus tidak menyimpan ke mana-mana.
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checkroom_outlined, size: 70, color: Colors.grey[400]),
          const SizedBox(height: 12),
          const Text(
            'Belum ada pakaian yang ditambahkan',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
