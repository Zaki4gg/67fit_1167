/// Model Riwayat Pemakaian & Wishlist — versi mockup.
/// Struktur mengikuti androidstudio_fit67; belum dipakai UI karena
/// use case terkait masih tampilan kosong (belum ada datanya).
class RiwayatPemakaian {
  final int? riwayatPemakaianId;
  final int? outfitId; // Null jika hanya memakai 1 item tunggal
  final int? itemId; // Null jika menggunakan setelan utuh
  final String tanggalPemakaian; // Format DateTime.iso8601

  RiwayatPemakaian({
    this.riwayatPemakaianId,
    this.outfitId,
    this.itemId,
    required this.tanggalPemakaian,
  });
}

class Wishlist {
  final int? wishlistId;
  final String nama;
  final String kategori;
  final String warna;
  final int harga;
  final String? imagePath; // Mockup: nullable — barang incaran belum tentu punya foto.

  const Wishlist({
    this.wishlistId,
    required this.nama,
    required this.kategori,
    required this.warna,
    required this.harga,
    this.imagePath,
  });
}
