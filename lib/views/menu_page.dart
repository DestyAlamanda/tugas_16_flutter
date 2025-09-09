import 'package:flutter/material.dart';
import 'package:tugas16_flutter/model/menu_model.dart';
import 'package:tugas16_flutter/views/detail_menu.dart';

class MenuPage extends StatefulWidget {
  final List<MenuModel> menus;
  final Function(MenuModel)? onTapMenu; // Callback opsional

  const MenuPage({super.key, required this.menus, this.onTapMenu});

  static const String id = "/menu";

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Set<int> likedItems = {}; // Simpan index menu yang disukai

  @override
  Widget build(BuildContext context) {
    if (widget.menus.isEmpty) {
      return const Center(child: Text("Belum ada menu tersedia"));
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: widget.menus.length,
      itemBuilder: (context, index) {
        final menu = widget.menus[index];
        final isLiked = likedItems.contains(index);

        return GestureDetector(
          onTap: () async {
            if (widget.onTapMenu != null) {
              widget.onTapMenu!(menu); // panggil callback dari Home
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailMenu(menu: menu)),
              );
            }
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child:
                            (menu.imageUrl != null && menu.imageUrl!.isNotEmpty)
                            ? Image.network(
                                menu.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Container(
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(
                                    Icons.fastfood,
                                    size: 64,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            menu.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Rp ${menu.price}",
                            style: TextStyle(color: Colors.orange[800]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Label rating
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

              // Like button
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        setState(() {
                          if (isLiked) {
                            likedItems.remove(index);
                          } else {
                            likedItems.add(index);
                            print("Menu ${menu.name} disukai");
                          }
                        });
                      },
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            key: ValueKey(isLiked),
                            size: 18,
                            color: isLiked ? Colors.red : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
