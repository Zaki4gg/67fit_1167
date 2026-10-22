import 'package:flutter/material.dart';

import '../models/static_options.dart';

/// Sheet pilih Colors — multi-select.
/// Dipakai AddClothingScreen & ClothingDetailScreen (widget bersama, versi mockup).
/// Kembalikan CSV string, atau null bila batal.
class ColorPickerSheet extends StatefulWidget {
  final String? initialColorsCsv;

  const ColorPickerSheet({super.key, this.initialColorsCsv});

  @override
  State<ColorPickerSheet> createState() => _ColorPickerSheetState();
}

class _ColorPickerSheetState extends State<ColorPickerSheet> {
  late Set<String> selected;

  @override
  void initState() {
    super.initState();
    selected = StaticOptions.csvToList(widget.initialColorsCsv).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 24, color: Colors.black87),
              ),
              const Expanded(
                child: Text(
                  'Colors',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
          const SizedBox(height: 32),
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: StaticOptions.colors.map((item) {
                  final name = item['name'] as String;
                  final color = item['value'] as Color;
                  final isSelected = selected.contains(name);
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (isSelected) {
                        selected.remove(name);
                      } else {
                        selected.add(name);
                      }
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.black87 : Colors.black26,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: color == Colors.white ? Border.all(color: Colors.black26) : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            name,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2EAB6B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, size: 12, color: Colors.black),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, StaticOptions.listToCsv(selected.toList())),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD1D5DB),
                foregroundColor: Colors.black87,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Confirm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
