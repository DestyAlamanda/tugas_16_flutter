import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/model/menu_model.dart';

Future<MenuModel?> showUpdateMenuDialog(BuildContext context, MenuModel menu) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: menu.name);
  final priceController = TextEditingController(text: menu.price);
  final descController = TextEditingController(text: menu.description);
  File? selectedImage;
  bool loading = false;

  return showDialog<MenuModel>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickImage() async {
            final picker = ImagePicker();
            final picked = await picker.pickImage(source: ImageSource.gallery);
            if (picked != null) {
              setState(() => selectedImage = File(picked.path));
            }
          }

          Future<void> handleSubmit() async {
            if (!formKey.currentState!.validate()) return;

            setState(() => loading = true);

            try {
              final result = await AuthenticationAPI.updateMenu(
                menu.id,
                nameController.text,
                descController.text,
                priceController.text,
                selectedImage,
              );

              setState(() => loading = false);

              if (result.toLowerCase().contains("berhasil") ||
                  result.toLowerCase().contains("success")) {
                final updatedMenu = MenuModel(
                  id: menu.id,
                  name: nameController.text,
                  description: descController.text,
                  price: priceController.text,
                  imageUrl: selectedImage?.path ?? menu.imageUrl,
                );
                Navigator.pop(context, updatedMenu);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text("Menu berhasil diperbarui"),
                      ],
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            } catch (e) {
              setState(() => loading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Gagal update menu: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }

          return Dialog(
            insetPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Edit Menu",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Gambar
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : (menu.imageUrl != null &&
                                  menu.imageUrl!.isNotEmpty)
                            ? (menu.imageUrl!.startsWith("http")
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        menu.imageUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(menu.imageUrl!),
                                        fit: BoxFit.cover,
                                      ),
                                    ))
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 28,
                                        color: Colors.orange.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      "Tap untuk pilih gambar",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nama
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.fastfood_outlined,
                            color: Colors.orange.shade600,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        hintText: "Nama Menu",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.orange.shade600,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? "Nama wajib diisi"
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Harga
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.attach_money,
                            color: Colors.orange.shade600,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        hintText: "Harga",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.orange.shade600,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty)
                          return "Harga wajib diisi";
                        if (int.tryParse(val) == null)
                          return "Harus berupa angka";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Deskripsi
                    TextFormField(
                      controller: descController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.description,
                            color: Colors.orange.shade600,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        hintText: "Deskripsi",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.orange.shade600,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? "Deskripsi wajib diisi"
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // Tombol Aksi
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: loading ? null : handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Simpan"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
