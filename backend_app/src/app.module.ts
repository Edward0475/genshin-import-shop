import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config'; // <--- 1. Import ConfigModule
import { TypeOrmModule } from '@nestjs/typeorm';
import { Weapon } from './weapons/weapon.entity';
import { User } from './users/user.entity';
import { WeaponsModule } from './weapons/weapons.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';

@Module({
  imports: [
    // 2. Tambahkan ConfigModule di urutan PALING ATAS
    ConfigModule.forRoot({
      isGlobal: true, 
    }),
    
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: 'localhost',
      port: 3306,
      username: 'root',
      password: '',
      database: 'genshin_import', // Pastikan nama DB ini sama dengan di phpMyAdmin
      entities: [Weapon, User],
      synchronize: false, // Catatan: Jika ingin kolom baru (seperti description) otomatis terbuat di DB, ubah ini jadi true
    }),
    WeaponsModule,
    AuthModule,
    UsersModule,
  ],
})
export class AppModule {}