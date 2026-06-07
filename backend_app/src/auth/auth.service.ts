import { Injectable } from '@nestjs/common';

@Injectable()
export class AuthService {
  // Tambahkan fungsi ini
  async googleLogin(req) {
    if (!req.user) {
      return 'Tidak ada user dari Google';
    }

    // DI SINI: Kamu bisa tambahkan logika untuk simpan user ke Database (UsersService)
    // Jika user belum ada, daftarkan. Jika sudah ada, langsung buat token JWT.
    
    return {
      message: 'User info from Google',
      user: req.user
    };
  }
}