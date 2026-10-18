import 'package:flutter/material.dart';

/// Styling versi sederhana: pilih item contoh lewat bottom sheet,
/// tampil di canvas tanpa drag/rotate/undo. Tap item = hapus dari canvas.
class CanvasItem {
  final IconData icon;
  final Color bg;
  final String label;

  CanvasItem({required this.icon, required this.bg, required this.label});
}

class _DummyOption {
  final IconData icon;
  final Color bg;
  final String label;
  const _DummyOption(this.icon, this.bg, this.label);
}

const _dummyOptions = [
  _DummyOption(Icons.checkroom, Color(0xFFDCE5F5), 'Kemeja contoh'),
  _DummyOption(Icons.luggage, Color(0xFFF5E6DC), 'Celana contoh'),
  _DummyOption(Icons.backpack, Color(0xFFE2E8F0), 'Tas contoh'),
  _DummyOption(Icons.hiking, Color(0xFFD9F5E3), 'Sepatu contoh'),
  _DummyOption(Icons.watch, Color(0xFFF5F5DC), 'Jam contoh'),
  _DummyOption(Icons.face, Color(0xFFEADCF5), 'Topi contoh'),
];

class StylingScreen extends StatefulWidget {
  const StylingScreen({super.key});
  @override
  State<StylingScreen> createState() => _StylingScreenState();
}

class _StylingScreenState extends State<StylingScreen> {
  List<CanvasItem> items = [];

  void _showDummyPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Choose your outfit (contoh)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _dummyOptions.length,
                itemBuilder: (ctx, index) {
                  final opt = _dummyOptions[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => items.add(CanvasItem(
                            icon: opt.icon,
                            bg: opt.bg,
                            label: opt.label,
                          )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: opt.bg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(opt.icon, size: 40, color: Colors.black54),
                          const SizedBox(height: 4),
                          Text(opt.label,
                              style: const TextStyle(fontSize: 11),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearCanvas() {
    setState(() => items.clear());
  }

  // Save versi contoh: hanya pesan, tidak simpan ke mana-mana.
  void _saveOutfit() {
    if (items.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal 2 pakaian (contoh)',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contoh tersimpan! (belum ada backend)',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFA8B50A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E7EB),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('6',
                      style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  Text('Styling',
                      style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5)),
                  Text('7',
                      style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text('Kanvas kosong — tekan Add items',
                          style: TextStyle(color: Colors.black45)),
                    )
                  // Column biasa: item terpilih disusun vertikal, tap = hapus.
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () => _confirmRemove(index),
                          child: Container(
                            width: 140,
                            height: 140,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: item.bg,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(item.icon,
                                    size: 56, color: Colors.black54),
                                const SizedBox(height: 6),
                                Text(item.label,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmallCircleButton(Icons.refresh, _clearCanvas),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _showDummyPicker,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1C2C46),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Add items',
                              style: TextStyle(
                                  fontFamily: 'monospace', fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 48,
                        width: 48,
                        child: ElevatedButton(
                          onPressed: _saveOutfit,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xFFA8B50A),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Icon(Icons.download_outlined),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmRemove(int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: ListTile(
            leading:
                const Icon(Icons.delete_outline, color: Colors.redAccent),
            title: Text('Hapus ${items[index].label}',
                style: const TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              setState(() => items.removeAt(index));
            },
          ),
        );
      },
    );
  }

  Widget _buildSmallCircleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
