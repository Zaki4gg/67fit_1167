import 'package:flutter/material.dart';

import '../widgets/mock_item_image.dart';

/// Halaman Riwayat Pemakaian — versi mockup sesuai desain user:
/// daftar kotak per tanggal berisi thumbnail item/outfit yang dipakai
/// beserta namanya. Semua data statis (mock), tanpa backend.
class UsageHistoryScreen extends StatelessWidget {
  const UsageHistoryScreen({super.key});

  static const List<String> _dayNames = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];
  static const List<String> _fullMonthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  // Data riwayat mock (tanggal spesifik agar konsisten dengan desain).
  // final (bukan const): DateTime tidak punya constructor const di Dart.
  static final List<_RiwayatHari> _riwayat = [
    _RiwayatHari(
      DateTime(2026, 10, 15),
      const [
        _RiwayatEntry('Kaos Hitam', MockPakaian.kaos),
        _RiwayatEntry('Outfit Mall', MockPakaian.outfitMall),
      ],
    ),
    _RiwayatHari(
      DateTime(2026, 10, 22),
      const [
        _RiwayatEntry('Kaos Hitam', MockPakaian.kaos),
        _RiwayatEntry('Outfit Mall', MockPakaian.outfitMall),
        _RiwayatEntry('Jeans Biru', MockPakaian.jeans),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header: X kiri, judul tengah (Row — bukan Stack, agar tidak
            // ketumpukan)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, size: 28, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Riwayat Pemakaian',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // Spasi kanan 1:1 lebar tombol X agar judul benar-benar di
                  // tengah layar.
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _riwayat.length,
                itemBuilder: (context, index) => _buildBox(_riwayat[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBox(_RiwayatHari hari) {
    final title =
        '${_dayNames[hari.tanggal.weekday - 1]} — ${hari.tanggal.day} '
        '${_fullMonthNames[hari.tanggal.month - 1]} ${hari.tanggal.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87, width: 1.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                for (final entry in hari.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E5E5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: MockItemImage(
                            assetPath: entry.imagePath,
                            fallbackIconSize: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            entry.nama,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RiwayatEntry {
  final String nama;
  final String imagePath;
  const _RiwayatEntry(this.nama, this.imagePath);
}

class _RiwayatHari {
  final DateTime tanggal;
  final List<_RiwayatEntry> entries;
  const _RiwayatHari(this.tanggal, this.entries);
}
