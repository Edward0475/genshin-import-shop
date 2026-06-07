import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(private jwtService: JwtService) {}

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
}