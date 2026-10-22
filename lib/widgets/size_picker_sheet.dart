import 'package:flutter/material.dart';

import '../models/static_options.dart';

/// Sheet pilih Size — single-select, bisa kosong.
/// Dipakai AddClothingScreen & ClothingDetailScreen (widget bersama, versi mockup).
/// Sesuai Figma: header X | Size | Reset, grid pill, tap ulang = batal pilih,
/// Confirm hijau hanya bila berubah, abu bila sama.
const double _largeScreenMinWidth = 600.0;

class SizePickerSheet extends StatefulWidget {
  final String? initialSize;

  const SizePickerSheet({super.key, this.initialSize});

  @override
  State<SizePickerSheet> createState() => _SizePickerSheetState();
}

class _SizePickerSheetState extends State<SizePickerSheet> {
  String? selectedSize;

  String? get _initial {
    final v = widget.initialSize?.trim() ?? '';
    if (v.isEmpty || v == 'Tidak diisi') return null;
    return v;
  }

  bool get _isDirty => selectedSize != _initial;

  @override
  void initState() {
    super.initState();
    selectedSize = _initial;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
                  'Size',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => selectedSize = null),
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              itemCount: StaticOptions.sizes.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 140,
                mainAxisSpacing: 24,
                crossAxisSpacing: 16,
                childAspectRatio: 2.4,
              ),
              itemBuilder: (context, index) {
                final size = StaticOptions.sizes[index];
                final isSelected = selectedSize == size;
                return GestureDetector(
                  onTap: () => setState(() {
                    selectedSize = isSelected ? null : size;
                  }),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF9FB2BF) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.black87 : const Color(0xFF6B7280),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              // '' = kosong terkonfirmasi; null (dismiss X) = batal, caller abaikan.
              onPressed: _isDirty ? () => Navigator.pop(context, selectedSize ?? '') : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9CACAF),
                disabledBackgroundColor: const Color(0xFFD1D5DB),
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
