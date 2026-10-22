import 'package:flutter/material.dart';

import '../widgets/mock_item_image.dart';

/// Styling versi sederhana: pilih item contoh lewat bottom sheet,
/// tampil di canvas tanpa drag/rotate/undo. Tap item = hapus dari canvas.
/// Item contoh memakai gambar asset mocks di assets/pakaian/.
/// Kartu picker putih + garis luar; kartu canvas transparan mengikuti
/// bentuk gambar, tanpa nama item.
class CanvasItem {
  final String assetPath;

  CanvasItem({required this.assetPath});
}

class StylingScreen extends StatefulWidget {
  const StylingScreen({super.key});
  @override
  State<StylingScreen> createState() => _StylingScreenState();
}

class _StylingScreenState extends State<StylingScreen> {
  List<CanvasItem> items = [];

  void _showDummyPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Choose your outfit (contoh)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: MockPakaian.semua.length,
                itemBuilder: (ctx, index) {
                  final asset = MockPakaian.semua[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => items.add(CanvasItem(assetPath: asset)));
                    },
                    // Kartu putih dengan garis luar, tanpa nama item.
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: MockItemImage(
                        assetPath: asset,
                        fallbackIconSize: 40,
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

  void _clearCanvas() {
    setState(() => items.clear());
  }

  // Save versi contoh: hanya pesan, tidak simpan ke mana-mana.
  void _saveOutfit() {
    if (items.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal 2 pakaian',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Outfit tersimpan',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFA8B50A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E7EB),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('6',
                      style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  Text('Styling',
                      style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5)),
                  Text('7',
                      style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text('Kanvas kosong — tekan Add items',
                          style: TextStyle(color: Colors.black45)),
                    )
                  // Column biasa: item terpilih disusun vertikal, tap = hapus.
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () => _confirmRemove(index),
                          // Kartu canvas: background transparan dan mengikuti
                          // bentuk/proporsi gambar (tanpa kotak & nama item).
                          // fit: contain menjaga rasio gambar aslinya.
                          child: Container(
                            height: 140,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: MockItemImage(
                              assetPath: item.assetPath,
                              fallbackIconSize: 60,
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Reset (refresh) saja — fitur mundur 1 langkah dihapus.
                      _buildSmallCircleButton(Icons.refresh, _clearCanvas),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _showDummyPicker,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1C2C46),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Add items',
                              style: TextStyle(
                                  fontFamily: 'monospace', fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 48,
                        width: 48,
                        child: ElevatedButton(
                          onPressed: _saveOutfit,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xFFA8B50A),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Icon(Icons.download_outlined),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmRemove(int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: ListTile(
            leading:
                const Icon(Icons.delete_outline, color: Colors.redAccent),
            title: const Text('Hapus pakaian dari kanvas',
                style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              setState(() => items.removeAt(index));
            },
          ),
        );
      },
    );
  }

  Widget _buildSmallCircleButton(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey[400] : Colors.black,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
