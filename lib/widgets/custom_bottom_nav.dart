import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onFabPressed;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onFabPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.transparent,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB), // warna abu abu
                borderRadius: BorderRadius.circular(35),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home_outlined, Icons.home, 'Home', 0),
                  _navItem(Icons.checkroom_outlined, Icons.checkroom, 'Wardrobe', 1),
                  const SizedBox(width: 48),
                  _navItem(Icons.style_outlined, Icons.style, 'Styling', 2),
                  _navItem(Icons.calendar_today_outlined, Icons.calendar_today, 'Planner', 3),
                ],
              ),
            ),
            Positioned(
              child: FloatingActionButton(
                onPressed: onFabPressed,
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData iconOutlined, IconData iconFilled, String label, int index) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? iconFilled : iconOutlined,
              color: isSelected ? Colors.black : Colors.grey[700],
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
