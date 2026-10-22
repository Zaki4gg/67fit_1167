# Struktur `lib/` — 67FIT (Flutter, versi mockup)

Semua data dummy, tanpa database/Provider/image_picker. Aksi simpan/hapus hanya SnackBar/dialog lokal.

## Entry point & routing

| File | Isi |
|---|---|
| `main.dart` | `main()` = lock portrait → `runApp`. `AppRoute` = daftar nama rute (`/clothing-detail`, dst.). `AppRoute.onGenerateRoute` = penerjemah nama → halaman; argumen (`Item`/`Outfit`/`Wishlist`) di-cast di sini satu tempat. `Fit67App` = MaterialApp (`initialRoute: '/'`, `onGenerateRoute`). |
| `app.dart` | `MainNavigationScreen` — halaman kerangka (rute `/`): 4 tab bawah (Home, Wardrobe, Styling, Planner) diganti pakai `setState` **bukan** Navigator; FAB tengah → menu sheet Upload / Styling / Wishlist; Upload → sheet Kamera/Galeri (mock, langsung AddClothing); Styling → dialog "Mulai Styling" (pindah tab wardrobe/canvas). |

## `screens/` — halaman

| File | Class | Fungsi & widget penting |
|---|---|---|
| `home_screen.dart` | `HomeScreen` (stateless) | Beranda: logo 67FIT, greeting, strip collection berupa `Image.asset` (acuan MockPakaian / MockItemImage). |
| `wardrobe_screen.dart` | `WardrobeScreen` | Lemari: 3 tab (Items/Outfits/Wishlist), search kapsul, tombol favorit & arsip (tab Items saja — tombol arsip `pushNamed` ke ArchiveScreen), grid 2 kolom via `_buildGrid` generik + 3 kartu builder (`_buildItemCard`, `_buildOutfitCard`, `_buildWishlistCard`), long-press → `_showItemOptions` (hapus/favorit). Filter: yang terarsip tidak tampil. |
| `archive_screen.dart` | `ArchiveScreen` | Halaman koleksi arsip: tab Items/Outfits, tap kartu → `_showRestoreDialog` (AlertDialog "Kembalikan ke koleksi?" → Batal/Kembalikan) → SnackBar `_munculkanKembali`. |
| `clothing_detail_screen.dart` | `ClothingDetailScreen` | Detail pakaian: gambar, form nama/color/category/size/condition; color pakai `ColorPickerSheet`, size `SizePickerSheet`, kategori `CategoryPickerSheet`; baris aksi inline (hapus → `showConfirmDelete`, style → `pushNamed(AppRoute.styling)`). |
| `outfit_detail_screen.dart` | `OutfitDetailScreen` | Detail outfit: daftar item penyusun, edit style/season via `_MultiSelectSheet` (class private, dilebur di file ini — hanya dipakai di sini); tombol "Plan" → `pushNamed(AppRoute.planner)`. |
| `wishlist_detail_screen.dart` | `WishlistDetailScreen` | Detail wishlist (terima `Wishlist` via rute), form nama/kategori/harga; harga pakai `PriceSheet`; Delete & Save = mock. |
| `add_clothing_screen.dart` | `AddClothingScreen` | "Review Clothes" — tiruan update gambar: pratinjau placeholder asset, form nama/color/category/size/condition (memakai 3 sheet picker bersama), Save = delay animasi + SnackBar. |
| `add_wishlist_screen.dart` | `AddWishlistScreen` | Form tambah wishlist: gambar dummy statis (`_setDummyImage` — belakangan diganti kamera/galeri), field nama/color/category/harga, Delete & Save. |
| `styling_screen.dart` | `CanvasItem`, `StylingScreen` | Canvas styling sederhana: pilih item lewat bottom sheet → tampil di canvas (tanpa drag/rotate/undo); tap kartu canvas = hapus; tombol refresh/reset. |
| `planner_screen.dart` | `PlannerScreen` | Bingkai Planner: header judul bulan, izin scroll bulan included via `PageController` (titik tengah 12000), plan hidup di `Map<int, List<PickOption>> _plans` (key = epochDays); tap tanggal → tombol Plan / sheet detail hari; hapus entri dengan `showConfirmDelete`; tombol Riwayat → `pushNamed(AppRoute.usageHistory)`. |
| `usage_history_screen.dart` | `_RiwayatEntry`, `_RiwayatHari`, `UsageHistoryScreen` (stateless) | Riwayat pemakaian: daftar kotak per tanggal berisi thumbnail item/outfit + nama; data statis (tanggal spesifik). |
| `main` route lain | — | 3 detail + add-clothing/add-wishlist/usage/archive tak pernah dijadikan tab — hanya lewat rute. |

