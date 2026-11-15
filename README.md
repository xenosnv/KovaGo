# KovaGo — Travel & Staycation Super App

**KovaGo** (*Key of Voyage and Go*) adalah aplikasi mobile pemesanan perjalanan dan akomodasi terpadu (*all-in-one*) yang dibangun menggunakan **Flutter**. Aplikasi ini menghadirkan antarmuka modern yang bersih (*Clean Light Mode*) untuk memudahkan pengguna merencanakan liburan, memesan transportasi, hingga mengeksplorasi destinasi wisata populer di seluruh dunia.

<img width="720" height="1600" alt="image" src="https://github.com/user-attachments/assets/894501e0-5236-4cc7-8e47-31ae0cba8bc7" />

---

## Fitur Utama

### 1. Layanan Pemesanan Terpadu (Multi-Service Booking)
* **Hotel & Staycation:** Pencarian area/hotel dengan pengaturan jumlah kamar, tamu dewasa/anak, serta pemilih tanggal check-in.
* **Tiket Pesawat:**
  * **3 Sub-Menu Interaktif:** Pemesanan *Tiket Pesawat*, *Check-in Online* (PNR), dan *Bagasi Tambahan*.
  * **Mode Perjalanan Fleksibel:** Mendukung rute *Sekali Jalan / Pulang Pergi* serta *Multi-kota* (default 2 rute dengan opsi penambahan rute dinamis).
  * **Kontrol Lengkap:** Tombol tukar rute (*swap*) beranimasi, pemilih bandara asal/tujuan, kalender interaktif, dan *stepper* penumpang (Dewasa, Anak, Bayi) beserta kelas kabin (*Ekonomi, Ekonomi Premium, Bisnis, First Class*).
* **Kereta Api & Whoosh:** Pemesanan tiket kereta antar-kota dan kereta cepat dengan pemilih stasiun, tanggal berangkat/pulang, dan kelas perjalanan.
* **Transportasi & Aktivitas Lainnya:** Bus & Travel, Antar Jemput Bandara, Rental Mobil (*Tanpa Sopir* & *Dengan Sopir*), Atraksi Wisata, dan Asuransi Perjalanan.

### 2. Eksplorasi Destinasi (Travel Places)
* **Filter Negara & Pencarian Real-Time:** Menyaring destinasi wisata berdasarkan negara (*Indonesia, Japan, Italy, Singapore, UAE*) maupun kata kunci pencarian, serta tab pengurutan (*Popular, Latest, All*).
* **Detail Destinasi & Rekomendasi:** *Bottom sheet* interaktif yang menampilkan deskripsi destinasi, spot wajib dikunjungi (*Must-Visit Spots*), serta rekomendasi tempat wisata lain di negara yang sama beserta estimasi harganya.

### 3. Multi-Bahasa & Konversi Mata Uang Otomatis
* Mendukung pergantian bahasa (**Indonesia** & **English**) serta konversi mata uang secara *real-time* (**IDR**, **USD**, **SGD**, **JPY**) di seluruh tampilan harga aplikasi.

---

## Tech Stack
* **Framework:** Flutter (Dart)
* **UI & Design System:** Material 3, Custom Clean Light Theme
* **State Management:** StatefulWidget & Interactive BottomSheets / Pickers

---

## Cara Menjalankan Project

1. **Clone repositori ini:**
   ```bash
   git clone [https://github.com/xenosnv/KovaGo.git](https://github.com/xenosnv/KovaGo.git)
   cd KovaGo
