import 'package:flutter/material.dart';

import '../models/clothing_model.dart';
import '../models/static_options.dart';
import '../widgets/color_picker_sheet.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/size_picker_sheet.dart';
import '../widgets/category_picker_sheet.dart';
import '../widgets/mock_item_image.dart';
import '../main.dart' as app;

const double _largeScreenMinWidth = 600.0;

class ClothingDetailScreen extends StatefulWidget {
  final Item item;

  const ClothingDetailScreen({super.key, required this.item});

  @override
  State<ClothingDetailScreen> createState() => _ClothingDetailScreenState();
}

class _ClothingDetailScreenState extends State<ClothingDetailScreen> {
  late TextEditingController _nameController;
  late bool _isFavorite;
  late bool _isArchived;
  late String _warna;
  late String _ukuran;
  late String _kondisi;
  late String _kategori;
  String? _subKategori;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.nama);
    _isFavorite = widget.item.isFavorite;
    _isArchived = widget.item.isArchived;
    _warna = widget.item.warna;
    _ukuran = widget.item.ukuran;
    _kondisi = widget.item.kondisi;
    _kategori = StaticOptions.categoryParents[widget.item.kategoriId.clamp(
      0,
      StaticOptions.categoryParents.length - 1,
    )];
    _subKategori = widget.item.subKategoriNama;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan disimpan')),
    );
  }

  Future<void> _deleteItem() async {
    final confirm = await showConfirmDelete(
      context,
      title: 'Hapus Pakaian',
      content:
          'Apakah Anda yakin ingin menghapus pakaian ini dari lemari?',
    );

    if (confirm && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mockup: pakaian belum dihapus (belum ada backend).'),
        ),
      );
    }
  }

  Future<void> _pickColors() async {
    final csv = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ColorPickerSheet(initialColorsCsv: _warna),
    );
    if (csv != null && mounted) {
      setState(() => _warna = csv);
    }
  }

  Future<void> _pickCategory() async {
    final sel = await showModalBottomSheet<CategorySelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryPickerSheet(
        initialSub: _subKategori,
        initialParent: _kategori,
      ),
    );
    if (sel != null && mounted) {
      setState(() {
        _kategori = sel.parent;
        _subKategori = sel.sub;
      });
    }
  }

  Future<void> _pickSize() async {
    final selectedSize = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizePickerSheet(initialSize: _ukuran),
    );
    if (selectedSize != null && mounted) {
      if (selectedSize.isNotEmpty) setState(() => _ukuran = selectedSize);
    }
  }

  // Dialog sederhana untuk kondisi.
  Future<void> _showInputDialog({
    required String title,
    required String currentValue,
    required Function(String) onSave,
  }) async {
    final controller = TextEditingController(
      text: currentValue == 'Tidak diisi' ? '' : currentValue,
    );
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Atur $title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Masukkan $title...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
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
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > _largeScreenMinWidth) {
              return Row(
                children: [
                  Expanded(child: _buildPreview()),
                  Container(
                    width: 400,
                    color: Colors.white,
                    child: _buildForm(),
                  ),
                ],
              );
            }
            return Column(
              children: [
                Expanded(child: _buildPreview()),
                Expanded(child: _buildForm()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Stack(
      children: [
        // Mockup: pratinjau memakai gambar asset mock.
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36, 48, 36, 64),
            child: MockItemImage(
              assetPath: widget.item.imagePath,
              fallbackIconSize: 100,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.close, size: 28, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isFavorite = !_isFavorite),
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.redAccent : Colors.black87,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() => _isArchived = !_isArchived);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isArchived
                                ? 'Pakaian diarsipkan'
                                : 'Pakaian dikeluarkan dari arsip',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Icon(
                      _isArchived
                          ? Icons.inventory_2
                          : Icons.inventory_2_outlined,
                      color: Colors.black87,
                      size: 24,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, app.AppRoute.styling),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0084FF),
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Let's style it",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    final colors = StaticOptions.csvToList(_warna);
    final hasCategory = _subKategori != null;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Name item ?',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const Divider(thickness: 1, color: Color(0xFF9CA3AF)),
                  _buildTagSection(
                    title: 'Color',
                    isEmpty: colors.isEmpty,
                    onPick: _pickColors,
                    chips: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: colors
                          .map(
                            (c) => _buildTagChip(
                              label: c,
                              hasColorCircle: true,
                              colorDot: StaticOptions.colorOf(c),
                              onDeleted: () => setState(() {
                                final list = StaticOptions.csvToList(_warna)..remove(c);
                                _warna = StaticOptions.listToCsv(list);
                              }),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const Divider(thickness: 1, color: Color(0xFF9CA3AF)),
                  _buildTagSection(
                    title: 'Category',
                    isEmpty: !hasCategory,
                    onPick: _pickCategory,
                    chips: Wrap(
                      children: [
                        _buildTagChip(
                          label: _subKategori ?? 'Pilih kategori',
                          onDeleted: () => setState(() {
                            _subKategori = null;
                          }),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1, color: Color(0xFF9CA3AF)),
                  _buildFieldRow(
                    label: 'Size',
                    value: _ukuran,
                    onAdd: _pickSize,
                  ),
                  const Divider(thickness: 1, color: Color(0xFF9CA3AF)),
                  _buildFieldRow(
                    label: 'Condition',
                    value: _kondisi,
                    onAdd: () => _showInputDialog(
                      title: 'Kondisi',
                      currentValue: _kondisi,
                      onSave: (val) => setState(() => _kondisi = val),
                    ),
                  ),
                  const Divider(thickness: 1, color: Color(0xFF9CA3AF)),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _deleteItem,
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
                      disabledBackgroundColor: const Color(0xFFD1D5DB),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (isEmpty)
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: onPick,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2E8F0),
                      foregroundColor: const Color(0xFF0084FF),
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.add, size: 26, color: Colors.black87),
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

  Widget _buildTagChip({
    required String label,
    bool hasColorCircle = false,
    Color? colorDot,
    required VoidCallback onDeleted,
  }) {
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
              decoration: BoxDecoration(
                color: colorDot ?? Colors.black87,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDeleted,
            child: const Icon(Icons.close, size: 14, color: Colors.black54),
          ),
        ],
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
