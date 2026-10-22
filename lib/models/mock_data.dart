import 'clothing_model.dart';
import 'history_wishlist_model.dart';
import 'outfit_model.dart';
import '../widgets/mock_item_image.dart';

/// Satu sumber data dummy untuk semua halaman (mockup tanpa backend):
/// wardrobe, detail, dan planner memakai list di sini agar nama/gambar
/// selalu konsisten antar halaman.
class MockData {
  // 4 pakaian contoh (dulu dari WardrobeProvider/SQLite mockup).
  static const List<Item> items = [
    Item(
      itemId: 1,
      kategoriId: 0,
      subKategoriNama: 'T-Shirt',
      nama: 'Kaos Hitam',
      warna: 'Hitam',
      ukuran: 'M',
      kondisi: 'Good Condition',
      imagePath: MockPakaian.kaos,
      isFavorite: true,
    ),
    Item(
      itemId: 2,
      kategoriId: 1,
      subKategoriNama: 'Jeans',
      nama: 'Jeans Biru',
      warna: 'Biru',
      ukuran: 'L',
      kondisi: 'Good Condition',
      imagePath: MockPakaian.jeans,
    ),
    Item(
      itemId: 3,
      kategoriId: 2,
      subKategoriNama: 'Jacket',
      nama: 'Jacket Corduroy',
      warna: 'Brown',
      ukuran: 'M',
      kondisi: 'Good Condition',
      imagePath: MockPakaian.jaket,
    ),
    Item(
      itemId: 4,
      kategoriId: 7,
      subKategoriNama: 'Sneakers',
      nama: 'Onitsuka Hitam',
      warna: 'Hitam',
      ukuran: '42',
      kondisi: 'Good Condition',
      imagePath: MockPakaian.sepatu,
      isArchived: true,
    ),
  ];

  // Outfit contoh (belum tersimpan ke mana-mana).
  static const List<Outfit> outfits = [
    Outfit(
      outfitId: 1,
      nama: 'Outfit Santai',
      style: 'Casual, Minimalist',
      season: 'Dry, Summer',
      imagePath: MockPakaian.outfitSantai,
      isFavorite: true,
    ),
    Outfit(
      outfitId: 2,
      nama: 'Outfit Mall',
      style: 'Casual, Minimalist',
      season: 'Dry, Summer',
      imagePath: MockPakaian.outfitMall,
      // Contoh terarsip: tampil hanya saat filter Arsip di wardrobe aktif.
      isArchived: true,
    ),
  ];

  static const List<Wishlist> wishlist = [
    Wishlist(nama: 'Kemeja Flanel', kategori: 'Tops', warna: 'Merah', harga: 199000, imagePath: MockPakaian.jaket),
    Wishlist(nama: 'Tote Bag', kategori: 'Bags', warna: 'Brown', harga: 149000),
    Wishlist(nama: 'Sneakers Putih', kategori: 'Footwear', warna: 'Putih', harga: 899000, imagePath: MockPakaian.sepatu),
    Wishlist(nama: 'Cardigan Beige', kategori: 'Outerwear', warna: 'Beige', harga: 259000),
  ];
}
