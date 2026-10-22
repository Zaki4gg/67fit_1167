/// Model Outfit — versi mockup: sama bentuknya dengan androidstudio_fit67
/// tetapi tanpa toMap/fromMap dan OutfitItem (belum ada database).
class Outfit {
  final int? outfitId;
  final String nama;
  final String style; // CSV multi-select, opsi statis StaticOptions.styles
  final String season; // CSV multi-select, opsi statis StaticOptions.seasons
  final String imagePath; // Mockup: path asset gambar
  final bool isFavorite;
  final bool isArchived;

  const Outfit({
    this.outfitId,
    required this.nama,
    this.style = '',
    this.season = '',
    this.imagePath = '',
    this.isFavorite = false,
    this.isArchived = false,
  });
}
