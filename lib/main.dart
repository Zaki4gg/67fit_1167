import 'package:flutter/material.dart';

import 'models/clothing_model.dart';
import 'screens/home_screen.dart';
import 'screens/planner_screen.dart';
import 'screens/styling_screen.dart';
import 'screens/wardrobe_screen.dart';
import 'widgets/custom_bottom_nav.dart';

void main() {
  runApp(const Fit67App());
}

class Fit67App extends StatelessWidget {
  const Fit67App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '67fit',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// State utama navigasi: bottom nav index-based + data item sementara.
/// Cakupan tunggulah: Widget Flutter + Navigasi. Data hanya di memori.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  List<Item> _items = [];
  int _nextId = 1;

  Widget _buildPage() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return WardrobeScreen(
          items: _items,
          onToggleFavorite: _toggleFavorite,
          onDeleteItem: _deleteItem,
        );
      case 2:
        return const StylingScreen();
      default:
        return const PlannerScreen();
    }
  }

  void _addItem() {
    Navigator.pop(context);
    setState(() {
      _items = [
        ..._items,
        Item(id: _nextId++, nama: 'Item ${_nextId - 1}'),
      ];
      _currentIndex = 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pakaian tersimpan di Wardrobe!')),
    );
  }

  void _toggleFavorite(Item item) {
    setState(() {
      item.isFavorite = !item.isFavorite;
    });
  }

  void _deleteItem(Item item) {
    setState(() {
      _items = _items.where((e) => e.id != item.id).toList();
    });
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
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
                  leading: const Icon(Icons.checkroom, color: Colors.black87),
                  title: const Text('Tambah Item',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: _addItem,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        onFabPressed: _showUploadOptions,
      ),
    );
  }
}
