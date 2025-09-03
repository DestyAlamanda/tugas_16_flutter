import 'package:flutter/material.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/model/menu_model.dart';
import 'package:tugas16_flutter/views/detail_menu.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  static const String id = "/menu";

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<List<MenuModel>> futureMenus;
  List<MenuModel> allMenus = [];
  List<MenuModel> filteredMenus = [];
  // final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMenus();
  }

  void loadMenus() {
    setState(() {
      futureMenus = AuthenticationAPI.getMenus().then((menus) {
        allMenus = menus;
        filteredMenus = menus;
        return menus;
      });
    });
  }

  // void filterMenus(String keyword) {
  //     if (keyword.isEmpty) {
  //       setState(() => filteredMenus = allMenus);
  //     } else {
  //       setState(() {
  //         filteredMenus = allMenus
  //             .where(
  //               (menu) =>
  //                   menu.name.toLowerCase().contains(keyword.toLowerCase()) ||
  //                   menu.description.toLowerCase().contains(
  //                     keyword.toLowerCase(),
  //                   ),
  //             )
  //             .toList();
  //       });
  //     }
  //   }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MenuModel>>(
      future: futureMenus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.indigo),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Belum ada menu tersedia"));
        }

        final menus = snapshot.data!;

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
          itemCount: filteredMenus.length,
          itemBuilder: (context, index) {
            final menu = filteredMenus[index];
            print("DEBUG IMAGE URL: ${menu.imageUrl}");
            return GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailMenu(menu: menu)),
                );
                if (result == true) loadMenus();
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
                                (menu.imageUrl != null &&
                                    menu.imageUrl!.isNotEmpty)
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
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
                    top: 15,
                    left: 15,
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
                ],
              ),
            );
          },
        );
      },
    );
  }
}
