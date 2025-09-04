import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/model/menu_model.dart';

class EditMenu extends StatefulWidget {
  final MenuModel menu;
  final VoidCallback onSuccess;

  const EditMenu({super.key, required this.menu, required this.onSuccess});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descController;
  late TextEditingController priceController;
  File? selectedImage;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.menu.name);
    descController = TextEditingController(text: widget.menu.description);
    priceController = TextEditingController(text: widget.menu.price.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

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
    final result = await AuthenticationAPI.updateMenu(
      widget.menu.id,
      nameController.text.trim(),
      descController.text.trim(),
      priceController.text.trim(),
      selectedImage,
    );
    setState(() => loading = false);

    if (!mounted) return;
    if (result == "success") {
      Navigator.pop(context);
      widget.onSuccess();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Menu berhasil diperbarui"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePreview = selectedImage != null
        ? Image.file(selectedImage!, fit: BoxFit.cover)
        : (widget.menu.imageUrl != null
              ? Image.network(widget.menu.imageUrl!, fit: BoxFit.cover)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 40, color: Colors.grey[600]),
                    const SizedBox(height: 8),
                    const Text("Tap untuk pilih gambar"),
                  ],
                ));

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      content: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF1A2A80),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 16),
            const Text(
              "Edit Menu",
              style: TextStyle(fontSize: 20, color: Colors.amber),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                ),
                clipBehavior: Clip.antiAlias,
                child: Center(child: imagePreview),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama Menu",
                prefixIcon: Icon(Icons.fastfood_outlined),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Nama wajib diisi" : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Harga",
                prefixIcon: Icon(Icons.attach_money),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "Harga wajib diisi";
                if (int.tryParse(value) == null) return "Harus berupa angka";
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
              validator: (value) => value == null || value.isEmpty
                  ? "Deskripsi wajib diisi"
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Batal",
            style: TextStyle(
              color: Color(0xFF1A2A80),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A2A80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: handleSubmit,
          child: const Text("Simpan", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
