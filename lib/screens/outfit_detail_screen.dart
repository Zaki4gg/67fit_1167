import 'package:flutter/material.dart';

import '../models/outfit_model.dart';
import '../models/static_options.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/mock_item_image.dart';
import '../main.dart' as app;

const double _largeScreenMinWidth = 600.0;

class OutfitDetailScreen extends StatefulWidget {
  final Outfit outfit;

  const OutfitDetailScreen({super.key, required this.outfit});

  @override
  State<OutfitDetailScreen> createState() => _OutfitDetailScreenState();
}

class _OutfitDetailScreenState extends State<OutfitDetailScreen> {
  late TextEditingController _nameController;
  late List<String> _styles;
  late List<String> _seasons;
  late bool _isFavorite;
  late bool _isArchived;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.outfit.nama == 'Outfit Baru' ? '' : widget.outfit.nama,
    );
    _styles = StaticOptions.csvToList(widget.outfit.style);
    _seasons = StaticOptions.csvToList(widget.outfit.season);
    _isFavorite = widget.outfit.isFavorite;
    _isArchived = widget.outfit.isArchived;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Outfit disimpan')),
    );
  }

  Future<void> _delete() async {
    final confirm = await showConfirmDelete(
      context,
      title: 'Hapus Outfit',
      content: 'Hapus outfit ini dari koleksi?',
    );
    if (confirm && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mockup: outfit belum dihapus (belum ada backend).'),
        ),
      );
    }
  }

  // Style/Season statis multi-select (sheet generik di widgets/).
  Future<void> _pickOptions({
    required String title,
    required List<String> options,
    required List<String> initialSelected,
    required bool useGrid,
    required ValueChanged<List<String>> onDone,
  }) async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MultiSelectSheet(
        title: title,
        options: options,
        initialSelected: initialSelected,
        useGrid: useGrid,
      ),
    );
    if (result != null && mounted) onDone(result);
  }

  void _applyStyle(List<String> result) {
    setState(() {
      _styles
        ..clear()
        ..addAll(result);
    });
  }

  void _applySeason(List<String> result) {
    setState(() {
      _seasons
        ..clear()
        ..addAll(result);
    });
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
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36, 48, 36, 64),
            child: MockItemImage(
              assetPath: widget.outfit.imagePath,
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
                    onTap: () => setState(() => _isArchived = !_isArchived),
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
                    Navigator.pushNamed(context, app.AppRoute.planner),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0084FF),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Schedule',
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
                      hintText: 'Name style?',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const Divider(thickness: 1, color: Color(0xFF9CA3AF)),
                  _buildTagSection(
                    title: 'Style',
                    tags: _styles,
                    onPick: () => _pickOptions(
                      title: 'Style',
                      options: StaticOptions.styles,
                      initialSelected: _styles,
                      useGrid: false,
                      onDone: _applyStyle,
                    ),
                    onToggle: (t) => setState(() => _styles.remove(t)),
                  ),
                  const Divider(thickness: 1, color: Color(0xFF9CA3AF)),
                  _buildTagSection(
                    title: 'Season',
                    tags: _seasons,
                    onPick: () => _pickOptions(
                      title: 'Season',
                      options: StaticOptions.seasons,
                      initialSelected: _seasons,
                      useGrid: true,
                      onDone: _applySeason,
                    ),
                    onToggle: (t) => setState(() => _seasons.remove(t)),
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
                  onPressed: _delete,
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
                    onPressed: _save,
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
    required List<String> tags,
    required VoidCallback onPick,
    required void Function(String) onToggle,
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
              if (tags.isEmpty)
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
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
                  .map(
                    (t) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            t,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => onToggle(t),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _MultiSelectSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> initialSelected;
  final bool useGrid;

  const _MultiSelectSheet({
    required this.title,
    required this.options,
    this.initialSelected = const [],
    this.useGrid = false,
  });

  @override
  State<_MultiSelectSheet> createState() => _MultiSelectSheetState();
}

class _MultiSelectSheetState extends State<_MultiSelectSheet> {
  late final Set<String> _selected = widget.initialSelected.toSet();

  void _toggle(String opt) {
    setState(() {
      _selected.contains(opt) ? _selected.remove(opt) : _selected.add(opt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      color: Colors.white,
      child: Column(
        children: [
          // Header: X kiri, judul tengah
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child:
                      const Icon(Icons.close, size: 24, color: Colors.black87),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: widget.useGrid ? _buildGrid() : _buildList(),
          ),
          const SizedBox(height: 16),

          // Tombol Confirm
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _selected.toList()),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selected.isEmpty
                    ? const Color(0xFFD9DCE1)
                    : const Color(0xFF9CACAF),
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

  // List baris + divider, terpilih = teks bold + lingkaran cek hijau.
  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: widget.options.length,
      itemBuilder: (context, index) {
        final opt = widget.options[index];
        final isSelected = _selected.contains(opt);
        return InkWell(
          onTap: () => _toggle(opt),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        opt,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w400,
                          color: isSelected
                              ? Colors.black
                              : const Color(0xFF6B7280),
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
                        child:
                            const Icon(Icons.check, size: 14, color: Colors.white),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFF6B7280)),
            ],
          ),
        );
      },
    );
  }

  // Grid pill, terpilih = abu-biru + bold.
  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: widget.options.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2.6,
      ),
      itemBuilder: (context, index) {
        final opt = widget.options[index];
        final isSelected = _selected.contains(opt);
        return GestureDetector(
          onTap: () => _toggle(opt),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF9CACAF) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF6B7280), width: 1),
            ),
            child: Text(
              opt,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
