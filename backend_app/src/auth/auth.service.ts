import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(private jwtService: JwtService) {}

  // 1. Fungsi Google OAuth
  async googleLogin(req: any) {
    if (!req.user) {
      return 'No user from google';
    }

    const payload = { 
      email: req.user.email, 
      sub: req.user.firstName 
    };

    return {
      message: 'Berhasil login dengan Google OAuth',
      user: req.user,
      accessToken: this.jwtService.sign(payload),
    };
  }

  // 2. Fungsi "Satpam" (Mengecek admin & user)
  async validateUser(username: string, pass: string): Promise<any> {
    if (username === 'admin' && pass === 'admin1234') {
      return { userId: 1, username: 'admin' }; 
    }
    if (username === 'user' && pass === 'user1234') {
      return { userId: 2, username: 'user' }; 
    }
    return null; 
  }

  // 3. Fungsi "Resepsionis" (Memberikan Token) ---> PASTIKAN BAGIAN INI ADA!
  async login(user: any) {
    const payload = { username: user.username, sub: user.userId };
    return {
      access_token: this.jwtService.sign(payload),
    };
  }
}