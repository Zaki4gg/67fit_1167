import 'package:flutter/material.dart';

/// Kumpulan gambar pakaian mockup (assets/pakaian).
/// Dipakai bersama oleh Home, Wardrobe, Add, Detail, Outfit & Styling.
class MockPakaian {
  static const String kaos = 'assets/pakaian/baju hitam kaos_no background.jpg';
  static const String jeans = 'assets/pakaian/jeans biru_no background.jpg';
  static const String jaket =
      'assets/pakaian/corduroy jacket_no background.png';
  static const String sepatu =
      'assets/pakaian/sepatu onitsuka hitam_no background.png';
  static const String outfitSantai = 'assets/pakaian/outfit_santai.png';
  static const String outfitMall = 'assets/pakaian/outfit_mall.png';

  static const List<String> semua = [
    kaos,
    jeans,
    jaket,
    sepatu,
    outfitSantai,
    outfitMall,
  ];
}

class MockItemImage extends StatelessWidget {
  final String assetPath;
  final double fallbackIconSize;

  const MockItemImage({
    super.key,
    required this.assetPath,
    this.fallbackIconSize = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) =>
          Icon(Icons.checkroom, size: fallbackIconSize, color: Colors.black26),
    );
  }
}
