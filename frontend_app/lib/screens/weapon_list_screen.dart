import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/weapon_service.dart';
import 'Admin/Add_deleted_editweapon_screen.dart';

class WeaponListScreen extends StatefulWidget {
  const WeaponListScreen({super.key});

  @override
  State<WeaponListScreen> createState() => _WeaponListScreenState();
}

class _WeaponListScreenState extends State<WeaponListScreen> {
  late Future<dynamic> _weaponsFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      // Kita ubah jadi dynamic agar bisa menangkap respon apapun dari Node.js
      _weaponsFuture = WeaponService.getAllWeapons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF5A4CA9),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5A4CA9),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditWeaponScreen(),
            ),
          );
          if (result == true) {
            _refreshData();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<dynamic>(
        future: _weaponsFuture,
        builder: (context, snapshot) {
          // 1. LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. ERROR DARI FLUTTER ATAU API
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "ERROR KONEKSI:\n${snapshot.error}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // 3. PARSING DATA DENGAN AMAN
          var rawData = snapshot.data;
          List<dynamic> weapons = [];

          if (rawData == null) {
            return const Center(child: Text("Data dari API NULL."));
          }

          // Mengecek format Node.js: Apakah Array langsung, atau dibungkus Object?
          if (rawData is List) {
            weapons = rawData;
          } else if (rawData is Map && rawData.containsKey('data')) {
            // Seringkali backend merespon {"status": 200, "data": [{...}]}
            weapons = rawData['data'] is List ? rawData['data'] : [];
          } else if (rawData is Map && rawData.containsKey('weapons')) {
            weapons = rawData['weapons'] is List ? rawData['weapons'] : [];
          } else {
            return Center(child: Text("Format API tidak dikenali:\n$rawData"));
          }

          // 4. JIKA DATA KOSONG DI DATABASE
          if (weapons.isEmpty) {
            return const Center(
              child: Text('Database kosong. Tekan + untuk menambah senjata.'),
            );
          }

          // 5. TAMPILKAN LIST
          return ListView.builder(
            itemCount: weapons.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final weapon = weapons[index];

              // Ambil data dengan aman menghindari Null Pointer
              final weaponName =
                  weapon['name']?.toString() ?? 'Senjata Tanpa Nama';
              final weaponType =
                  weapon['type']?.toString() ??
                  weapon['category']?.toString() ??
                  'Tipe tidak ada';
              final weaponPrice = weapon['price']?.toString() ?? '0';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF5A4CA9).withOpacity(0.2),
                    child: const Icon(Icons.security, color: Color(0xFF5A4CA9)),
                  ),
                  title: Text(
                    weaponName,
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Tipe: $weaponType\nHarga: Rp $weaponPrice"),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // TODO: Navigasi Edit
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // TODO: Fungsi Delete API
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
