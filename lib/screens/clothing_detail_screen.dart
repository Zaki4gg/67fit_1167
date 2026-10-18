import 'package:flutter/material.dart';

import '../models/clothing_model.dart';

/// Halaman detail satu pakaian, dibuka lewat Navigator.push.
/// Aksi favorite/delete diteruskan lewat props ke state utama.
class ClothingDetailScreen extends StatelessWidget {
  final Item item;
  final void Function(Item item) onToggleFavorite;
  final void Function(Item item) onDeleteItem;

  const ClothingDetailScreen({
    super.key,
    required this.item,
    required this.onToggleFavorite,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(36, 48, 36, 64),
                      child: Icon(Icons.checkroom,
                          size: 100, color: Colors.black26),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          size: 28, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.nama,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500)),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            onDeleteItem(item);
                            Navigator.pop(context);
                          },
                          child: const Text('Delete',
                              style: TextStyle(
                                  color: Colors.red, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              onToggleFavorite(item);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9CACAF),
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                            child: Text(item.isFavorite
                                ? 'Unfavorite'
                                : 'Favorite'),
                          ),
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
}
