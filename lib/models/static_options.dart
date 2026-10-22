import 'package:flutter/material.dart';

/// Opsi statis sesuai desain Figma + seed kategori dari
/// DatabaseHelper (androidstudio_fit67). Di sini tidak ada folder data/,
/// jadi konstanta statis ditempatkan di models/.
class StaticOptions {
  static const List<Map<String, Object>> colors = [
    {'name': 'Hitam', 'value': Color(0xFF000000)},
    {'name': 'Putih', 'value': Color(0xFFFFFFFF)},
    {'name': 'Abu-abu', 'value': Color(0xFF9AA0A6)},
    {'name': 'Navy', 'value': Color(0xFF1C2C46)},
    {'name': 'Biru', 'value': Color(0xFF2F80ED)},
    {'name': 'Toska', 'value': Color(0xFF40B8A6)},
    {'name': 'Hijau', 'value': Color(0xFF2EAB6B)},
    {'name': 'Army', 'value': Color(0xFF4B5320)},
    {'name': 'Kuning', 'value': Color(0xFFF5D90A)},
    {'name': 'Orange', 'value': Color(0xFFF2994A)},
    {'name': 'Brown', 'value': Color(0xFF7A3E1D)},
    {'name': 'Beige', 'value': Color(0xFFE8DCC8)},
    {'name': 'Merah', 'value': Color(0xFFE53935)},
    {'name': 'Maroon', 'value': Color(0xFF7B1E26)},
    {'name': 'Pink', 'value': Color(0xFFE5A9BE)},
    {'name': 'Ungu', 'value': Color(0xFF9B51E0)},
  ];

  static Color colorOf(String name) {
    for (final c in colors) {
      if (c['name'] == name) return c['value'] as Color;
    }
    return Colors.black87;
  }

  static const List<String> sizes = [
    'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL',
  ];

  static const List<String> styles = [
    'Casual', 'Sporty', 'Streetwear', 'Vintage',
    'Minimalist', 'Classic', 'Edgy', 'Preppy',
  ];

  static const List<String> seasons = [
    'Winter', 'Autumn', 'Summer', 'Spring', 'Dry', 'Rainy',
  ];

  /// Seed parent kategori (dulu DatabaseHelper.parentSeeds).
  static const List<String> categoryParents = [
    'Tops',
    'Bottoms',
    'Outerwear',
    'One-Piece',
    'Underwear',
    'Accessories',
    'Bags',
    'Footwear',
  ];

  /// Seed sub kategori (dulu DatabaseHelper.subSeeds).
  static const Map<String, List<String>> subCategorySeeds = {
    'Tops': ['Shirt', 'T-Shirt', 'Hoodie', 'Sweater'],
    'Bottoms': ['Jeans', 'Trousers', 'Shorts', 'Skirt'],
    'Outerwear': ['Jacket', 'Coat', 'Blazer'],
    'One-Piece': ['Dress', 'Jumpsuit'],
    'Underwear': ['Inner', 'Socks'],
    'Accessories': ['Hat', 'Belt', 'Scarf'],
    'Bags': ['Backpack', 'Tote Bag', 'Sling Bag'],
    'Footwear': ['Sneakers', 'Boots', 'Sandals'],
  };

  /// CSV <-> List helper. Nanti disimpan multi-select sebagai string koma.
  static List<String> csvToList(String? csv) {
    if (csv == null || csv.trim().isEmpty || csv == 'Tidak diisi') return [];
    return csv.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  static String listToCsv(List<String> list) => list.join(', ');
}
