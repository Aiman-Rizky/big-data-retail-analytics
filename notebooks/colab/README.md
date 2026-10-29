# Menjalankan proyek di Google Colab langsung dari Kaggle

Versi Colab mengunduh dataset langsung dari Kaggle ke penyimpanan sementara runtime. Dataset tidak perlu diunggah ke Google Drive.

## Persiapan satu kali

1. Masuk ke akun Kaggle dan buka `https://www.kaggle.com/settings/api`.
2. Pada bagian API, buat token baru.
3. Di Google Colab, buka panel **Secrets** dengan ikon kunci.
4. Tambahkan secret bernama `KAGGLE_API_TOKEN`, masukkan token Kaggle sebagai nilainya, lalu aktifkan akses untuk notebook.
5. Publish repository proyek ke GitHub.
6. Pada sel setup setiap notebook, ganti:

```python
REPOSITORY_URL = "https://github.com/USERNAME/big-data-retail-analytics.git"
```

dengan URL repository milikmu.

Jangan menulis token langsung di dalam notebook dan jangan memasukkannya ke GitHub.

## Cara kerja download

Notebook menggunakan:

```python
kagglehub.dataset_download(
    "mrayyanshehzad/synthetic-retail-dataset-10-million-transactions"
)
```

KaggleHub mengunduh dataset ke cache sementara Colab, bukan ke Google Drive. PySpark kemudian membaca CSV dari folder hasil download tersebut.

## Urutan menjalankan

1. `01_exploration.ipynb`
2. `02_pyspark_transform.ipynb`
3. `03_etl_validation.ipynb`

Notebook 02 menghasilkan Parquet dan tabel agregat di `/content/big-data-retail-analytics/output`. Notebook 03 akan memakai hasil tersebut jika masih tersedia. Jika runtime baru tidak mempunyai hasil Notebook 02, Notebook 03 akan menjalankan pipeline ETL secara otomatis.

## Konsekuensi tidak memakai Google Drive

- Dataset dan output hanya tersedia selama runtime Colab masih aktif.
- Setelah runtime di-reset atau terputus, dataset harus diunduh kembali.
- Grafik atau hasil yang ingin disimpan permanen harus diunduh ke komputer sebelum runtime berakhir.
- Dataset tetap diunduh ke VM Colab terlebih dahulu; proses ini bukan streaming langsung dari halaman Kaggle ke PySpark.
