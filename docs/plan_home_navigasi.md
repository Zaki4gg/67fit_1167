# Plan — Kartu Home Jadi Bisa Dinavigasi

> Kasus dosen: kartu koleksi di home → buka detail clothing/outfit; kartu
> "outfit hari ini" → buka planner. Dokumen ini **plan**, bukan kode final.

## Kondisi sekarang

`home_screen.dart`:
- `_kartuKoleksi(String asset)` — gambar saja, **tidak bisa ditap**.
- `_kartuOutfitHariIni()` — kartu statis ("Outfit Santai"), **tidak bisa ditap**.

Home hanya tahu **path gambar** (`MockPakaian.kaos`, dst.) — tidak punya objek
`Item`. Halaman detail butuh **objek item terpilih** (lihat dok routing:
`pushNamed(AppRoute.clothingDetail, arguments: item)`).

## Inti masalah: butuh objek, home punya gambar

Rute `/clothing-detail` menuntut `arguments: Item`. Dua pilihan
(sudah dibahas di chat — pilih 1):

| Opsi | Cara | Keputusan |
|---|---|---|
| A. Cari objek dari gambar | `MockData.items.firstWhere((i) => i.imagePath == asset)` | ✅ ambil ini — data sudah pasti cocok karena keduanya dari `MockPakaian` |
| B. Kirim id saja, detail cari sendiri | mengubah rute + konstruktor halaman | ❌ rework 3 halaman + routes — tidak layak |

## Langkah pengerjaan (satu file: `home_screen.dart`)

### 1. Kartu koleksi bisa ditap → detail item

- `_kartuKoleksi` bungkus `GestureDetector`:
  ```dart
  onTap: () {
    final item = MockData.items.firstWhere(
      (i) => i.imagePath == asset,
      orElse: () => ...; // lihat catatan aman di bawah
    );
    Navigator.pushNamed(context, app.AppRoute.clothingDetail, arguments: item);
  }
  ```
- import baru: `import '../models/mock_data.dart';` dan `import '../main.dart' as app;`
- Estimasi perubahan: **±8 baris**.

### 2. Kartu outfit hari ini bisa ditap → planner

- Bungkus `GestureDetector`:
  ```dart
  onTap: () => Navigator.pushNamed(context, app.AppRoute.planner),
  ```
- Rute planner sudah benar bentuknya: `MainNavigationScreen(initialIndex: 3)`
  (perbaikan navbar kemarin) — jadi langsung ada kerangka + navbar. **0 langkah lain.**
- Estimasi: **±3 baris**.

### 3. Uji

1. Tap kartu kaos → detail kaos terbuka (judul = Kaos Hitam, sesuai MockData).
2. Back → home, posisi scroll tidak lompat.
3. Tap kartu outfit hari ini → planner terbuka **dengan navbar**, tab planner aktif.
4. `flutter analyze` → 0 issues.

## Catatan aman (edge case)

- `firstWhere` **melempar pengecualian bila tidak ketemu**. Bukti aman: 4 gambar
  koleksi (`kaos/jeans/jaket/sepatu`) memang ada warnanya `MockData.items`
  (gambar sama dari `MockPakaian`). Tetap tulis `orElse` defensive — mis. jalias
  `dummy item` pertama — supaya menanganti gambar di `MockPakaian` nanti tidak
  meruntuhkan home. Alternatif: `where(...).isEmpty ? null : item` lalu hanya
  `onTap` kalau tidak null.
- Kartu **outfit hari ini** sengaja jalan ke *halaman* planner, bukan data plan —
  karena versi sekarang kartunya mock statis (penyambungan PlannerStore sudah
  dikembalikan/downgrade per permintaanmu). Kalau kelak dikembalikan penyambungan
  tadi, kartu ini pun sudah siap — `onTap`-nya tinggal dipasang di versi store.
- Tidak perlu file baru, tidak mengubah routes.dart/main.dart dan tidak
  mengubah widget/apapun di halaman lain — **satu file**.

## Estimasi total

±11 baris di `home_screen.dart` + 2 import. Waktu: <15 menit.
