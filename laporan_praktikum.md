# Laporan Praktikum: CRUD Model User dan Admin pada Flutter

**Nama:** ...........  **NIM:** ...........  **N:** ...
**ID User:** 1000 + N = ....  **ID Admin:** 2000 + N = ....

## 1. Struktur File
```
lib/
├── main.dart                 # UI: tab User & Admin, halaman detail
├── config.dart               # N, ID User, ID Admin, base URL
├── models/
│   ├── user.dart             # Model User (id, name, email, city)
│   └── admin.dart            # Model Admin (id, name, email, department)
└── services/
    ├── api_service.dart      # CRUD User (GET, POST, PUT, PATCH, DELETE)
    └── admin_service.dart    # getAdmins, getAdmin, deleteAdmin
```
Model dan Service dipisah per entitas agar kode mudah dirawat dan tidak saling bergantung.

## 2. Implementasi Model
- **User** memiliki properti `id`, `name`, `email`, `city`. `User.fromJson()` mengubah JSON menjadi objek dan `toJson()` mengubah objek menjadi JSON untuk POST/PUT.
- **Admin** memiliki properti `id`, `name`, `email`, `department`. `Admin.fromJson()` mengonversi JSON menjadi objek Admin.

## 3. Proses GET
Package `http` mengirim `http.get()` ke endpoint. Jika status 200, `jsonDecode` mengubah body menjadi List/Map, lalu dipetakan ke objek lewat `fromJson`. `getUsers()` dan `getAdmins()` mengambil seluruh data, sedangkan `getUser(id)` dan `getAdmin(id)` mengambil satu data lewat `/{id}`. Hasilnya ditampilkan dengan `FutureBuilder`.

## 4. Proses POST, PUT, PATCH, DELETE pada User
- **POST**: menambah User dengan ID 1000 + N. Body berisi JSON User, status sukses 201.
- **PUT**: mengganti nama dan email User. Status sukses 200.
- **PATCH**: hanya memperbarui `name` dengan menambah teks ` - Flutter Developer`.
- **DELETE**: menghapus User berdasarkan ID, status sukses 200/204.

## 5. Proses DELETE Admin
`deleteAdmin(id)` mengirim `http.delete()` ke `/{id}`, dengan ID Admin = 2000 + N. Di UI, penghapusan diawali dialog konfirmasi, lalu hasilnya ditampilkan lewat SnackBar.

## 6. Tampilan Akhir dan Hasil Pengujian
| Fitur | Cara uji | Hasil | Screenshot |
|---|---|---|---|
| Daftar User | Buka tab User | ... | (lampirkan) |
| Daftar Admin | Buka tab Admin | ... | (lampirkan) |
| Detail User | Tap item / chip GET ID | ... | (lampirkan) |
| Detail Admin | Tap item / chip GET ID | ... | (lampirkan) |
| POST User | Chip POST | ... | (lampirkan) |
| PUT User | Chip PUT | ... | (lampirkan) |
| PATCH User | Chip PATCH | ... | (lampirkan) |
| DELETE User | Chip DELETE | ... | (lampirkan) |
| DELETE Admin | Ikon hapus / chip DELETE | ... | (lampirkan) |

## 7. Kesimpulan
(Tulis kesimpulan singkat dengan kata-katamu sendiri.)
