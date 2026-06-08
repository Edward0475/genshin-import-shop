import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Jika UserSession error karena belum dibuat, kamu bisa komen baris ini dan logic di dalamnya
import '../user_session.dart';
// PENTING: Pastikan path import ini sesuai dengan lokasi file auth_service.dart kamu
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  late TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();

  static const Color primaryPurple = Color(0xFF5B4EB5);

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: UserSession().email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- LOGIKA LOGIN REAL KE BACKEND ---
  Future<void> _handleSignIn() async {
    final inputEmail = _emailController.text.trim();
    final inputPassword = _passwordController.text.trim();

    // 1. Validasi Input
    if (inputEmail.isEmpty || inputPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Email dan Password tidak boleh kosong!',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Tampilkan Loading
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logging in...')));

    // 2. Panggil API Login
    String? token = await AuthService.login(inputEmail, inputPassword);

    if (!mounted) return; // Mencegah error jika widget di-dispose
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (token != null) {
      // 3. Login Berhasil - SIMPAN TOKEN
      await AuthService.saveToken(token);
      print("LOGIN BERHASIL! Token yang disimpan: $token");

      // --- UBAH BAGIAN INI MENJADI LEBIH FLEKSIBEL ---
      // Ubah input menjadi huruf kecil semua agar tidak sensitif huruf besar/kecil
      String safeEmail = inputEmail.toLowerCase().trim();

      if (safeEmail == 'admin' || safeEmail == 'admin@gmail.com') {
        // JIKA ADMIN -> Pergi ke halaman Dashboard Admin
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        // JIKA USER BIASA -> Pergi ke halaman Menu Pembeli
        final session = UserSession();
        session.email = inputEmail.toUpperCase();
        if (inputEmail.toUpperCase() != 'ANDI@GMAIL.COM' &&
            session.name == 'ANDI') {
          session.name = inputEmail.split('@')[0].toUpperCase();
        }
        Navigator.pushReplacementNamed(context, '/menu');
      }
      // ----------------------------------------------
    } else {
      // 4. Login Gagal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login gagal, periksa email/password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 24.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/LOGO.png',
                  height: 200,
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.image_not_supported, size: 200),
                ),
                const SizedBox(height: 0),
                Text(
                  'WELCOME BACK',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Colors.black,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masukan email dan password',
                  style: GoogleFonts.inter(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 32),
                _buildPillTextField(
                  hint: 'email',
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                _buildPillTextField(
                  hint: 'password',
                  controller: _passwordController,
                  isObscured: true,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: primaryPurple,
                            onChanged: (val) =>
                                setState(() => _rememberMe = val ?? false),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Remember me',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.inter(
                          color: primaryPurple,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'LOG IN',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Or continue with',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/Google.png', height: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Google',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: Text(
                    'Belum punya akun?',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillTextField({
    required String hint,
    required TextEditingController controller,
    bool isObscured = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black87, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: TextField(
        controller: controller,
        obscureText: isObscured,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
