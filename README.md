# CampusGo

CampusGo adalah aplikasi Flutter untuk membantu mahasiswa menemukan informasi
fasilitas dan agenda kampus tanpa proses login.

## Modul

- **Direktori fasilitas:** perpustakaan, laboratorium, olahraga, area publik,
  dan gedung kampus.
- **Event dan agenda:** seminar, workshop, pameran, dan kegiatan organisasi.
- **Layanan mahasiswa:** helpdesk IT, informasi beasiswa, dan konseling.
- **UMKM dan kantin:** tenant makanan, kedai kopi, dan jam operasional.
- **UKM dan komunitas:** teknologi, musik, olahraga, dan debat.

## Struktur kode

```text
lib/
  main.dart                 # tema aplikasi dan named routes
  models/campus_item.dart   # pemetaan object dari JSON
  config/campus_modules.dart # konfigurasi lima kategori direktori
  pages/                    # halaman beranda dan detail
  services/                 # pembacaan data asset secara asynchronous
  widgets/                  # kartu, tombol, dan header reusable
assets/data/campus_data.json
```

Data dibaca melalui `rootBundle` dan ditampilkan dengan `FutureBuilder`. Ketuk
kartu untuk membuka halaman detail; object `CampusItem` dikirim melalui named
route `/detail`. Beranda menyediakan pencarian dan filter untuk kelima modul.
Tiga widget reusable utama adalah `CampusItemCard`, `GradientActionButton`, dan
`SectionHeader`.
