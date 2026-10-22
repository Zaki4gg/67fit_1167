# Penjelasan Routing Aplikasi 67FIT (untuk Tampil ke Dosen)

> Kalau dosen bertanya **"pakai routing apa dan bagaimana?"**, jawab dengan
> urutan bagian 1 ini, lalu **tunjukkan baris yang disebut** di bagian 3.
> Semua nomor baris sudah dicek terhadap kode saat ini.

---

## 1. Jawaban inti (± 30 detik)

> "Program saya memakai **dua lapis navigasi Flutter**:
>
> 1. **4 tab bottom nav** tidak memakai Navigator sama sekali — hanya
>    **setState mengubah angka index**, lalu body Scaffold menampilkan widget
>    halaman sesuai index (`body: _pages[_currentIndex]`).
>
> 2. **Semua layar selain tab** (detail, add, archive, history, dst.) memakai
>    **Navigator dengan named routes**: `Navigator.pushNamed(context,
>    AppRoute.clothingDetail, arguments: item)`. Pemetaan nama rute → halaman
>    dilakukan oleh **`onGenerateRoute`** di `main.dart`, yang membuat
>    `MaterialPageRoute` dan menyambungkan argumen (`settings.arguments`) ke
>    konstruktor halaman — di-cast **di satu tempat**.
>
> Menutup layar pakai `Navigator.pop`; bottom sheet/dialog pop sambil
> **mengembalikan nilai** ke pemanggil yang `await`."

---

## 2. Kenapa dipilih begitu (kalau ditanya "kenapa?")

| Desain | Alasan |
|---|---|
| Tab pakai setState, bukan Navigator | 4 tab berbagi satu Scaffold & satu bottom bar. Cukup ganti widget di body — tidak perlu stack, tidak perlu history per tab. |
| Detail dst. pakai pushNamed | Layar penuh butuh perilaku stack: animasi + tombol back otomatis dari `MaterialPageRoute`, plus butuh **membawa data** (objek Item/Outfit/Wishlist). |
| `onGenerateRoute`, bukan `routes:` map | Map `routes:` (string → Widget) **tidak bisa menerima argumen dinamis**. Rute detail butuh argumen per-klik, jadi dipakai `onGenerateRoute`. |
| Nama rute di class `AppRoute` | **Single source of truth** — string rute ('/clothing-detail', dst.) didefinisikan sekali, tidak ada typo tersebar antar file. |

---

## 3. Tunjuk yang mana (peta file & baris)

### A. `lib/main.dart` — pusat routing (buka ini duluan)

| Baris | Isi | Yang diucapkan sambil menunjuk |
|---|---|---|
| 19–29 | class `AppRoute` — 10 nama rute | "Nama-nama rute, satu tempat." |
| 31–65 | `AppRoute.onGenerateRoute` | "Penerjemah: nama rute → halaman. Di sinilah argumen di-cast: `settings.arguments! as Item` (baris 36–39)." |
| 89 | `initialRoute: AppRoute.home` | "Halaman awal via `initialRoute`, bukan `home:`." |
| 90 | `onGenerateRoute: AppRoute.onGenerateRoute` | "MaterialApp mendelegasikan ke fungsi ini." |

### B. `lib/app.dart` — tab index-switch + push pertama

| Baris | Isi | Yang diucapkan |
|---|---|---|
| 21–28 | `_currentIndex` + `List<Widget> _pages` | "State navigasi tab." |
| 56 | `pushNamed(... AppRoute.addWishlist)` | "FAB → Wishlist: masuk layar penuh lewat named route." |
| 130–131 | pop sheet + `pushNamed(... addClothing)` | "Sheet ditutup dengan pop, lalu push layar baru." |
| 150 / 166 | `setState(() => _currentIndex = 1 / 2)` | "Dialog Styling pindahkan TAB — tanpa Navigator." |
| 179 | `body: _pages[_currentIndex]` | "Inilah 'routing'-nya tab: ganti widget." |
| 184 | `setState(() => _currentIndex = index)` | "Dipanggil dari bottom nav saat tab diklik." |

### C. `lib/screens/wardrobe_screen.dart` — pushNamed dengan argumen

| Baris | Isi |
|---|---|
| 324 | `pushNamed(clothingDetail, arguments: item)` — data pakaian dikirim sebagai arguments |
| 342 | `pushNamed(outfitDetail, arguments: outfit)` |
| 364 | `pushNamed(wishlistDetail, arguments: w)` |
| 186 | pushNamed lainnya, pola sama |

### D. Detail → layar lain (pushNamed juga dari dalam detail)

| Baris | Isi |
|---|---|
| `clothing_detail_screen.dart:260` | `pushNamed(AppRoute.styling)` — tombol 'Style this' |
| `outfit_detail_screen.dart:189` | `pushNamed(AppRoute.planner)` — tombol Schedule |

### E. `Navigator.pop` — dua rasa penutup

