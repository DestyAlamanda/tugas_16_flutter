import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/model/menu_model.dart';
import 'package:tugas16_flutter/views/menu/edit_menu_show.dart';

enum MenuItem { item1, item2 }

class DetailMenu extends StatefulWidget {
  final MenuModel menu;
  const DetailMenu({super.key, required this.menu});

  @override
  State<DetailMenu> createState() => _DetailMenuState();
}

class _DetailMenuState extends State<DetailMenu> {
  late MenuModel currentMenu;

  @override
  void initState() {
    super.initState();
    currentMenu = widget.menu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Menu"),
        actions: [
          PopupMenuButton<MenuItem>(
            onSelected: (value) async {
              // ===== EDIT MENU =====
              if (value == MenuItem.item1) {
                final updatedMenu = await showDialog<MenuModel>(
                  context: context,
                  builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    insetPadding: const EdgeInsets.all(16),
                    child: Material(
                      // ⬅️ supaya TextField ada Material ancestor
                      child: EditMenuPage(menu: currentMenu),
                    ),
                  ),
                );

                if (updatedMenu != null) {
                  setState(() => currentMenu = updatedMenu);
                  Navigator.pop(context, true); // trigger refresh Home
                }
              }
              // ===== HAPUS MENU =====
              else if (value == MenuItem.item2) {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Hapus Menu"),
                    content: const Text(
                      "Apakah Anda yakin ingin menghapus menu ini?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          "Hapus",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    final result = await AuthenticationAPI.deleteMenu(
                      currentMenu.id,
                    );
                    if (result == "success") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Menu berhasil dihapus")),
                      );
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Gagal menghapus menu")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                }
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: MenuItem.item1, child: Text("Edit")),
              PopupMenuItem(value: MenuItem.item2, child: Text("Hapus")),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: currentMenu.imageUrl != null
                  ? currentMenu.imageUrl!.startsWith("http")
                        ? Image.network(
                            currentMenu.imageUrl!,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(currentMenu.imageUrl!),
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          )
                  : Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: const Center(child: Text("No Image")),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("⭐ 9.6"),
                Text(
                  "Rp ${currentMenu.price}",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              currentMenu.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(currentMenu.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
