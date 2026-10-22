import 'package:flutter/material.dart';

/// Sheet "Price" sebagai widget terpisah — desain sesuai mockup user:
/// judul "Price" kiri, X kanan, TextField bulat rata tengah (hint "....."),
/// tombol Save abu-abu di tengah bawah.
///
/// Balikan: `Navigator.pop(context, angkaFormat)` — isi TextField mentah.
/// Rekursif dipakai nanti (mis. saat form kamera/galeri siap);
/// untuk kolom Harga wishlist saat ini kembali memakai dialog sederhana.
///
/// Contoh pemakaian:
/// ```dart
/// final nilai = await showModalBottomSheet<String>(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.white,
///   builder: (_) => PriceSheet(initialValue: '199000'),
/// );
/// ```
class PriceSheet extends StatelessWidget {
  final String? initialValue;

  const PriceSheet({super.key, this.initialValue});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialValue);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 24, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '.....',
                  hintStyle: const TextStyle(color: Colors.black38),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black45),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 160,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, controller.text.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDEDEDE),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
