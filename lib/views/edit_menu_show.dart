import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/model/menu_model.dart';

class EditMenuPage extends StatefulWidget {
  final MenuModel menu;
  const EditMenuPage({super.key, required this.menu});

  @override
  State<EditMenuPage> createState() => _EditMenuPageState();
}

class _EditMenuPageState extends State<EditMenuPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  File? selectedImage;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.menu.name);
    priceController = TextEditingController(text: widget.menu.price);
    descriptionController = TextEditingController(
      text: widget.menu.description,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<void> updateMenu() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final result = await AuthenticationAPI.updateMenu(
        widget.menu.id,
        nameController.text,
        descriptionController.text,
        priceController.text,
        selectedImage,
      );

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), backgroundColor: Colors.green),
      );

      // Kembalikan MenuModel baru dengan gambar File atau URL
      final updatedMenu = MenuModel(
        id: widget.menu.id,
        name: nameController.text,
        description: descriptionController.text,
        price: priceController.text,
        imageUrl: selectedImage != null
            ? selectedImage!.path
            : widget.menu.imageUrl,
      );

      Navigator.pop(context, updatedMenu);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Menu")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: selectedImage != null
                    ? Image.file(selectedImage!, height: 150)
                    : widget.menu.imageUrl != null
                    ? widget.menu.imageUrl!.startsWith("http")
                          ? Image.network(widget.menu.imageUrl!, height: 150)
                          : Image.file(File(widget.menu.imageUrl!), height: 150)
                    : Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Text("Tap untuk pilih gambar"),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
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
                controller: descriptionController,
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
                onPressed: loading ? null : updateMenu,
                icon: const Icon(Icons.save),
                label: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("Simpan"),
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
