# Audit awal dataset lokal

Tanggal pemeriksaan: 20 Oktober 2026.

## Ringkasan

| Dataset | Baris transaksi | Kolom | Ukuran perkiraan |
|---|---:|---:|---:|
| Clean | 9.972.038 | 11 | 765,96 MB |
| Contaminated | 9.945.511 | 11 | 763,98 MB |

Rentang transaksi pada versi contaminated adalah 2022-01-01 sampai 2025-12-31.

## Pemeriksaan transaksi contaminated

- Tidak ada nilai kosong pada kolom wajib.
- Nilai kosong pada `promo_id` diperbolehkan untuk transaksi tanpa promosi.
- Tidak ditemukan kuantitas nol/negatif.
- Tidak ditemukan harga negatif.
- Tidak ditemukan diskon di luar rentang 0-100 persen.
- Tidak ditemukan ketidaksesuaian formula `total_value` dengan toleransi 0,02.
- Tidak ditemukan foreign key yatim untuk toko, SKU, pelanggan, atau promosi.

## Perbedaan dengan README sumber

Dokumentasi sumber menyebutkan 10 juta transaksi pada versi clean dan file flag hanya berada pada versi anomaly. Berkas lokal memiliki 9.972.038 transaksi clean dan `sku_inventory_flags.csv` pada kedua folder. Kedua file flag masing-masing berisi 600 SKU: 200 `STOCKOUT_RISK` dan 400 `SLOW_MOVER`.

Perbedaan ini harus dicatat sebagai keterbatasan versi data. Analisis utama menggunakan `retail_contaminated_dataset`, sedangkan versi clean hanya digunakan sebagai pembanding bila diperlukan.

## Interpretasi contamination

Contamination pada dataset ini berupa anomali bisnis yang disuntikkan: kehilangan transaksi selama jendela stockout dan persediaan berlebih untuk slow mover. Data transaksi tetap memenuhi aturan tipe, formula, dan referential integrity. Karena itu, quality checks teknis dan deteksi anomali bisnis harus dilaporkan sebagai dua kelompok pemeriksaan yang berbeda.

