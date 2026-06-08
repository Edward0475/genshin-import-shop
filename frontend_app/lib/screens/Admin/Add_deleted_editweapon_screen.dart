import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
// ---> PERBAIKAN IMPORT: Mundur 2 folder (dari Admin -> screens -> lib) lalu masuk ke services
import '../../services/weapon_service.dart';

class AddEditWeaponScreen extends StatefulWidget {
  final int? weaponId;
  final String? initialName;
  final String? initialDesc;
  final String? initialCategory;
  final double? initialPrice;
  final int? initialStock;
  final String? initialImage;

  const AddEditWeaponScreen({
    super.key,
    this.weaponId,
    this.initialName,
    this.initialDesc,
    this.initialCategory,
    this.initialPrice,
    this.initialStock,
    this.initialImage,
  });

  @override
  State<AddEditWeaponScreen> createState() => _AddEditWeaponScreenState();
}

class _AddEditWeaponScreenState extends State<AddEditWeaponScreen> {
  final Color primaryPurple = const Color(0xFF5A4CA9);
  final Color bgColor = const Color(0xFFF2F3F8);

  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;

  late String selectedCategory;
  late int stock;
  late String imageUrl;

  bool _isLoading = false;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      // PERBAIKAN: Cek apakah widget masih aktif sebelum update UI
      if (!mounted) return;

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // PERBAIKAN: Cek apakah widget masih aktif sebelum munculin SnackBar
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal mengambil gambar')));
    }
  }

  final List<Map<String, String>> categories = [
    {'name': 'Bow', 'image': 'assets/images/Bow.png'},
    {'name': 'Claymore', 'image': 'assets/images/claymore.png'},
    {'name': 'Sword', 'image': 'assets/images/sword.png'},
    {'name': 'Catalyst', 'image': 'assets/images/catalyst.png'},
    {'name': 'Polearm', 'image': 'assets/images/poleyean.png'},
    {'name': 'Artifacts', 'image': 'assets/images/Artifact.png'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? "");
    _descController = TextEditingController(text: widget.initialDesc ?? "");

    String priceText = "";
    if (widget.initialPrice != null) {
      priceText = widget.initialPrice == widget.initialPrice!.toInt()
          ? widget.initialPrice!.toInt().toString()
          : widget.initialPrice!.toString();
    }
    _priceController = TextEditingController(text: priceText);

    selectedCategory = widget.initialCategory ?? 'Claymore';
    stock = widget.initialStock ?? 1;
    imageUrl = widget.initialImage ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.weaponId == null ? "Add Weapon" : "Edit Weapon",
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 230,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    child: _buildImagePreview(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildInputField(
                  label: 'Product Name',
                  controller: _nameController,
                  hintText: "Enter weapon name",
                  isBold: true,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildInputField(
                  label: 'Product Description',
                  controller: _descController,
                  hintText: 'Enter product description...',
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categories.map((cat) {
                            bool isSelected = selectedCategory == cat['name'];
                            return GestureDetector(
                              onTap: () => setState(
                                () => selectedCategory = cat['name']!,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFFC7A877)
                                            : const Color(0xFF5A6E8B),
                                        shape: BoxShape.circle,
                                        border: isSelected
                                            ? Border.all(
                                                color: const Color(0xFFE3C594),
                                                width: 3,
                                              )
                                            : null,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          cat['image']!,
                                          width: 25,
                                          height: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      cat['name']!,
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildInputField(
                  label: 'Price',
                  controller: _priceController,
                  hintText: "e.g. 300000",
                  isBold: true,
                  isLarge: true,
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    } else if (imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('/data') || imageUrl.startsWith('/storage')) {
        return Image.file(
          File(imageUrl),
          fit: BoxFit.cover,
          width: double.infinity,
        );
      } else if (imageUrl.startsWith('http')) {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        );
      } else {
        return Image.asset(imageUrl, fit: BoxFit.cover, width: double.infinity);
      }
    } else {
      return Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: primaryPurple, width: 2),
          ),
          child: Icon(Icons.add_a_photo, size: 40, color: primaryPurple),
        ),
      );
    }
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3F8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => stock > 0 ? setState(() => stock--) : null,
                    icon: const Icon(Icons.remove, size: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      '$stock',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => stock++),
                    icon: const Icon(Icons.add, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_nameController.text.isEmpty ||
                              _priceController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Nama dan Harga tidak boleh kosong!',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          String cleanPrice = _priceController.text.replaceAll(
                            RegExp(r'[^0-9]'),
                            '',
                          );
                          double finalPrice =
                              double.tryParse(cleanPrice) ?? 0.0;

                          final weaponData = {
                            'name': _nameController.text,
                            'description': _descController.text,
                            'category': selectedCategory,
                            'price': finalPrice,
                            'stock': stock,
                            'image': _selectedImage?.path ?? imageUrl,
                          };

                          setState(() => _isLoading = true);

                          try {
                            if (widget.weaponId == null) {
                              await WeaponService.createWeapon(weaponData);

                              // PERBAIKAN: Cek mounted sebelum SnackBar
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Senjata berhasil ditambahkan!',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              await WeaponService.updateWeapon(
                                widget.weaponId!,
                                weaponData,
                              );

                              // PERBAIKAN: Cek mounted sebelum SnackBar
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Senjata berhasil diubah!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }

                            // PERBAIKAN: Cek mounted sebelum Navigator.pop
                            if (!mounted) return;
                            Navigator.pop(context, true);
                          } catch (e) {
                            // PERBAIKAN: Cek mounted sebelum SnackBar error
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally {
                            // PERBAIKAN: Gunakan mounted untuk setState
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          'CONFIRM',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool isBold = false,
    bool isLarge = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: label.contains('Description') ? 3 : 1,
            style: GoogleFonts.inter(
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w500,
              fontSize: isLarge ? 18 : 14,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(top: 8),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: Colors.black26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
