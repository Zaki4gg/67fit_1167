import 'package:flutter/material.dart';

import '../models/mock_data.dart';
import '../widgets/mock_item_image.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  // 0 = Items, 1 = Outfits (wishlist tidak punya arsip).
  int _selectedTabIndex = 0;

  List get _currentEntries => _selectedTabIndex == 0
      ? MockData.items.where((item) => item.isArchived).toList()
      : MockData.outfits.where((outfit) => outfit.isArchived).toList();

  void _munculkanKembali(dynamic entry) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '"${entry.nama}" dikembalikan ke koleksi',
        ),
      ),
    );
  }

  // Tap kartu arsip
  Future<void> _showRestoreDialog(dynamic entry) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kembalikan ke koleksi'),
        content: Text(
          'Kembalikan "${entry.nama}" ke koleksi utama di wardrobe?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0084FF),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Kembalikan'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) _munculkanKembali(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            // Header: X + judul tengah (pola Row + spacer kanan 1:1).
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, size: 28, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Koleksi Arsip',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Tab Items / Outfits
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabChip('Items', _selectedTabIndex == 0),
                const SizedBox(width: 12),
                _buildTabChip('Outfits', _selectedTabIndex == 1),
              ],
            ),
            const Divider(height: 24),

            // Grid arsip
            Expanded(
              child: _currentEntries.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada yang diarsip',
                        style: TextStyle(fontFamily: 'monospace', color: Colors.black45),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: _currentEntries.length,
                      itemBuilder: (context, index) {
                        final entry = _currentEntries[index];
                        return GestureDetector(
                          onTap: () => _showRestoreDialog(entry),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: MockItemImage(
                                assetPath: entry.imagePath,
                                fallbackIconSize: 56,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabChip(String label, bool active) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = label == 'Outfits' ? 1 : 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFB9C2C4) : Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
