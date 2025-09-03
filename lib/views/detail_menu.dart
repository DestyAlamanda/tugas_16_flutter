import 'package:flutter/material.dart';
import 'package:tugas16_flutter/model/menu_model.dart';

class DetailMenu extends StatefulWidget {
  final MenuModel menu;
  const DetailMenu({super.key, required this.menu});

  @override
  State<DetailMenu> createState() => _DetailMenuState();
}

class _DetailMenuState extends State<DetailMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   title: Text(widget.menu.name),
      //   backgroundColor: Colors.orange,
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                widget.menu.imageUrl ?? '',
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Text("⭐ 9.6"),
                  ),
                ),
                Text(
                  "Rp ${widget.menu.price}",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            ),

            SizedBox(height: 15),

            Text(
              widget.menu.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.menu.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
