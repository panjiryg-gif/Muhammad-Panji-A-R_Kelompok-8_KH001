import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/user.dart';

class ApiService {
  final String baseUrl;
  ApiService({this.baseUrl = AppConfig.userBaseUrl});

  static const _headers = {'Content-Type': 'application/json; charset=UTF-8'};

  // GET semua user
  Future<List<User>> getUsers() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => User.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat user (${res.statusCode})');
  }

  // GET satu user berdasarkan ID
  Future<User> getUser(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/$id'));
    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(res.body));
    }
    throw Exception('User ID $id tidak ditemukan (${res.statusCode})');
  }

  // POST: tambah user baru (ID dari NIM)
  Future<String> createUser(User user) async {
    final res = await http.post(Uri.parse(baseUrl),
        headers: _headers, body: jsonEncode(user.toJson()));
    if (res.statusCode == 201 || res.statusCode == 200) {
      return 'Status ${res.statusCode}\n${res.body}';
    }
    throw Exception('Gagal menambah user (${res.statusCode})');
  }

  // PUT: perbarui nama dan email
  Future<String> updateUser(int id, String name, String email, String city) async {
    final user = User(id: id, name: name, email: email, city: city);
    final res = await http.put(Uri.parse('$baseUrl/$id'),
        headers: _headers, body: jsonEncode(user.toJson()));
    if (res.statusCode == 200) {
      return 'Status ${res.statusCode}\n${res.body}';
    }
    throw Exception('Gagal update user (${res.statusCode})');
  }

  // PATCH: tambahkan " - Flutter Developer" pada nama
  Future<String> patchUserName(int id, String currentName) async {
    final res = await http.patch(Uri.parse('$baseUrl/$id'),
        headers: _headers,
        body: jsonEncode({'name': '$currentName - Flutter Developer'}));
    if (res.statusCode == 200) {
      return 'Status ${res.statusCode}\n${res.body}';
    }
    throw Exception('Gagal patch user (${res.statusCode})');
  }

  // DELETE user berdasarkan ID
  Future<String> deleteUser(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode == 200 || res.statusCode == 204) {
      return 'User ID $id berhasil dihapus (status ${res.statusCode})';
    }
    throw Exception('Gagal hapus user (${res.statusCode})');
  }
}