## Widget helper di dalam tiap file `screens/` — penjelasan rinci

Method/builder privat (diawali `_`) — hanya bisa dipakai di file halamannya sendiri, karena bentuknya dikhususkan untuk layout halaman itu. Widget yang dipakai >1 halaman sudah dipind ke `widgets/`.

### `wardrobe_screen.dart` — state : `_selectedTabIndex` (0/1/2), `_searchQuery`, `_showFavoriteOnly`

Tata letak `build`: header navy (baris atas: tab + tombol aksi; baris bawah: search kapsul) → kisi kartu.

| Helper | Rinci |
|---|---|
| `_buildTabCapsule(label, count, active, onTap)` | Kartu putih kecil di header; 3 salinan untuk 3 tab. `count` dihitung dari list terfilter (tanpa terarsip) supaya angka = isian grid. `active` menentukan warna teks/latar. |
| `_buildSquareActionButton({icon, onTap})` | Kotak putih 48px dengan ikon: favorit (toggle filter) & arsip (`pushNamed` ✨ ArchiveScreen). Hanya muncul di tab Items — wishlist tak punya flag itu. |
| `_buildGrid({itemCount, childAspectRatio, buildCard})` | `GridView.builder` 2 kolom yang generik: dicegah diulang (scroll, padding, spacing) sekali; hanya kartunya beda via callback `buildCard(context, i)`. |
| `_buildItemCard(Item)` | Kartu putih polos; gambar di tengah. Tap → `pushNamed(clothingDetail, arguments: item)`; long-press → opsi. |
| `_buildOutfitCard(Outfit)` | Gambar memenuhi kartu. Tap → detail outfit. |
| `_buildWishlistCard(Wishlist)` | Gambar (placeholder icon bila kosong) + baris nama & harga di bawah. Tap → detail wishlist. |
| `_showItemOptions(Item)` | Sheet long-press: Hapus (`showConfirmDelete` → hapus state lokal) / Favorit. |
| `_buildEmptyState()` | Ikon + teks "tidak ada koleksi" bila hasil filter kosong. |

### `home_screen.dart` — stateless, tanpa state

Satu `build`: header logo "67FIT" → greeting + subjudul → strip koleksi horizontal berisi `MockItemImage` dari `MockPakaian.semua`. Tidak ada interaksi antar halaman.

### `archive_screen.dart` — state : `_selectedTabIndex` (0 Items / 1 Outfits; wishlist tak punya arsip)

| Helper | Rinci |
|---|---|
| `_buildTabChip(label, active)` | Chip di header; tap mengganti tab (satu di atas–bawah memisahkan arsip item & outfit). |
| `_showRestoreDialog(entry)` | `await showDialog<AlertDialog>` Indonesia: "Kembalikan ke koleksi?" + Batal / **Kembalikan** (biru). Balik `true`/`false` dari pop — ini aksi restore, bukan tap polos. |
| `_munculkanKembali(entry)` | SnackBar "kembali ke koleksi" — versi mock: data tetap di MockData, cuma feedback. |

