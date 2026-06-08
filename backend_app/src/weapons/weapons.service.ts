import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Weapon } from './weapon.entity';

@Injectable()
export class WeaponsService {
  constructor(
    @InjectRepository(Weapon)
    private weaponRepository: Repository<Weapon>,
  ) {}

  // Fungsi untuk GET semua senjata
  findAll(): Promise<Weapon[]> {
    return this.weaponRepository.find();
  }

  // Fungsi untuk GET 1 senjata spesifik
  async findOne(id: number): Promise<Weapon> {
    const weapon = await this.weaponRepository.findOneBy({ id });
    if (!weapon) {
      throw new NotFoundException(`Senjata dengan ID ${id} tidak ditemukan`);
    }
    return weapon;
  }

  // Fungsi untuk POST (Tambah Senjata)
  create(weaponData: Partial<Weapon>): Promise<Weapon> {
    const newWeapon = this.weaponRepository.create(weaponData);
    return this.weaponRepository.save(newWeapon);
  }

  // Fungsi untuk PUT (Update Senjata) - DENGAN FIX
  async update(id: number, updateData: Partial<Weapon>): Promise<Weapon> {
    // 1. Pastikan data ada
    await this.findOne(id); 

    // 2. Bersihkan data: Buang field 'category' agar tidak error di Database
    // Kita pakai destructuring untuk memisahkan category
    const { category, ...safeUpdateData } = updateData as any;

    // 3. Update menggunakan data yang sudah bersih (tanpa 'category')
    await this.weaponRepository.update(id, safeUpdateData);
    
    return this.findOne(id);
  }

  // Fungsi untuk DELETE (Hapus Senjata)
  async remove(id: number): Promise<void> {
    const weapon = await this.findOne(id);
    await this.weaponRepository.remove(weapon);
  }
}