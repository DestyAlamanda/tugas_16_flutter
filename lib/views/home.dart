import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/model/menu_model.dart';
import 'package:tugas16_flutter/model/user_model.dart';
import 'package:tugas16_flutter/views/menu/add_menu.dart';
import 'package:tugas16_flutter/views/menu/detail_menu.dart';
import 'package:tugas16_flutter/views/menu/menu_page.dart';
import 'package:tugas16_flutter/widgets/section_title.dart';

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
    'assets/images/Screenshot 2025-09-12 040148.png',
    'assets/images/Seblak7.png',
    'assets/images/ayam_geprek.png',
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
    filteredMenus.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          await AddMenuDialog.show(context);
          loadMenus();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.orange,
        toolbarHeight: 170,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade600,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Hai, ${userData?.data?.name ?? ''}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 17),
            TextField(
              controller: searchController,
              onChanged: filterMenus,
              decoration: InputDecoration(
                hintText: "Cari menu...",
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await loadUserData();
          loadMenus();
        },
        child: ListView(
          children: [
            // Penawaran Spesial
            sectionTitle("Penawaran Spesial"),
            SizedBox(height: 15),
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

            // Menu Pilihan Section Title
            sectionTitle("Menu Pilihan"),

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
    );
  }
}
