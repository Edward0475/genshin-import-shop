import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport'; // Pastikan package @nestjs/passport terinstall
import { WeaponsService } from './weapons.service';
import { Weapon } from './weapon.entity';

@UseGuards(AuthGuard('jwt')) // PINTU DIKUNCI: Semua akses ke route di bawah ini wajib Token
@Controller('weapons')
export class WeaponsController {
  constructor(private readonly weaponsService: WeaponsService) {}

  @Get()
  findAll() {
    return this.weaponsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.weaponsService.findOne(+id);
  }

  @Post()
  create(@Body() weaponData: Partial<Weapon>) {
    return this.weaponsService.create(weaponData);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() updateData: Partial<Weapon>) {
    return this.weaponsService.update(+id, updateData);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.weaponsService.remove(+id);
  }
}