| File:baris | Rasa |
|---|---|
| `add_clothing_screen.dart:45`, `wishlist_detail_screen.dart:43` | pop biasa, tutup layar penuh |
| `color_picker_sheet.dart:126`, `price_sheet.dart:80`, `category_picker_sheet.dart:333` | `pop(context, NILAI)` — sheet mengembalikan pilihan ke `await` |
| `confirm_dialog.dart:16/24` | dialog konfirmasi kembalikan `true/false` |

---

## 4. Skrip DEMO (urutan tap saat dosen menonton)

1. **Jalankan `flutter run`.** App terbuka di `/` (Home). Tunjuk `main.dart:89`: "initialRoute '/'".
2. **Klik tab Wardrobe/Styling/Planner** → halaman berganti. Tunjuk `app.dart:179` + 184: "setState, bukan route".
3. **Tap kartu item** → detail muncul (animasi + bisa back system). Sebelum tap, tunjuk dulu `wardrobe_screen.dart:324` (kirim `arguments: item`), lalu `main.dart:36–39` (terima & cast).
4. **FAB (+)** → sheet → **Upload** → pilih sumber → layar Review Clothes (`app.dart:130–131`: pop sheet dulu, baru pushNamed).
5. **FAB → Styling → "Pilih dari Wardrobe"** → **tidak push**; halaman lompat ke tab Wardrobe (`app.dart:150`: dialog pop + setState). Bandingkan langsung dengan langkah 3 — dua gaya berdampingan.
6. **Long-press item → Hapus** → dialog konfirmasi (`confirm_dialog.dart:24`): `pop(ctx, true)` mengembalikan nilai ke `await showDialog<bool>`.
7. **Tekan tombol back sistem** → pop satu lapis, kembali persis ke tempat sebelumnya — demonstrasi konsep **stack**.

---

## 5. Diagram mental (bisa dipapan-tulis)

```
MaterialApp(initialRoute: '/', onGenerateRoute: AppRoute.onGenerateRoute)

              ┌── AppRoute (nama rute) ─────────────────────┐
              │ '/'             MainNavigationScreen         │
              │ /add-clothing   AddClothingScreen             │
              │ /clothing-detail ClothingDetailScreen(item)   │ ← arguments!
              │ /outfit-detail  OutfitDetailScreen(outfit)    │ ← arguments!
              │ /styling /planner /archive /usage-history ... │

MASUK   : Navigator.pushNamed(ctx, '/clothing-detail', arguments: item)
TRANSLATE: onGenerateRoute → MaterialPageRoute(builder: ...)
TUTUP    : Navigator.pop(ctx [, nilai balik])
TAB      : BUKAN Navigator — setState ganti _pages[_currentIndex]
```

---

## 6. Pertanyaan lanjutan yang mungkin keluar (+ jawaban aman)

**Q: Kenapa tidak pakai package go_router?**
> Cakupan materi = Widget Flutter + Navigasi bawaan. Named routes + onGenerateRoute adalah fitur resmi SDK; tidak menambah dependency.

**Q: Kenapa tab tidak pakai route?**
> Tab tidak butuh stack/history — hanya satu Scaffold yang isinya diganti; push akan menumpuk halaman dan membuat back aneh (back harus keluar dari tab satu-satu).

**Q: Kenapa detail tidak pakai `routes:` map?**
> `routes:` map tidak bisa menerima argumen dinamis per item; `onGenerateRoute` bisa.

**Q: Kalau lupa kirim `arguments`, gimana?**
> `settings.arguments! as Item` akan crash. Saat ini hanya 3 rute butuh argumen dan semua pemanggil dari kode sendiri, jadi terkendali. Upgrade mudah: cek `is! Item` lalu fallback ke halaman kosong — cukup disebut sebagai pengembangan, tidak wajib dipraktikkan di mockup.

**Q: Kenapa StylingScreen kadang tab, kadang push?**
> Dua konteks "mulai styling": dari item tertentu = perjalanan baru (push, back ke detail); buka tab kanvas = cukup pindah (setState). Perilaku back-nya memang berbeda karena konteksnya berbeda.

**Q: Back stack = lapis Navigator + tombol OS?**
> Ya. Navigator menangani back otomatis: pop LIFO sampai root; jika sudah di root, app keluar (perilaku default Android).

---

## 7. Kalimat-kalimat quotable (jaga hafalan ini)

- **`main.dart:31`** — "Satu fungsi `onGenerateRoute` menerjemahkan SEMUA rute."
- **`main.dart:38`** — "Argumen di-cast sekali, di satu tempat; halaman tidak perlu tahu dari mana datanya."
- **`wardrobe_screen.dart:324`** — "Data dikirim sebagai satu objek `Item`, bukan argumen terpisah."
- **`app.dart:179`** — "Routing tab = `body: _pages[_currentIndex]`."
- **`confirm_dialog.dart:24`** — "`Navigator.pop(context, true)` mengembalikan nilai ke kode yang `await`."

---

## 8. Satu kalimat penutup

> **"Tab pakai setState mengganti widget; layar lain pakai
> `Navigator.pushNamed`, diterjemahkan `onGenerateRoute` di `main.dart` jadi
> nama-rute → halaman + argumen yang di-cast sekali; tutupnya `Navigator.pop`,
> dan bottom-sheet pop sambil membawa nilai balik."**
