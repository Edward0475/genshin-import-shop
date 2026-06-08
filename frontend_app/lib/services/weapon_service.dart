import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

class WeaponService {
  // FUNGSI HELPER UNTUK HEADER AUTH (SUDAH DIPERBAIKI)
  static Future<Map<String, String>> getAuthHeaders() async {
    String? token = await AuthService.getToken();
    print("DEBUG: Token yang dikirim ke backend adalah: $token");
    // Jika token null (belum login), gunakan placeholder agar tidak crash
    // Ganti "TOKEN_ANDA_DISINI" dengan token asli dari Postman jika masih ingin bypass
    String finalToken = token ?? "TOKEN_ANDA_DISINI";

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $finalToken',
    };
  }

  // 1. Mengambil semua data senjata
  static Future<dynamic> getAllWeapons() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/weapons'),
        headers: await getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal mengambil data: ${response.statusCode}');
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
        headers: await getAuthHeaders(),
        body: json.encode(weaponData),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Gagal menambah data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
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
        headers: await getAuthHeaders(),
        body: json.encode(weaponData),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal mengedit data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }

  // 4. Fungsi Hapus (DELETE)
  static Future<void> deleteWeapon(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/weapons/$id'),
        headers: await getAuthHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal menghapus data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }
}
