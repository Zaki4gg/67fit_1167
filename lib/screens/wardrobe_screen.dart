import 'package:flutter/material.dart';

import '../models/clothing_model.dart';
import 'clothing_detail_screen.dart';

/// Halaman Wardrobe. Item datang dari props (state di MainNavigationScreen).
/// Filter/search/favorit diatur pakai setState — masih materi Widget & Navigasi.
class WardrobeScreen extends StatefulWidget {
  final List<Item> items;
  final void Function(Item item) onToggleFavorite;
  final void Function(Item item) onDeleteItem;

  const WardrobeScreen({
    super.key,
    required this.items,
    required this.onToggleFavorite,
    required this.onDeleteItem,
  });

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  // 0 = Items, 1 = Outfits, 2 = Wishlist
  int _selectedTabIndex = 0;
  String _searchQuery = '';
  bool _filterFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items.where((item) {
      final matchesSearch =
          item.nama.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFavorite = !_filterFavoriteOnly || item.isFavorite;
      return matchesSearch && matchesFavorite;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
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
                Positioned(
                  bottom: -28,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
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
                            count: widget.items.length,
                            label: 'Items'),
                        const SizedBox(width: 8),
                        _buildTabCapsule(
                            index: 1, count: 0, label: 'outfits'),
                        const SizedBox(width: 8),
                        _buildTabCapsule(
                            index: 2, count: 0, label: 'wishlist'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 44),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        onChanged: (v) =>
                            setState(() => _searchQuery = v),
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle:
                              TextStyle(color: Colors.black38, fontSize: 14),
                          prefixIcon: Icon(Icons.search,
                              size: 20, color: Colors.black87),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildSquareActionButton(
                    icon: _filterFavoriteOnly
                        ? Icons.favorite
                        : Icons.favorite_border,
                    iconColor: _filterFavoriteOnly
                        ? Colors.redAccent
                        : Colors.black87,
                    onTap: () => setState(
                        () => _filterFavoriteOnly = !_filterFavoriteOnly),
                  ),
                  const SizedBox(width: 10),
                  _buildSquareActionButton(
                    icon: Icons.archive_outlined,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Membuka koleksi arsip...')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _selectedTabIndex == 0
                  ? (filteredItems.isEmpty
                      ? _buildEmptyState()
                      : _buildClothingGrid(filteredItems))
                  : _selectedTabIndex == 1
                      ? const Center(
                          child: Text(
                            'Belum bisa menyimpan outfits',
                            style: TextStyle(color: Colors.black45),
                          ),
                        )
                      : const Center(
                          child: Text('Wishlist kosong',
                              style: TextStyle(color: Colors.black45))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabCapsule(
      {required int index, required int count, required String label}) {
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
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareActionButton(
      {required IconData icon,
      Color iconColor = Colors.black87,
      required VoidCallback onTap}) {
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

  Widget _buildClothingGrid(List<Item> items) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClothingDetailScreen(
                item: item,
                onToggleFavorite: widget.onToggleFavorite,
                onDeleteItem: widget.onDeleteItem,
              ),
            ),
          ),
          onLongPress: () => _showItemOptions(item),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Icon(Icons.checkroom, size: 50, color: Colors.black26),
            ),
          ),
        );
      },
    );
  }

  void _showItemOptions(Item item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.nama,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(),
                ListTile(
                  leading: Icon(
                      item.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: item.isFavorite
                          ? Colors.redAccent
                          : Colors.black87),
                  title: Text(item.isFavorite ? 'Batal favorit' : 'Favorit'),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onToggleFavorite(item);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline,
                      color: Colors.redAccent),
                  title: const Text('Hapus Pakaian',
                      style: TextStyle(color: Colors.redAccent)),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onDeleteItem(item);
                  },
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
          Icon(Icons.checkroom_outlined,
              size: 70, color: Colors.grey[400]),
          const SizedBox(height: 12),
          const Text(
            'Belum ada pakaian yang ditambahkan',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
