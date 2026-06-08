import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class AuthService {
  // Fungsi untuk menyimpan token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // Fungsi untuk mengambil token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Fungsi Login ke Backend
  static Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/auth/login',
        ), // Sesuaikan endpoint login-mu
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        String token =
            data['access_token'] ??
            data['token']; // Cek apakah key-nya 'access_token' atau 'token'
        await saveToken(token);
        return token;
      } else {
        return null; // Login gagal
      }
    } catch (e) {
      return null;
    }
  }
}
