import 'package:flutter/material.dart';

import '../widgets/mock_item_image.dart';

/// Halaman beranda — greeting + koleksi 2x2 + card outfit hari ini (mock).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '67fit',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                'Selamat datang',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Imajinasikan outfitmu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Koleksi Saya',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              _barisKoleksi(MockPakaian.kaos, MockPakaian.jeans),
              const SizedBox(height: 12),
              _barisKoleksi(MockPakaian.jaket, MockPakaian.sepatu),
              const SizedBox(height: 28),
              const Text(
                'Outfit hari ini',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              _kartuOutfitHariIni(),
            ],
          ),
        ),
      ),
    );
  }

  // Baris koleksi: 2 kartu berdampingan (grid 2x2 dibentuk 2 baris ini).
  Widget _barisKoleksi(String kiri, String kanan) {
    return Row(
      children: [
        Expanded(child: _kartuKoleksi(kiri)),
        const SizedBox(width: 12),
        Expanded(child: _kartuKoleksi(kanan)),
      ],
    );
  }

  Widget _kartuKoleksi(String asset) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: MockItemImage(assetPath: asset, fallbackIconSize: 36),
    );
  }

  // Mock: pajangan murni, tidak berasal dari data planner & tidak bisa ditap.
  Widget _kartuOutfitHariIni() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C2C46), Color(0xFF31456D)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gambar lebih besar di atas lingkaran lembut — kesan vitrin/display
          Container(
            width: 120,
            height: 120,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const MockItemImage(
              assetPath: MockPakaian.outfitSantai,
              fallbackIconSize: 44,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Outfit Santai',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Kaos hitam + jeans biru',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
