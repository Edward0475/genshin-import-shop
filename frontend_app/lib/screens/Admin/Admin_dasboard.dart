import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. IMPORT HALAMAN EDIT SENJATA
import 'Add_deleted_editweapon_screen.dart';
// 2. IMPORT HALAMAN DETAIL PRODUK ADMIN
import 'product_detailadmin_screen.dart';
import 'admin_more_screen.dart';
import 'admin_notification_screen.dart';

// ---> IMPORT SERVICE BACKEND <---
import '../../services/weapon_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  static const primaryPurple = Color(0xFF5A4CA9);

  // Future untuk mengambil data dari backend
  late Future<dynamic> _weaponsFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // Fungsi untuk menyegarkan data dari database
  void _refreshData() {
    setState(() {
      _weaponsFuture = WeaponService.getAllWeapons();
    });
  }

  final List<Map<String, String>> categories = [
    {'name': 'Bow', 'image': 'assets/images/Bow.png'},
    {'name': 'Claymore', 'image': 'assets/images/claymore.png'},
    {'name': 'Sword', 'image': 'assets/images/sword.png'},
    {'name': 'Catalyst', 'image': 'assets/images/catalyst.png'},
    {'name': 'Polearm', 'image': 'assets/images/poleyean.png'},
    {'name': 'Artifacts', 'image': 'assets/images/Artifact.png'},
  ];

  Widget _buildProductImage(String imagePath) {
    if (imagePath.isEmpty) {
      return const Icon(Icons.image_not_supported, color: Colors.black26);
    }
    if (imagePath.startsWith('/data') || imagePath.startsWith('/storage')) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.contain,
        errorBuilder: (c, e, s) =>
            const Icon(Icons.image_not_supported, color: Colors.black26),
      );
    } else if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (c, e, s) =>
            const Icon(Icons.image_not_supported, color: Colors.black26),
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (c, e, s) =>
            const Icon(Icons.image_not_supported, color: Colors.black26),
      );
    }
  }

  // Fungsi untuk memformat angka jadi harga (misal: 300000 -> 300.000)
  String _formatPrice(int price) {
    String priceStr = price.toString();
    String result = '';
    int count = 0;
    for (int i = priceStr.length - 1; i >= 0; i--) {
      result = priceStr[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = '.$result';
      }
    }
    return 'RP.$result';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryPurple,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HI ADMIN',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminNotificationScreen(),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search weapon',
                              hintStyle: GoogleFonts.inter(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const Icon(Icons.search, color: Colors.black, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weapon category',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: categories.map((cat) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      cat['image'] as String,
                                      width: 58,
                                      height: 58,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      cat['name'] as String,
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All Weapon',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: primaryPurple,
                              ),
                            ),
                            Text(
                              'See all',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: primaryPurple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ---> FUTURE BUILDER TERINTEGRASI BACKEND <---
                        FutureBuilder<dynamic>(
                          future: _weaponsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Gagal memuat data: \n${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            }

                            // Parsing respons dari Node.js (Aman untuk berbagai bentuk JSON)
                            var rawData = snapshot.data;
                            List<dynamic> weapons = [];
                            if (rawData is List) {
                              weapons = rawData;
                            } else if (rawData is Map &&
                                rawData.containsKey('data')) {
                              weapons = rawData['data'] is List
                                  ? rawData['data']
                                  : [];
                            } else if (rawData is Map &&
                                rawData.containsKey('weapons')) {
                              weapons = rawData['weapons'] is List
                                  ? rawData['weapons']
                                  : [];
                            }

                            if (weapons.isEmpty) {
                              return const Center(
                                child: Text("Belum ada senjata di Database."),
                              );
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.72,
                                  ),
                              itemCount: weapons.length,
                              itemBuilder: (context, idx) {
                                final item = weapons[idx];

                                // Keamanan Parsing Data
                                final String itemName =
                                    item['name']?.toString() ?? 'Unknown';
                                final String itemImage =
                                    item['image']?.toString() ?? '';
                                final String itemDesc =
                                    item['description']?.toString() ??
                                    'Tidak ada deskripsi';

                                // Bersihkan string harga dari huruf/simbol agar bisa di-parse
                                String rawPrice =
                                    item['price']?.toString().replaceAll(
                                      RegExp(r'[^0-9]'),
                                      '',
                                    ) ??
                                    '0';
                                double priceVal =
                                    double.tryParse(rawPrice) ?? 0;
                                int? weaponIdVal = int.tryParse(
                                  item['id']?.toString().replaceAll(
                                        RegExp(r'[^0-9]'),
                                        '',
                                      ) ??
                                      '0',
                                );

                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    splashColor: const Color(0x335A4CA9),
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      // Pergi ke Detail, jika ada perubahan tunggu hasilnya
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ProductDetailAdminScreen(),
                                          settings: RouteSettings(
                                            arguments: {
                                              // ==========================================
                                              // INI BAGIAN YANG DITAMBAHKAN .toString()
                                              // ==========================================
                                              'id':
                                                  item['id']?.toString() ?? '',
                                              'name': itemName,
                                              'price':
                                                  item['price']?.toString() ??
                                                  '0',
                                              'image': itemImage,
                                              'description': itemDesc,
                                            },
                                          ),
                                        ),
                                      );
                                      // Refresh layar setelah kembali dari Detail (siapa tahu ada edit/delete di sana)
                                      _refreshData();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF0F1F5),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(0x0D000000),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  12.0,
                                                ),
                                                child: _buildProductImage(
                                                  itemImage,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                  bottomLeft: Radius.circular(
                                                    20,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    20,
                                                  ),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10,
                                                  ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    itemName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        // Format ulang agar rapi
                                                        _formatPrice(
                                                          priceVal.toInt(),
                                                        ),
                                                        style:
                                                            GoogleFonts.inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: 12,
                                                              color:
                                                                  primaryPurple,
                                                            ),
                                                      ),
                                                      // TOMBOL EDIT MEMANGGIL DATABASE
                                                      GestureDetector(
                                                        onTap: () async {
                                                          final result = await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AddEditWeaponScreen(
                                                                    weaponId:
                                                                        weaponIdVal,
                                                                    initialName:
                                                                        itemName,
                                                                    initialPrice:
                                                                        priceVal,
                                                                    initialImage:
                                                                        itemImage,
                                                                    initialDesc:
                                                                        itemDesc,
                                                                  ),
                                                            ),
                                                          );
                                                          // Jika proses Edit berhasil, REFRESH DATABASE
                                                          if (result == true ||
                                                              result != null) {
                                                            _refreshData();
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                  'Perubahan berhasil disimpan!',
                                                                ),
                                                                backgroundColor:
                                                                    Colors.blue,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: const Icon(
                                                          Icons.edit_outlined,
                                                          color: Colors.black87,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAVIGATION BAR ADMIN
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavTab(Icons.storefront, 'Menu', true, primaryPurple, () {}),

            // TOMBOL ADD MEMANGGIL DATABASE
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEditWeaponScreen(),
                  ),
                );

                // Jika proses Add berhasil di layar sana, REFRESH DATABASE di sini
                if (result == true || result != null) {
                  _refreshData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data berhasil ditambahkan ke Database!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: primaryPurple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add\nWeapon',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            _buildNavTab(Icons.more_horiz, 'More', false, primaryPurple, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminMoreScreen(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab(
    IconData icon,
    String label,
    bool active,
    Color activeColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? activeColor : Colors.black87, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              color: active ? activeColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
