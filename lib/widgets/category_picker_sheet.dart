import 'package:flutter/material.dart';

import '../models/static_options.dart';

/// Sheet pilih Category — mockup (dipakai AddClothingScreen &
/// ClothingDetailScreen, jadi tetap file widget sendiri).
/// Sumber datanya StaticOptions (seed), penambahan sub hanya berlaku
/// di state sheet ini (mock, belum ada database). Dialog "New {Parent}"
/// dari add_subcategory_dialog.dart dilebur ke sini karena hanya dipakai
/// oleh sheet ini.
const double _largeScreenMinWidth = 600.0;

/// Hasil pilihan kategori: parent + leaf (sebagai nama string, versi mockup).
class CategorySelection {
  final String parent;
  final String? sub;

  const CategorySelection({required this.parent, this.sub});
}

class CategoryPickerSheet extends StatefulWidget {
  /// Leaf terpilih, mis. "Shirt".
  final String? initialSub;

  /// Parent terpilih, mis. "Tops".
  final String? initialParent;

  const CategoryPickerSheet({super.key, this.initialSub, this.initialParent});

  @override
  State<CategoryPickerSheet> createState() => _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends State<CategoryPickerSheet> {
  String? selectedSub;
  String? expandedParent;

  // Salinan daftar sub per parent (mock: tambah/hapus hanya di sini).
  late Map<String, List<String>> _subs;
  // Sub buatan user sesi ini (mock pengganti is_custom) — boleh dihapus.
  final Set<String> _customSubs = {};

  @override
  void initState() {
    super.initState();
    _subs = {
      for (final entry in StaticOptions.subCategorySeeds.entries)
        entry.key: List<String>.from(entry.value),
    };
    selectedSub = widget.initialSub;
    expandedParent = widget.initialParent ?? _parentOf(widget.initialSub) ?? 'Tops';
  }

  String? _parentOf(String? sub) {
    if (sub == null) return null;
    for (final entry in _subs.entries) {
      if (entry.value.contains(sub)) return entry.key;
    }
    return null;
  }

  // Ikon pensil per parent: buka dialog New {Parent}, tambah sub custom.
  Future<void> _showAddSubDialog(String parentName) async {
    final name = await _showAddSubcategoryDialog(context, parentName);
    if (name == null || !mounted) return;
    setState(() {
      _subs[parentName]!.add(name);
      _customSubs.add(name);
      selectedSub = name;
      expandedParent = parentName;
    });
  }

  // Hapus sub CUSTOM saja (dibuat lewat pensil). Seed dikunci.
  Future<void> _deleteSub(String parentName, String sub) async {
    if (!_customSubs.contains(sub)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sub-kategori bawaan tidak bisa dihapus.')),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hapus "$sub"?'),
        content: const Text('Item yang memakai sub ini tetap ada, hapus sub category'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() {
      _subs[parentName]!.remove(sub);
      _customSubs.remove(sub);
      if (selectedSub == sub) selectedSub = null;
    });
  }

  void _confirm() {
    final parentName = selectedSub != null ? _parentOf(selectedSub) ?? expandedParent : expandedParent;
    Navigator.pop(
      context,
      CategorySelection(parent: parentName ?? 'Tops', sub: selectedSub),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Material (bukan Container) supaya ink splash ListTile tergambar
    // terlihat — sheet ini dibuka dengan backgroundColor transparan.
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Material(
        color: const Color(0xFFF8F9FA),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final body = _buildBody();
            if (constraints.maxWidth > _largeScreenMinWidth) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: body,
                ),
              );
            }
            return body;
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 24, color: Colors.black87),
              ),
              const Expanded(
                child: Text(
                  'Category',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: StaticOptions.categoryParents.map((parentName) {
                final subs = _subs[parentName] ?? const <String>[];
                final isExpanded = expandedParent == parentName;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        parentName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isExpanded ? Colors.black : Colors.black54,
                        ),
                      ),
                      trailing: isExpanded
                          ? IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: Colors.black87,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => _showAddSubDialog(parentName),
                            )
                          : null,
                      onTap: () => setState(() {
                        expandedParent = isExpanded ? null : parentName;
                      }),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Column(
                          children: subs.map((sub) {
                            final isSelected = selectedSub == sub;
                            return GestureDetector(
                              onTap: () => setState(() {
                                selectedSub = isSelected ? null : sub;
                              }),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: isSelected
                                              ? BoxDecoration(
                                                  color: const Color(0xFFB9C4CE),
                                                  borderRadius: BorderRadius.circular(10),
                                                )
                                              : null,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  sub,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: isSelected ? Colors.black : Colors.black54,
                                                  ),
                                                ),
                                              ),
                                              if (isSelected)
                                                Container(
                                                  width: 22,
                                                  height: 22,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFF2EAB6B),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.check,
                                                    size: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Ikon hapus hanya untuk sub custom.
                                      if (_customSubs.contains(sub))
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, size: 20, color: Colors.black54),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () => _deleteSub(parentName, sub),
                                        ),
                                    ],
                                  ),
                                  const Divider(height: 1, color: Colors.black12),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    const Divider(height: 1, color: Colors.black26),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _confirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedSub != null
                    ? const Color(0xFF9FB2BF)
                    : const Color(0xFFD1D5DB),
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog "New {Parent}" — dilebur ke file ini karena hanya dipakai oleh
/// CategoryPickerSheet. Judul kiri + X kanan, input tengah, tombol Save abu.
/// Mengembalikan nama sub baru (trim) atau null bila batal/kosong.
class _AddSubcategoryDialog extends StatefulWidget {
  final String parentName;

  const _AddSubcategoryDialog({required this.parentName});

  @override
  State<_AddSubcategoryDialog> createState() => _AddSubcategoryDialogState();
}

class _AddSubcategoryDialogState extends State<_AddSubcategoryDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    Navigator.pop(context, name.isEmpty ? null : name);
  }

  @override
  Widget build(BuildContext context) {
    // Dialog bawaan sediakan Material ancestor untuk TextField/Button.
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 300,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black87, width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New ${widget.parentName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: 180,
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        hintText: '......',
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: 140,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD1D5DB),
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper: tampilkan dialog tambah sub di bawah [parentName].
Future<String?> _showAddSubcategoryDialog(BuildContext context, String parentName) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => _AddSubcategoryDialog(parentName: parentName),
  );
}
