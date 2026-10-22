import 'package:flutter/material.dart';

import 'mock_item_image.dart';
import 'plan_types.dart';

class PlannerCalendar extends StatelessWidget {
  final PageController pageController;
  final ValueChanged<DateTime> onPageChanged;
  final DateTime today;
  final DateTime? selectedDate;
  final Map<int, List<PickOption>> plans;
  final ValueChanged<DateTime> onTapDate;
  final ValueChanged<DateTime> onStartPlan;
  final ValueChanged<DateTime> onOpenDetail;

  const PlannerCalendar({
    super.key,
    required this.pageController,
    required this.onPageChanged,
    required this.today,
    required this.selectedDate,
    required this.plans,
    required this.onTapDate,
    required this.onStartPlan,
    required this.onOpenDetail,
  });

  static const List<String> _dayShortNames = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  int? get _selectedEpoch =>
      selectedDate == null ? null : epochOf(selectedDate!);

  DateTime _monthOf(int pageIndex) {
    // Offset bulan dihitung dari initialPage controller supaya sinkron
    // dengan judul bulan di halaman.
    final offset = pageIndex - pageController.initialPage;
    return DateTime(today.year, today.month + offset, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(color: Colors.black87, width: 1.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _dayShortNames
                  .map((day) => Text(
                        day,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ))
                  .toList(),
            ),
          ),

          Expanded(
            child: PageView.builder(
              controller: pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) => onPageChanged(_monthOf(index)),
              itemBuilder: (context, index) {
                return _buildMonthList(_monthOf(index));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthList(DateTime monthDate) {
    final gridStart =
        monthDate.subtract(Duration(days: monthDate.weekday - 1));
    // 6 baris agar tinggi konsisten antar bulan.
    final weeks = List.generate(
      6,
      (w) => List.generate(
        7,
        (d) => gridStart.add(Duration(days: w * 7 + d)),
      ),
    );

    final selectedEpoch = _selectedEpoch;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        for (final week in weeks) ...[
          Row(
            children: [
              for (final date in week)
                Expanded(child: _buildDayCell(date, monthDate)),
            ],
          ),
          if (selectedEpoch != null &&
              epochOf(week.first) <= selectedEpoch &&
              selectedEpoch <= epochOf(week.last)) ...[
            const SizedBox(height: 12),
            _buildPlanSection(
              DateTime.fromMillisecondsSinceEpoch(selectedEpoch * 86400000),
            ),
            const SizedBox(height: 12),
          ] else
            const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildDayCell(DateTime date, DateTime monthDate) {
    final isToday = epochOf(date) == epochOf(today);
    final isSelected = selectedDate != null && epochOf(date) == _selectedEpoch;
    final isCurrentMonth = date.month == monthDate.month;
    final isSaturday = date.weekday == DateTime.saturday;
    final hasPlan = plans[epochOf(date)]?.isNotEmpty ?? false;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTapDate(date),
      child: Center(
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            // Lingkaran biru: solid untuk tanggal terpilih; hari ini jadi
            // biru buram bila tanggal lain yang terpilih.
            color: isSelected || isToday
                ? const Color(0xFF0084FF)
                      .withValues(alpha: isSelected ? 1.0 : 0.4)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13.5,
              color: (isToday || isSelected)
                  ? Colors.white
                  : !isCurrentMonth
                      ? Colors.black26
                      : Colors.black87,
              fontWeight: (isToday || isSelected || isSaturday || hasPlan)
                  ? FontWeight.bold
                  : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanSection(DateTime date) {
    final entries = plans[epochOf(date)] ?? const <PickOption>[];

    if (entries.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 4),
          ElevatedButton(
            onPressed: () => onStartPlan(date),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              minimumSize: const Size(140, 40),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black87, width: 1.2),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Plan',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      );
    }

    // Mock: tampilkan gambar plan pertama, tap → sheet detail hari.
    return GestureDetector(
      onTap: () => onOpenDetail(date),
      child: Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: MockItemImage(
            assetPath: entries.first.imagePath,
            fallbackIconSize: 80,
          ),
        ),
      ),
    );
  }
}
