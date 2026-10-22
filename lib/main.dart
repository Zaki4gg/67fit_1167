import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'models/clothing_model.dart';
import 'models/history_wishlist_model.dart';
import 'models/outfit_model.dart';
import 'screens/add_clothing_screen.dart';
import 'screens/add_wishlist_screen.dart';
import 'screens/archive_screen.dart';
import 'screens/clothing_detail_screen.dart';
import 'screens/outfit_detail_screen.dart';
import 'screens/usage_history_screen.dart';
import 'screens/wishlist_detail_screen.dart';

/// Nama rute aplikasi — satu tempat, dipakai semua halaman.
class AppRoute {
  static const String home = '/';
  static const String clothingDetail = '/clothing-detail';
  static const String outfitDetail = '/outfit-detail';
  static const String wishlistDetail = '/wishlist-detail';
  static const String addClothing = '/add-clothing';
  static const String addWishlist = '/add-wishlist';
  static const String styling = '/styling';
  static const String planner = '/planner';
  static const String usageHistory = '/usage-history';
  static const String archive = '/archive';

  /// Pasangan nama → halaman. Argumen item/outfit/wishlist dilempar balik
  /// di sini (satu tempat cast) lalu diberikan ke konstruktor halaman.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case clothingDetail:
        return MaterialPageRoute(
          builder:
              (_) => ClothingDetailScreen(item: settings.arguments! as Item),
        );
      case outfitDetail:
        return MaterialPageRoute(
          builder:
              (_) => OutfitDetailScreen(outfit: settings.arguments! as Outfit),
        );
      case wishlistDetail:
        return MaterialPageRoute(
          builder: (_) =>
              WishlistDetailScreen(existing: settings.arguments! as Wishlist),
        );
      case addClothing:
        // arguments = path file foto dari kamera/galeri (null = mock placeholder).
        return MaterialPageRoute(
          builder: (_) => AddClothingScreen(
            imagePath: settings.arguments as String?,
          ),
        );
      case addWishlist:
        return MaterialPageRoute(builder: (_) => const AddWishlistScreen());
      case styling:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(initialIndex: 2),
        );
      case planner:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(initialIndex: 3),
        );
      case usageHistory:
        return MaterialPageRoute(builder: (_) => const UsageHistoryScreen());
      case archive:
        return MaterialPageRoute(builder: (_) => const ArchiveScreen());
      default: // '/' + fallback
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
    }
  }
}

void main() {
  // Binding wajib dulu: SystemChrome butuh services binding aktif.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ).then((_) => runApp(const Fit67App()));
}

class Fit67App extends StatelessWidget {
  const Fit67App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '67FIT',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        useMaterial3: true,
      ),
      initialRoute: AppRoute.home,
      onGenerateRoute: AppRoute.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