### `clothing_detail_screen.dart` — terima `Item` via rute; state : controller nama + salinan field (warna/kategori/size/kondisi)

`initState` copy field dari `item` agar edit tak langsung mengubah data; `dispose` membuang controller.

| Helper | Rinci |
|---|---|
| `_buildPreview()` | Kotak gambar atas (`MockItemImage`) + overlay tombol X kembali. |
| `_buildForm()` | Panel kartu bawah: TextField nama → 4 `_buildTagSection` → baris aksi Delete/Save. |
| `_buildTagSection({title, values, onAdd, onDelete, leadingDot...})` | Baris judul section + count + tombol `+`; di bawahnya baris chip `_buildTagChip`. Tampang beda per section (size 1 pilih, color beri dot). |
| `_buildTagChip({label, colorDot?, onDelete})` | Chip satu pilihan terpilih; X → `onDelete` (hapus 1 nilai). |
| `_buildFieldRow({label, value, onTap})` | Baris "label — tombol/nilai" untuk Size/Condition. |
| `_pickColors()` / `_pickCategory()` / `_pickSize()` | `await showModalBottomSheet` → `ColorPickerSheet` / `CategoryPickerSheet` / `SizePickerSheet`; pop membawa hasil → `setState` simpan. Jika batal (null) tak melakukan apa-apa. |
| `_showInputDialog({required title, required currentValue, required onSave})` | Dialog TextField umum untuk input teks (nama). |
| `_saveChanges()` / `_deleteItem()` | Mock: SnackBar "perubahan disimpan" / `showConfirmDelete` → SnackBar. Tidak menulis data mana pun. |

### `outfit_detail_screen.dart` — terima `Outfit` via rute; state mirip clothing + `_selectedStyle/_selectedSeason`

| Helper | Rinci |
|---|---|
| `_buildPreview()` | Gambar kumpulan outfit + tombol kembali & hapus. |
| `_buildForm()` | Nama, jumlah item, section Style & Season, tombol **Plan** (`pushNamed(AppRoute.planner)`). |
| `_buildTagSection(...)` | Pola sama dengan clothing detail tapi untuk style/season (bisa multi). |
| `_pickOptions({title, options, isGrid, selected})` | Satu pintu buka `_MultiSelectSheet` untuk style & season — beda hanya `isGrid` (style = list cek, season = grid pill). Pop membawa `List<String>`. |
| `_applyStyle(result)` / `_applySeason(result)` | Salin hasil sheet → state → tampil chip. |
| `_MultiSelectSheet` (class privat, + `_buildList`/`_buildGrid`/`_toggle`) | Sheet generik 2 tampilan; dilebur 1 file karena hanya dipakai detail outfit. Confirm mengembalikan pilihan. |
| `_save()` / `_delete()` | Mock / `showConfirmDelete`. |

### `wishlist_detail_screen.dart` — terima `Wishlist` via rute; state : nama/kategori/warna/harga

| Helper | Rinci |
|---|---|
| `_buildFieldRow({label, value, onTap})` | Baris kategori/harga: label kiri, tombol "Add" (kosong) atau nilai (terisi). |
| Harga | `await showModalBottomSheet` → `PriceSheet`; pop balik angka teks → setState (format "Rp 199.000" di tampilan). |
| Kategori/Warna | `CategoryPickerSheet` / `ColorPickerSheet` seperti detail clothing. |
| `_saveChanges()` / `_deleteWishlist()` | Mock / `showConfirmDelete` + SnackBar. |

### `add_clothing_screen.dart` — Review Clothes; state : nama, warna CSV, kategori, size, kondisi

