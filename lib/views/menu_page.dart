import 'package:flutter/material.dart';
import 'package:tugas16_flutter/model/menu_model.dart';
import 'package:tugas16_flutter/views/detail_menu.dart';

class MenuPage extends StatefulWidget {
  final List<MenuModel> menus;

  const MenuPage({super.key, required this.menus});

  static const String id = "/menu";

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool isLiked = false;
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
        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailMenu(menu: menu)),
            );
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
                            : const Icon(
                                Icons.fastfood,
                                size: 64,
                                color: Colors.orange,
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
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                      if (isLiked) print("Disukai");
                    },
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(6),
                      child: Icon(
                        Icons.favorite,
                        size: 25,
                        color: isLiked ? Colors.pink[500] : Colors.grey,
                      ),
                      // ),
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
