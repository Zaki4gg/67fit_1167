import 'package:flutter/material.dart';

import '../models/history_wishlist_model.dart';
import '../widgets/color_picker_sheet.dart';
import '../widgets/category_picker_sheet.dart';
import '../widgets/mock_item_image.dart';
import '../widgets/price_sheet.dart';
import '../widgets/confirm_dialog.dart';

class WishlistDetailScreen extends StatefulWidget {
  final Wishlist existing;

  const WishlistDetailScreen({super.key, required this.existing});

  @override
  State<WishlistDetailScreen> createState() => _WishlistDetailScreenState();
}

class _WishlistDetailScreenState extends State<WishlistDetailScreen> {
  late final TextEditingController _namaController;
  late String _warna;
  late String _kategori;
  late String _harga;
  late String? _imagePath;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.existing.nama);
    _warna = widget.existing.warna;
    _kategori = widget.existing.kategori;
    _harga = _formatHarga(widget.existing.harga);
    _imagePath = widget.existing.imagePath;
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mockup: wishlist belum disimpan (belum ada backend).')),
    );
  }

  Future<void> _deleteWishlist() async {
    final confirm = await showConfirmDelete(
      context,
      title: 'Hapus Wishlist',
      content: 'Apakah Anda yakin ingin menghapus item ini dari wishlist?',
    );

    if (confirm && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mockup: item wishlist dihapus'),
          backgroundColor: Color(0xFFD9361E),
        ),
      );
    }
  }

  // Format 199000 -> "Rp 199.000" (pemisah ribuan titik).
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Area Atas: gambar item (tanpa judul)
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(36, 48, 36, 16),
                      child: _imagePath == null
                          ? const Icon(
                              Icons.checkroom,
                              size: 100,
                              color: Colors.black26,
                            )
                          : MockItemImage(
                              assetPath: _imagePath!,
                              fallbackIconSize: 100,
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 12,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 28, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Panel Bawah: Formulir
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          TextField(
                            controller: _namaController,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                            decoration: const InputDecoration(
                              hintText: 'Name item ?',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          const Divider(thickness: 1, color: Color(0xFF9CA3AF)),
                          _buildFieldRow(
                            label: 'Color',
                            value: _warna,
                            onAdd: () async {
                              final csv = await showModalBottomSheet<String>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => ColorPickerSheet(initialColorsCsv: _warna),
                              );
                              if (csv != null) setState(() => _warna = csv);
                            },
                          ),
                          const Divider(thickness: 1, color: Color(0xFF9CA3AF)),
                          _buildFieldRow(
                            label: 'Category',
                            value: _kategori,
                            onAdd: () async {
                              final sel = await showModalBottomSheet<CategorySelection>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => CategoryPickerSheet(initialParent: _kategori),
                              );
                              if (sel != null) {
                                setState(() => _kategori = sel.sub ?? sel.parent);
                              }
                            },
                          ),
                          const Divider(thickness: 1, color: Color(0xFF9CA3AF)),
                          _buildFieldRow(
                            label: 'Harga',
                            value: _harga,
                            onAdd: () async {
                              final result = await showModalBottomSheet<String>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                builder: (_) => PriceSheet(
                                  initialValue: _harga.replaceAll(RegExp(r'[^0-9]'), ''),
                                ),
                              );
                              if (result != null) {
                                final angka = int.tryParse(result);
                                setState(() =>
                                    _harga = angka == null ? result : _formatHarga(angka));
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    // Tombol Delete & Save
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: _deleteWishlist,
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9CACAF),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldRow({
    required String label,
    required String value,
    required VoidCallback onAdd,
  }) {
    final hasValue = value.isNotEmpty && value != 'Tidak diisi';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          hasValue
              ? InkWell(
                  onTap: onAdd,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 64, minHeight: 44),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C2C46),
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: onAdd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2E8F0),
                      foregroundColor: const Color(0xFF0084FF),
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Add', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),
        ],
      ),
    );
  }
}
