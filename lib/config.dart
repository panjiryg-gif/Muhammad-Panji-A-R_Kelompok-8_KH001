class AppConfig {
  // GANTI dengan 3 digit terakhir NIM kamu
  static const int n = 181;

  static const int userId = 1000 + n;
  static const int adminId = 2000 + n;

  // Ganti ke endpoint API yang kamu pakai di praktikum sebelumnya
  static const String userBaseUrl = 'https://jsonplaceholder.typicode.com/users';
  static const String adminBaseUrl = 'https://jsonplaceholder.typicode.com/users'; // ganti ke endpoint /admins
}
