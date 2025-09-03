import 'package:flutter/material.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/model/menu_model.dart';

class EditMenu extends StatefulWidget {
  final MenuModel menu;
  const EditMenu({super.key, required this.menu});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  void showDeleteDialog(BuildContext context, int menuId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Hapus Menu"),
        content: const Text("Apakah Anda yakin ingin menghapus menu ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context); // tutup dialog
              final result = await AuthenticationAPI.deleteMenu(menuId);

              if (!mounted) return;

              if (result == "success") {
                Navigator.pop(context, true); // kembali ke Home
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Menu berhasil dihapus"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menu = widget.menu;

    return Scaffold(
      appBar: AppBar(title: Text(menu.name), backgroundColor: Colors.orange),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "editBtn",
            backgroundColor: Colors.orange,
            child: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditMenu(menu: menu)),
              );
              if (result == true && mounted) {
                Navigator.pop(context, true); // refresh HomeScreen
              }
            },
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "deleteBtn",
            backgroundColor: Colors.red,
            child: const Icon(Icons.delete),
            onPressed: () => showDeleteDialog(context, menu.id),
          ),
        ],
      ),
      body: ListView(
        children: [
          (menu.imageUrl ?? "").isNotEmpty
              ? Image.network(
                  menu.imageUrl!,
                  height: 200,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Container(
                  height: 200,
                  color: Colors.orange[50],
                  child: const Center(
                    child: Icon(Icons.fastfood, size: 64, color: Colors.orange),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Rp ${menu.price}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  menu.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