| Helper | Rinci |
|---|---|
| `_buildSectionHeader(String title, {required onAdd})` | Judul bagian form + tombol `+` di kanan (semua section memakai kontainer sama). |
| `_buildTagChip({required label, hasColorCircle, colorDot, required onDeleted})` | Chip terpilih; `colorDot` khusus warna (lingkaran kecil). X → hapus 1 pilihan. |
| `_buildFieldRow({required label, required value, required onAdd})` | Baris "Nama — Add/nilai" (polo sama juga oleh detail). |
| `_showInputDialog({required title, required currentValue, required onSave})` | Dialog teks (buat nama manual tanpa kamera). |
| `_saveClothing()` | Mock: delay singkat (loading) → SnackBar → `pop`. |
| Pratinjau | Keras asset `MockPakaian.kaos` — tanda kamera/galeri belum nyata. |

### `add_wishlist_screen.dart` — state : `_imagePath`, nama/kategori/warna/harga

| Helper | Rinci |
|---|---|
| `_buildAddImagePill()` | Pill "Add Image?" — versi mock langsung isi gambar; titik upgrade `image_picker`. |
| `_setDummyImage()` | `setState(_imagePath = MockPakaian.kaos)` — 1 foto drama, tanpa picker. |
| `_buildFieldRow({label, value, onTap})` | Baris Nama/Warna/Kategori/Harga; harga juka juga `PriceSheet`. |
| `_saveWishlist()` | Mock: SnackBar + tutup halaman. |

### `styling_screen.dart` — canvas; state : `List<CanvasItem> _canvas`

| Helper | Rinci |
|---|---|
| `_showDummyPicker()` | Sheet pilih item contoh (`MockPakaian.semua`): kartu putih bergaris; tap → tambah `CanvasItem` ke canvas & tutup sheet. |
| `_buildSmallCircleButton({icon, onTap})` | Tombol lingkar kecil melayang di atas canvas (refresh/reset; versi lama pernah ada undo — sudah dihapus). |
| `_confirmRemove(index)` | `showConfirmDelete` dulu, baru hapus kartu tersebut dari canvas. |
| `_clearCanvas()` | Reset list jadi kosong. |
| `_saveOutfit()` | Mock: SnackBar "outfit tersimpan". |
| Kartu canvas | Transparan, `fit: contain` — tampil mengikuti bentuk gambar, tanpa nama item; tap = `_confirmRemove`. |

### `planner_screen.dart` — state : `_selectedDate`, `Map<int, List<PickOption>> _plans`, `PageController` (initialPage 12000)

| Helper | Rinci |
|---|---|
| `_tapDate(DateTime)` | Simpan `_selectedDate` → kalender lewat callback memindah highlight & tampil tombol Plan/plan di baris minggu itu. |
| `_startPlan(DateTime)` | Tombol Plan (tanggal belum berisi plan) → langsung pindah `_openPicker(date)`. |
| `_openPicker(date, existing)` | `await showModalBottomSheet` → `PlanPickerSheet(pilihan dari MockData.items & outfits)`; hasil Confirm (`List<PickOption>`) → `_plans[epochOf(date)]`. Batal = tak ada perubahan. |
| `_openDayDetail(date)` | Sheet detail hari: daftar plan (thumbnail + nama), X merah = hapus 1 entri via `showConfirmDelete`, FAB hijau `+` = tambah lebih banyak (buka picker lagi). |
| build | Judul bulan mengikuti offset `PageController` — halaman & kalender sinkron; tombol Riwayat → `pushNamed(AppRoute.usageHistory)`. |

### `usage_history_screen.dart` — stateless; data statis `_RiwayatHari`

| Helper | Rinci |
|---|---|
| `_buildBox(_RiwayatHari hari)` | Kotak 1 tanggal: header tanggal/bulan + kolom baris entri (thumbnail `MockItemImage` + nama item/outfit + label). |
| `_RiwayatEntry` / `_RiwayatHari` | Class data privat: satu entri (nama, gambar, isOutfit) & kumpulan entri untuk 1 hari. Semua hardcode supaya tampilan konsisten. |

## `widgets/` — komponen bersama (dipakai >1 halaman)

