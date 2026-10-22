import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/color_picker_sheet.dart';
import '../widgets/category_picker_sheet.dart';
import '../widgets/mock_item_image.dart';
import '../widgets/price_sheet.dart';

class AddWishlistScreen extends StatefulWidget {
  const AddWishlistScreen({super.key});

  @override
  State<AddWishlistScreen> createState() => _AddWishlistScreenState();
}

class _AddWishlistScreenState extends State<AddWishlistScreen> {
  final _namaController = TextEditingController();
  String _warna = '';
  String _kategori = '';
  String _harga = '';
  String? _imagePath;

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  void _saveWishlist() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mockup: wishlist disimpan'),
        backgroundColor: Color(0xFFA8B50A),
      ),
    );
  }

  // Pilih via sheet Kamera/Galeri -> ImagePicker -> File(_imagePath).
  Future<void> _pilihGambar() async {
    final sumber = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: Colors.black87),
                title: const Text('Ambil dari Kamera',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: Colors.black87),
                title: const Text('Pilih dari Galeri',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
    if (sumber == null) return;
    final foto = await ImagePicker().pickImage(source: sumber, imageQuality: 72);
    if (foto == null) return;
    setState(() => _imagePath = foto.path);
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header: judul tengah + tombol X (tinggi tetap)
            SizedBox(
              height: 48,
              child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned(
                  top: 12,
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Add Wishlist',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
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

            // 2. Isi: gambar ( nullable ) + form, scroll dan form turun ke bawah gambar
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _imagePath == null
                      ? GestureDetector(
                          onTap: _pilihGambar,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: 110,
                            alignment: Alignment.center,
                            child: _buildAddImagePill(),
                          ),
                        )
                      : GestureDetector(
                          onTap: _pilihGambar,
                          child: Container(
                            width: double.infinity,
                            height: 300,
                            color: const Color(0xFFD9D9D9),
                            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                            alignment: Alignment.center,
                            // Path '/'.. = dari ImagePicker (file HP); lainnya = asset mock.
                            child: _imagePath!.startsWith('/')
                                ? Image.file(File(_imagePath!),
                                    height: 252, fit: BoxFit.contain)
                                : MockItemImage(
                                    assetPath: _imagePath!,
                                    fallbackIconSize: 100,
                                  ),
                          ),
                        ),
                  const SizedBox(height: 16),

                  // Form: Name item ?, Color, Category, Harga
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
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
                                initialValue: _harga.isEmpty
                                    ? null
                                    : _harga.replaceAll(RegExp(r'[^0-9]'), ''),
                              ),
                            );
                            if (result != null) {
                              final angka = int.tryParse(result);
                              setState(() =>
                                  _harga = angka == null ? result : _formatHarga(angka));
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 3. Footer: Delete & Save
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _saveWishlist,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddImagePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'add image',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
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
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
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
                    child: const Text(
                      'Add',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
