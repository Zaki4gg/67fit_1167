import 'package:flutter/material.dart';

import '../models/mock_data.dart';
import '../widgets/mock_item_image.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/plan_pilihan.dart';
import '../widgets/plan_types.dart';
import '../widgets/planner_calendar.dart';

import '../main.dart' as app;

/// Halaman Planner — bingkai halaman saja; isi kalender ada di
/// [PlannerCalendar] (lib/widgets/planner_calendar.dart) dan sheet
/// pilih isi plan di [PlanPickerSheet] (lib/widgets/plan_pilihan.dart).
/// Interaksi: tap tanggal → tombol Plan / (bila berisi plan) sheet detail
/// hari (kartu + hapus merah + FAB hijau untuk menambah berdasarkan picker).
/// Tidak ada backend — plan hidup di state halaman ini saja (mock).
class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  // Titik tengah index (12000) memungkinkan guliran bulan bebas.
  final int _initialPage = 12000;
  late PageController _pageController;
  late DateTime _today;
  late DateTime _displayedMonth;

  DateTime? _selectedDate;

  // Plan per tanggal: key epochDays → daftar item/outfit yang rencana dipakai.
  final Map<int, List<PickOption>> _plans = {};

  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const List<String> _dayNames = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];
  static const List<String> _fullMonthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  // Opsi picker diambil dari satu sumber data dummy (MockData).
  static final List<PickOption> _itemOptions = [
    for (final item in MockData.items) PickOption(item.nama, item.imagePath),
  ];
  static final List<PickOption> _outfitOptions = [
    for (final outfit in MockData.outfits)
      PickOption(outfit.nama, outfit.imagePath, isOutfit: true),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
    _today = DateTime.now();
    _displayedMonth = DateTime(_today.year, _today.month, 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _tapDate(DateTime date) {
    final epoch = epochOf(date);
    setState(() => _selectedDate = date);
    if ((_plans[epoch]?.isNotEmpty ?? false)) {
      _openDayDetail(date);
    }
  }

  // Tombol Plan (mock): tandai tanggal, langsung buka picker agar user
  // memilih isi plan-nya (Items atau Outfits).
  Future<void> _startPlan(DateTime date) async {
    setState(() => _selectedDate = date);
    await _openPicker(
      date,
      initialSelected: {},
      onConfirm: (result) {
        setState(() => _plans[epochOf(date)] = result);
      },
    );
    if (mounted) setState(() {});
  }

  Future<void> _openDayDetail(DateTime date) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.92,
        child: StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            final epoch = epochOf(date);
            final entries = _plans[epoch] ?? const <PickOption>[];
            final dayTitle = _dayNames[date.weekday - 1];
            final daySubtitle =
                '${date.day.toString().padLeft(2, '0')} '
                '${_fullMonthNames[date.month - 1]} ${date.year}';

            // Hapus satu entry (mock: dialog konfirmasi, data state saja).
            Future<void> removeEntry(int index) async {
              final confirm = await showConfirmDelete(
                sheetContext,
                title: 'Hapus dari Plan',
                content: 'Hapus pakaian/outfit ini dari plan hari ini?',
              );
              if (!confirm) return;
              setSheetState(() => _plans[epoch]!.removeAt(index));
              if (mounted) setState(() {});
            }

            // FAB + → buka picker; hasil Confirm mengganti isi plan.
            Future<void> addMore() async {
              await _openPicker(
                date,
                initialSelected: entries.map((e) => e.nama).toSet(),
                onConfirm: (result) {
                  setSheetState(() => _plans[epoch] = result);
                  if (mounted) setState(() {});
                },
              );
            }

            return Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  SafeArea(
                    child: Column(
                      children: [
                        // Header: X kiri, judul hari tengah
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 28,
                                  color: Colors.black87,
                                ),
                                onPressed: () => Navigator.pop(sheetContext),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      dayTitle,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      daySubtitle,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Spasi kanan 1:1 lebar tombol X agar judul
                              // tepat di tengah layar.
                              const SizedBox(width: 48),
                            ],
                          ),
                        ),
                        const Divider(height: 1),

                        // Daftar plan hari itu
                        Expanded(
                          child: entries.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Belum ada plan',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      color: Colors.black45,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: entries.length,
                                  itemBuilder: (sheetCtx, index) {
                                    final entry = entries[index];
                                    return Stack(
                                      children: [
                                        Container(
                                          height: 260,
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE5E5E5),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                            24, 24, 72, 24),
                                          child: Center(
                                            child: MockItemImage(
                                              assetPath: entry.imagePath,
                                              fallbackIconSize: 70,
                                            ),
                                          ),
                                        ),
                                        // Tombol hapus merah (pojok kanan atas,
                                        // di luar area gambar)
                                        Positioned(
                                          top: 20,
                                          right: 16,
                                          child: Material(
                                            color: const Color(0xFFE57373),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              onTap: () => removeEntry(index),
                                              child: const Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Icon(
                                                  Icons.delete_outline,
                                                  size: 22,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                        ),
                        const SizedBox(height: 72),
                      ],
                    ),
                  ),
                  // FAB hijau + untuk menambah isi plan
                  Positioned(
                    bottom: 24,
                    right: 24,
                    child: FloatingActionButton(
                      heroTag: 'planner_day_detail',
                      backgroundColor: const Color(0xFF7CB342),
                      foregroundColor: Colors.black87,
                      shape: const CircleBorder(),
                      onPressed: addMore,
                      child: const Icon(Icons.add, size: 30),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  // Sheet picker Items/Outfits; balikan list pilihan yang di-Confirm.
  Future<void> _openPicker(
    DateTime date, {
    required Set<String> initialSelected,
    required ValueChanged<List<PickOption>> onConfirm,
  }) async {
    final result = await showModalBottomSheet<List<PickOption>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => PlanPickerSheet(
        dayTitle: _dayNames[date.weekday - 1],
        daySubtitle:
            '${date.day.toString().padLeft(2, '0')} '
            '${_fullMonthNames[date.month - 1]} ${date.year}',
        initialSelected: initialSelected,
        itemOptions: _itemOptions,
        outfitOptions: _outfitOptions,
      ),
    );
    if (result != null && result.isNotEmpty) {
      onConfirm(result);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Judul Header & Bulan Dinamis
              const Text(
                'Planner',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),

              // 2. Kotak Kalender (isi di lib/widgets/planner_calendar.dart)
              Expanded(
                child: PlannerCalendar(
                  pageController: _pageController,
                  onPageChanged: (date) =>
                      setState(() => _displayedMonth = date),
                  today: _today,
                  selectedDate: _selectedDate,
                  plans: _plans,
                  onTapDate: _tapDate,
                  onStartPlan: _startPlan,
                  onOpenDetail: _openDayDetail,
                ),
              ),

              const SizedBox(height: 16),

              // 3. Tombol Riwayat Pemakaian
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    app.AppRoute.usageHistory,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black87, width: 1.2),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Riwayat Pemakaian',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 15,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
