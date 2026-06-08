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
    
    ConfigModule.forRoot({
      isGlobal: true, 
    }),
    
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: 'localhost',
      port: 3306,
      username: 'root',
      password: '',
      database: 'genshin_import', 
      entities: [Weapon, User],
      synchronize: false, // 
    }),
    WeaponsModule,
    AuthModule,
    UsersModule,
  ],
})
export class AppModule {}