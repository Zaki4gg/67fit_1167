/// Satu pilihan item/outfit di picker & satu entri isi plan.
class PickOption {
  final String nama;
  final String imagePath;
  final bool isOutfit;
  const PickOption(this.nama, this.imagePath, {this.isOutfit = false});
}

/// Nomor hari unik (epoch days) — dipakai sebagai key map plan.
int epochOf(DateTime date) => date.difference(DateTime(1970, 1, 1)).inDays;
