import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas16_flutter/api/api_service.dart';

class AddMenu extends StatefulWidget {
  const AddMenu({super.key});

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  File? selectedImage;
  bool loading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final result = await AuthenticationAPI.addMenu(
        nameController.text,
        descController.text,
        priceController.text,
        selectedImage,
      );
      print("Hasil addMenu API: $result");

      setState(() => loading = false);

      if (result == "success") {
        Navigator.pop(context, true); // return true biar reload list menu
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Menu"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: pickImage,
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
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
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
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Menu",
                  prefixIcon: Icon(Icons.fastfood_outlined),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Harga",
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Harga wajib diisi";
                  if (int.tryParse(val) == null) return "Harus berupa angka";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: descController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Deskripsi wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: loading ? null : handleSubmit,
                icon: const Icon(Icons.add),
                label: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("Tambah Menu"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
