import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class WeaponService {
  // 1. Mengambil semua data senjata
  static Future<dynamic> getAllWeapons() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/weapons'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
          'Gagal mengambil data dari server: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke backend: $e');
    }
  }

  // 2. Fungsi Tambah (POST)
  static Future<void> createWeapon(Map<String, dynamic> weaponData) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/weapons'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(weaponData),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Gagal menambah data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan saat menambah data: $e');
    }
  }

  // 3. Fungsi Edit (PUT)
  static Future<void> updateWeapon(
    int id,
    Map<String, dynamic> weaponData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/weapons/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(weaponData),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal mengedit data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan saat mengedit data: $e');
    }
  }

  // 4. Fungsi Hapus (DELETE) - TERBARU
  static Future<void> deleteWeapon(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/weapons/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal menghapus data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan saat menghapus data: $e');
    }
  }
}
