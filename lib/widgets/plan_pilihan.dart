import 'package:flutter/material.dart';

import 'mock_item_image.dart';
import 'plan_types.dart';

/// `Confirm ( n )` mempop sheet mengembalikan semua pilihan (lintas tab).
class PlanPickerSheet extends StatefulWidget {
  final String dayTitle;
  final String daySubtitle;
  final Set<String> initialSelected;
  final List<PickOption> itemOptions;
  final List<PickOption> outfitOptions;

  const PlanPickerSheet({
    super.key,
    required this.dayTitle,
    required this.daySubtitle,
    required this.initialSelected,
    required this.itemOptions,
    required this.outfitOptions,
  });

  @override
  State<PlanPickerSheet> createState() => _PlanPickerSheetState();
}

class _PlanPickerSheetState extends State<PlanPickerSheet> {
  late bool _isOutfitTab = false;
  late final Set<String> _selected = {...widget.initialSelected};

  List<PickOption> get _currentOptions =>
      _isOutfitTab ? widget.outfitOptions : widget.itemOptions;

  void _toggle(PickOption option) {
    setState(() {
      if (_selected.contains(option.nama)) {
        _selected.remove(option.nama);
      } else {
        _selected.add(option.nama);
      }
    });
  }

  // Kumpulkan pilihan lintas tab (Items + Outfits).
  List<PickOption> get _confirmed {
    final all = [...widget.itemOptions, ...widget.outfitOptions];
    return all.where((o) => _selected.contains(o.nama)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.92,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, size: 28, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
              ],
            ),
          ),

          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black26),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabChip('Items', _isOutfitTab == false),
                _buildTabChip('Outfits', _isOutfitTab == true),
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.95,
              ),
              itemCount: _currentOptions.length,
              itemBuilder: (context, index) {
                final option = _currentOptions[index];
                final isSelected = _selected.contains(option.nama);
                return GestureDetector(
                  onTap: () => _toggle(option),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFBDBDBD)
                          : const Color(0xFFE5E5E5),
                      border: isSelected
                          ? Border.all(color: const Color(0xFF0084FF), width: 2)
                          : Border.all(color: Colors.transparent, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: MockItemImage(
                              assetPath: option.imagePath,
                              fallbackIconSize: 56,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            bottom: 4,
                            left: 8,
                            right: 8,
                            child: Container(
                              color: const Color(0xFFC6D93B),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              alignment: Alignment.center,
                              child: const Text(
                                'Dipilih',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: Container(
              margin: const EdgeInsets.fromLTRB(32, 8, 32, 16),
              height: 48,
              child: ElevatedButton(
                onPressed: _selected.isEmpty
                    ? null
                    : () => Navigator.pop(context, _confirmed),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9CACAF),
                  foregroundColor: Colors.black87,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Confirm ( ${_selected.length} )',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String label, bool active) {
    return GestureDetector(
      onTap: () => setState(() => _isOutfitTab = label == 'Outfits'),
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