| File | Class | Fungsi |
|---|---|---|
| `confirm_dialog.dart` | `showConfirmDelete` | Dialog konfirmasi aksi destruktif; balik `true` kalau tombol merah ditekan. Dipakai: detail pakaian, detail outfit, detail wishlist, planner. |
| `custom_bottom_nav.dart` | `CustomBottomNavBar` | Bar navigasi bawah: 4 ikon tab + tombol `+` di tengah (FAB) → callback `onTap` & `onFabPressed` di `app.dart`. |
| `mock_item_image.dart` | `MockPakaian`, `MockItemImage` | Path asset gambar pakaian mock (`assets/pakaian`) + widget gambar yang app-icon placeholder bila asset gagal dimuat. Dipakai Home, Wardrobe, Add, Detail, Outfit, Styling. |
| `color_picker_sheet.dart` | `ColorPickerSheet` | Sheet pilih warna (multi-select), balikan CSV string / null. |
| `size_picker_sheet.dart` | `SizePickerSheet` | Sheet pilih size (single-select, boleh kosong); tap ulang = batal; Confirm aktif hanya bila berubah. |
| `category_picker_sheet.dart` | `CategorySelection`, `CategoryPickerSheet`, `_AddSubcategoryDialog` | Sheet pilih kategori (parent → sub); seed dr `StaticOptions`; tambah/hapus sub hanya di state (mock); dialog "New {Parent}" dilebur di file ini. |
| `price_sheet.dart` | `PriceSheet` | Sheet "Price" (textField bulat + Save) — balik isi TextField via `Navigator.pop`. Dipakai add wishlist & wishlist detail untuk kolom Harga. |
| `planner_calendar.dart` | `PlannerCalendar` | Kalender Planner (stateless): baris nama hari, `PageView` bulan vertikal, sel tanggal → lingkaran biru, baris tombol Plan/gambar plan di bawah minggu tanggal terpilih. State di halaman pemilik; hanya callback. |
| `plan_pilihan.dart` | `PlanPickerSheet` | Sheet pilih isi plan: tab Items/Outfits, grid pilihan, band kuning "Dipilih", `Confirm(n)` balik daftar pilihan lintas tab. |
| `plan_types.dart` | `PickOption`, `epochOf()` | Tipe & helper bersama Planner (1 pilihan item/outfit + key epochDays). Dipakai planner, kalender, picker. |

## `models/` — data

| File | Class | Fungsi |
|---|---|---|
| `clothing_model.dart` | `Item` | Model pakaian (id, nama, kategori, warna, ukuran, kondisi, favorit, terarsip, imagePath). Tanpa toMap/fromMap (belum ada DB). |
| `outfit_model.dart` | `Outfit` | Model outfit (id, nama, daftar item, style, season, favorit, terarsip). |
| `history_wishlist_model.dart` | `RiwayatPemakaian`, `Wishlist` | Model riwayat pemakaian & wishlist (bentuk mengikuti androidstudio_fit67). |
| `mock_data.dart` | `MockData` | Satu sumber data dummy semua halaman: `MockData.items`, `MockData.outfits`, `MockData.wishlist` — nama/gambar konsisten lintas halaman. Outfit "Mall" `isArchived: true` sebagai demo arsip. |
| `static_options.dart` | `StaticOptions` | Opsi statis warna/ukuran/kondisi + kategori (dr seed DatabaseHelper project asli). |

## Alur navigasi ringkas

- **Tab bawah:** `setState(_currentIndex)` di `app.dart` — tanpa rute (state tab tetap hidup; back tidak keluar app).
- **Antar halaman:** `Navigator.pushNamed(context, AppRoute.xxx, arguments: ...)` → `AppRoute.onGenerateRoute` di `main.dart` membuat halaman + cast argumen.
- **Sheet/dialog:** `showModalBottomSheet` / `showDialog` — bukan rute; pop membawa nilai (picker/picker sheet/confirm dialog).
