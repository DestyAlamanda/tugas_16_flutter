import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/model/menu_model.dart';

class AddMenuDialog {
  static Future<MenuModel?> show(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    File? selectedImage;
    bool loading = false;

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        selectedImage = File(picked.path);
      }
    }

    Future<void> handleSubmit(StateSetter setState) async {
      if (!formKey.currentState!.validate()) return;

      setState(() => loading = true);

      try {
        final result = await AuthenticationAPI.addMenu(
          nameController.text,
          descController.text,
          priceController.text,
          selectedImage,
        );

        setState(() => loading = false);

        if (result == "success") {
          /// 🔹 Buat object MenuModel baru
          final addMenu = MenuModel(
            id: 0, // sementara 0, kalau API balikin ID bisa diganti
            name: nameController.text,
            description: descController.text,
            price: priceController.text,
            imageUrl: selectedImage?.path,
          );

          /// 🔹 Lempar balik ke halaman pemanggil (Home)
          Navigator.pop(context, addMenu);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Menu berhasil ditambahkan"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal menambahkan menu: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return showDialog<MenuModel>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Tambah Menu"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await pickImage();
                      setState(() {});
                    },
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey),
                      ),
                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 40,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text("Tap untuk pilih gambar"),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nama Menu",
                      prefixIcon: Icon(Icons.fastfood_outlined),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Nama wajib diisi" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Harga",
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return "Harga wajib diisi";
                      if (int.tryParse(val) == null)
                        return "Harus berupa angka";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Deskripsi",
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? "Deskripsi wajib diisi"
                        : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: loading ? null : () => handleSubmit(setState),
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Tambah Menu"),
            ),
          ],
        ),
      ),
    );
  }
}
