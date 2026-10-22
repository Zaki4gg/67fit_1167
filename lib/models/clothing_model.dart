/// Model Item — versi mockup: sama bentuknya dengan androidstudio_fit67
/// tetapi tanpa toMap/fromMap (belum ada database) dan imagePath disimpan
/// sebagai teks (UI pakai placeholder icon mock).
class Item {
  final int? itemId;
  final int kategoriId;
  final String? subKategoriNama; // Leaf taksonomi, mis. "Shirt". Null = parent saja.
  final String nama;
  final String warna; // CSV multi-select nama warna
  final String ukuran;
  final String kondisi;
  final String imagePath;
  final bool isFavorite;
  final bool isArchived; // Use case "Mengarsipkan Pakaian"

  const Item({
    this.itemId,
    this.kategoriId = 1,    this.subKategoriNama,
    required this.nama,
    this.warna = 'Tidak diisi',
    this.ukuran = 'Tidak diisi',
    this.kondisi = 'Good Condition',
    this.imagePath = '',
    this.isFavorite = false,
    this.isArchived = false,
  });
}
