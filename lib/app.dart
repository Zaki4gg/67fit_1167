import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'main.dart' as app;
import 'screens/add_clothing_screen.dart';
import 'screens/home_screen.dart';
import 'screens/planner_screen.dart';
import 'screens/styling_screen.dart';
import 'screens/wardrobe_screen.dart';
import 'widgets/custom_bottom_nav.dart';

/// Navigasi utama: 4 tab bawah (setState, bukan Navigator) + menu FAB
/// yang buka sheet Upload/Styling/Wishlist.
/// [initialIndex] dipakai saat halaman ini dibuka lewat rute (`/styling`, `/planner`).
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex = widget.initialIndex;

  final List<Widget> _pages = [
    const HomeScreen(),
    const WardrobeScreen(),
    const StylingScreen(),
    const PlannerScreen(),
  ];

  void _showFabMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFloatingMenuButton('Upload', () {
                Navigator.pop(context);
                _showUploadOptions(context);
              }),
              const SizedBox(height: 12),
              _buildFloatingMenuButton('Styling', () {
                Navigator.pop(context);
                _showStylingOptions(context);
              }),
              const SizedBox(height: 12),
              _buildFloatingMenuButton('Wishlist', () {
                Navigator.pop(context);
                Navigator.pushNamed(context, app.AppRoute.addWishlist);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingMenuButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 220,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE5E7EB),
          foregroundColor: Colors.black87,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.5),
        ),
      ),
    );
  }

  // Versi mockup: tidak memanggil kamera sungguhan, langsung buka
  // halaman Review Clothes dengan gambar placeholder.
  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Tambahkan Pakaian',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ListTile(
                  leading:
                      const Icon(Icons.camera_alt_outlined, color: Colors.black87),
                  title: const Text('Ambil Foto Langsung',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () => _bukaReviewClothes(sheetContext, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined,
                      color: Colors.black87),
                  title: const Text('Pilih dari Galeri',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () => _bukaReviewClothes(sheetContext, ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Kamera/galeri sungguhan via ImagePicker; hasil foto dikirim ke
  // Review Clothes sebagai argumen rute (path file di HP).
  Future<void> _bukaReviewClothes(
      BuildContext sheetContext, ImageSource sumber) async {
    Navigator.pop(sheetContext);
    final foto = await ImagePicker().pickImage(source: sumber, imageQuality: 72);
    if (foto == null) return; // user batal ambil foto
    if (!mounted) return;
    Navigator.pushNamed(context, app.AppRoute.addClothing,
        arguments: foto.path);
  }

  void _showStylingOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Mulai Styling',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'serif')),
          content: const Text('Bagaimana Anda ingin menyusun outfit Anda?'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() => _currentIndex = 1);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pilih pakaian dari lemari Anda...')));
              },
              child: const Text('Pilih dari Wardrobe',
                  style: TextStyle(color: Colors.black87)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C2C46),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() => _currentIndex = 2);
              },
              child: const Text('Langsung ke Canvas'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        onFabPressed: () => _showFabMenu(context),
      ),
    );
  }
}
