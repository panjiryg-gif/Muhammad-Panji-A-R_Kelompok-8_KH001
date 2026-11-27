import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/admin.dart';

class AdminService {
  final String baseUrl;
  AdminService({this.baseUrl = AppConfig.adminBaseUrl});

  // GET seluruh admin
  Future<List<Admin>> getAdmins() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Admin.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat admin (${res.statusCode})');
  }

  // GET satu admin berdasarkan ID
  Future<Admin> getAdmin(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/$id'));
    if (res.statusCode == 200) {
      return Admin.fromJson(jsonDecode(res.body));
    }
    throw Exception('Admin ID $id tidak ditemukan (${res.statusCode})');
  }

  // DELETE admin berdasarkan ID
  Future<String> deleteAdmin(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode == 200 || res.statusCode == 204) {
      return 'Admin ID $id berhasil dihapus (status ${res.statusCode})';
    }
    throw Exception('Gagal hapus admin (${res.statusCode})');
  }
}
