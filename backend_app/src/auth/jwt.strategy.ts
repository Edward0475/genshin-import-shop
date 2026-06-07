import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(), // Mengambil token dari Header
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('JWT_SECRET'), // Mencocokkan dengan rahasia di .env
    });
  }

  async validate(payload: any) {
    return { email: payload.email, name: payload.sub };
  }
}