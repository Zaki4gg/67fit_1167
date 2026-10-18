/// Model data satu pakaian. Versi materi Widget & Navigasi:
/// hanya disimpan di memori (List di StatefulWidget), belum ada DB.
class Item {
  final int id;
  final String nama;
  bool isFavorite;

  Item({
    required this.id,
    required this.nama,
    this.isFavorite = false,
  });
}
