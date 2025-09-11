import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/model/menu_model.dart';
import 'package:tugas16_flutter/utils/formatters.dart';
import 'package:tugas16_flutter/views/menu/update_menu.dart';

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
        title: const Text(
          "Detail Menu",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: [
          PopupMenuButton<MenuItem>(
            onSelected: (value) async {
              if (value == MenuItem.item1) {
                // Panggil langsung showUpdateMenuDialog
                final updatedMenu = await showUpdateMenuDialog(
                  context,
                  currentMenu,
                );

                if (updatedMenu != null) {
                  setState(() => currentMenu = updatedMenu);
                  Navigator.pop(context, true); // refresh Home
                }
              } else if (value == MenuItem.item2) {
                // Hapus menu seperti sebelumnya
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: Colors.red.shade600,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Batalkan Reservasi",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    content: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Apakah Anda yakin ingin menghapus menu ini?",
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                    actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text(
                              "Batal",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              "Ya, Hapus",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
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
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 12),
                              Text("Menu berhasil dihapus"),
                            ],
                          ),
                          backgroundColor: Colors.orange,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.error, color: Colors.white),
                              const SizedBox(width: 12),
                              Expanded(child: Text(result)),
                            ],
                          ),
                          backgroundColor: Colors.red.shade600,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
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

      body: Column(
        children: [
          // Bagian Foto
          currentMenu.imageUrl != null
              ? currentMenu.imageUrl!.startsWith("http")
                    ? Image.network(
                        currentMenu.imageUrl!,
                        width: double.infinity,
                        height: 280,
                        fit: BoxFit.fitWidth, // gambar menyesuaikan lebar
                      )
                    : Image.file(
                        File(currentMenu.imageUrl!),
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.fitWidth,
                      )
              : Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey[300],

                  child: const Center(child: Text("No Image")),
                ),

          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("⭐⭐⭐⭐⭐"),
                          Text(
                            Formatters.formatPrice(
                              double.tryParse(currentMenu.price)?.toInt() ?? 0,
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        currentMenu.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentMenu.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
