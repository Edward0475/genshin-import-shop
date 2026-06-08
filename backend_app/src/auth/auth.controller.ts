import { Controller, Get, Post, Body, UseGuards, Req, Res, UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthGuard } from '@nestjs/passport';

@Controller('auth')
export class AuthController { // <--- NestJS mencari baris ini!
  constructor(private readonly authService: AuthService) {}

  // --- 1. ENDPOINT LOGIN MANUAL ---
  @Post('login')
  async login(@Body() body: any) {
    const user = await this.authService.validateUser(body.username, body.password);
    
    if (!user) {
      throw new UnauthorizedException('Username atau password salah');
    }
    
    return this.authService.login(user);
  }

  // --- 2. ENDPOINT GOOGLE OAUTH ---
  @Get('google')
  @UseGuards(AuthGuard('google'))
  async googleAuth(@Req() req) {
    // Rute ini akan otomatis melempar user ke halaman login Google
  }

  @Get('google/callback')
  @UseGuards(AuthGuard('google'))
  async googleAuthRedirect(@Req() req, @Res() res) {
    const tokenData = await this.authService.googleLogin(req);
    return res.json(tokenData);
  }
}