import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/model/menu_model.dart';
import 'package:tugas16_flutter/model/user_model.dart';
import 'package:tugas16_flutter/views/menu/add_menu.dart';
import 'package:tugas16_flutter/views/menu/detail_menu.dart';
import 'package:tugas16_flutter/views/menu/menu_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String id = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<MenuModel>> futureMenus;
  List<MenuModel> allMenus = [];
  List<MenuModel> filteredMenus = [];
  final TextEditingController searchController = TextEditingController();
  GetUserModel? userData;
  int _current = 0;

  final List<String> imgList = [
    'assets/images/carmen.jpg',
    'assets/images/carmen.jpg',
    'assets/images/carmen.jpg',
  ];

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadMenus();
  }

  void loadMenus() {
    setState(() {
      futureMenus = AuthenticationAPI.getMenus().then((menus) {
        // selalu urut A-Z
        menus.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        allMenus = menus;
        filteredMenus = menus;
        return menus;
      });
    });
  }

  Future<void> loadUserData() async {
    try {
      final data = await AuthenticationAPI.getProfile();
      setState(() => userData = data);
    } catch (e) {
      debugPrint("Error load user: $e");
    }
  }

  void filterMenus(String keyword) {
    if (keyword.isEmpty) {
      setState(() => filteredMenus = allMenus);
    } else {
      setState(() {
        filteredMenus = allMenus
            .where(
              (menu) =>
                  menu.name.toLowerCase().contains(keyword.toLowerCase()) ||
                  menu.description.toLowerCase().contains(
                    keyword.toLowerCase(),
                  ),
            )
            .toList();
      });
    }

    // tetap urut A-Z setelah filter
    filteredMenus.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          await AddMenuDialog.show(context);
          loadMenus();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await loadUserData();
            loadMenus();
          },
          child: ListView(
            children: [
              // Header User
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    const CircleAvatar(backgroundColor: Colors.grey),
                    const SizedBox(width: 10),
                    Text(
                      "Hi, ${userData?.data?.name ?? ''}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Section Title
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Penawaran Spesial",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              // Carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  aspectRatio: 16 / 9,
                  onPageChanged: (index, reason) {
                    setState(() => _current = index);
                  },
                ),
                items: imgList.map((item) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),

              // Carousel Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.asMap().entries.map((entry) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _current == entry.key ? 32 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _current == entry.key
                          ? Colors.orange
                          : Colors.grey.withOpacity(0.3),
                    ),
                  );
                }).toList(),
              ),

              // Search bar (tanpa filter icon)
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  onChanged: filterMenus,
                  decoration: InputDecoration(
                    hintText: "Cari menu...",
                    prefixIcon: const Icon(Icons.search, color: Colors.orange),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Section Title
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Menu",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              // Menu List
              MenuPage(
                menus: filteredMenus,
                onTapMenu: (menu) async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailMenu(menu: menu)),
                  );
                  if (result == true) loadMenus();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
