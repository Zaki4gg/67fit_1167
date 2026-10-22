import 'dart:io';

import 'package:flutter/material.dart';

import '../models/static_options.dart';
import '../widgets/mock_item_image.dart';
import '../widgets/category_picker_sheet.dart';
import '../widgets/color_picker_sheet.dart';
import '../widgets/size_picker_sheet.dart';

/// Halaman Review Clothes — dari androidstudio_fit67, versi mockup:
/// gambar datang dari kamera/galeri (argumen rute, path file) atau
/// placeholder asset bila null. Tanpa database; Save hanya SnackBar.
class AddClothingScreen extends StatefulWidget {
  final String? imagePath;

  const AddClothingScreen({super.key, this.imagePath});

  @override
  State<AddClothingScreen> createState() => _AddClothingScreenState();
}

class _AddClothingScreenState extends State<AddClothingScreen> {
  final _namaController = TextEditingController();
  late final String? _imagePath = widget.imagePath;
  bool _isProcessing = false;
  String _warnaCsv = '';
  String _ukuran = '';
  String _kondisi = '';
  String _kategori = '';
  String? _subKategori;

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  // Mockup: tidak tersimpan ke mana-mana, hanya SnackBar + tutup halaman.
  Future<void> _saveClothing() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    // Mockup: simpan hanya seberkas delay UI — belum ada database.
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => _isProcessing = false);
    Navigator.pop(context); // Tutup layar Review Clothes
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mockup: pakaian disimpan'),
        backgroundColor: Color(0xFF1C2C46),
      ),
    );
  }

  void _showInputDialog({required String title, required String currentValue, required Function(String) onSave}) {
    final controller = TextEditingController(text: currentValue == 'Tidak diisi' ? '' : currentValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Atur $title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Masukkan $title...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C2C46),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E7EB), // Latar abu-abu terang atas
      body: SafeArea(
        child: Column(
          children: [
            // 1. Area Header Atas & Gambar
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  // Judul "Review Clothes" di Tengah Atas
                  const Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Review Clothes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  // Tombol 'X' di Pojok Kanan Atas
                  Positioned(
                    top: 8,
                    right: 12,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 28, color: Colors.black87),
                      onPressed: _isProcessing ? null : () => Navigator.pop(context),
                    ),
                  ),

                  // Pratinjau: foto dari kamera/galeri (ImagePicker) atau placeholder.
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(36, 48, 36, 16),
                      child: _imagePath != null
                          ? Image.file(File(_imagePath!),
                              height: 260, fit: BoxFit.contain)
                          : const MockItemImage(
                              assetPath: MockPakaian.kaos,
                              fallbackIconSize: 100,
                            ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Kartu Putih Bawah (Panel Formulir)
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          // Input Nama Pakaian ("Name Clothes")
                          TextField(
                            controller: _namaController,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                            decoration: const InputDecoration(
                              hintText: 'Name Clothes',
                              hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black38),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(thickness: 1, color: Color(0xFFE5E7EB)),

                          // Bagian Color & Category: pola _buildTagSection ala
                          // clothing detail — kosong = tombol Add di kanan judul,
                          // isi = chip di bawah judul (bisa dihapus).
                          _buildTagSection(
                            title: 'Color',
                            isEmpty: StaticOptions.csvToList(_warnaCsv).isEmpty,
                            onPick: _bukaPilihWarna,
                            chips: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: StaticOptions.csvToList(_warnaCsv)
                                  .map(
                                    (c) => _buildTagChip(
                                      label: c,
                                      hasColorCircle: true,
                                      colorDot: StaticOptions.colorOf(c),
                                      onDeleted: () => setState(() {
                                        final list = StaticOptions.csvToList(_warnaCsv)..remove(c);
                                        _warnaCsv = StaticOptions.listToCsv(list);
                                      }),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(thickness: 1, color: Color(0xFFE5E7EB)),

                          _buildTagSection(
                            title: 'Category',
                            isEmpty: _kategori.isEmpty,
                            onPick: _bukaPilihKategori,
                            chips: Wrap(
                              children: [
                                _buildTagChip(
                                  label: _subKategori ?? _kategori,
                                  onDeleted: () => setState(() {
                                    _kategori = '';
                                    _subKategori = null;
                                  }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(thickness: 1, color: Color(0xFFE5E7EB)),

                          // Bagian Size
                          _buildFieldRow(
                            label: 'Size',
                            value: _ukuran,
                            onAdd: () async {
                              final selectedSize = await showModalBottomSheet<String>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => SizePickerSheet(
                                  initialSize: _ukuran.isEmpty ? null : _ukuran,
                                ),
                              );
                              if (selectedSize != null && selectedSize.isNotEmpty) {
                                setState(() => _ukuran = selectedSize);
                              }
                            },
                          ),
                          const Divider(thickness: 1, color: Color(0xFFE5E7EB)),

                          // Bagian Condition
                          _buildFieldRow(
                            label: 'Condition',
                            value: _kondisi,
                            onAdd: () {
                              _showInputDialog(title: 'Kondisi', currentValue: _kondisi, onSave: (val) => setState(() => _kondisi = val));
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    // Tombol Save
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _saveClothing,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C2C46),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: _isProcessing
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
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

  // Pola sama dengan _buildTagSection di clothing_detail_screen:
  // judul + (kosong: tombol Add | isi: ikon +) di satu baris, chip di bawah.
  Widget _buildTagSection({
    required String title,
    required bool isEmpty,
    required VoidCallback onPick,
    required Widget chips,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
              isEmpty
                  ? _buildAddPill(onPressed: onPick)
                  : IconButton(
                      icon: const Icon(Icons.add, size: 24, color: Colors.black87),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onPick,
                    ),
            ],
          ),
          if (!isEmpty) ...[
            const SizedBox(height: 8),
            chips,
          ],
        ],
      ),
    );
  }

  Widget _buildTagChip({required String label, bool hasColorCircle = false, Color? colorDot, required VoidCallback onDeleted}) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasColorCircle) ...[
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: colorDot ?? Colors.black87, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDeleted,
            child: const Icon(Icons.close, size: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Future<void> _bukaPilihWarna() async {
    final csv = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ColorPickerSheet(initialColorsCsv: _warnaCsv),
    );
    if (csv != null) {
      setState(() => _warnaCsv = csv);
    }
  }

  Future<void> _bukaPilihKategori() async {
    final sel = await showModalBottomSheet<CategorySelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryPickerSheet(initialSub: _subKategori),
    );
    if (sel != null) {
      setState(() {
        _kategori = sel.parent;
        _subKategori = sel.sub;
      });
    }
  }

  // Tombol "Add" kecil abu-abu (dipakai Color/Category/Size/Condition saat kosong).
  Widget _buildAddPill({required VoidCallback onPressed}) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE2E8F0),
          foregroundColor: const Color(0xFF0084FF),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: const Text('Add', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFieldRow({required String label, required String value, required VoidCallback onAdd}) {
    final hasValue = value.isNotEmpty && value != 'Tidak diisi';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
          hasValue
              ? InkWell(
                  onTap: onAdd,
                  child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1C2C46))),
                )
              : _buildAddPill(onPressed: onAdd),
        ],
      ),
    );
  }
}
