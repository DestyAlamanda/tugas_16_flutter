import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/model/menu_model.dart';
import 'package:tugas16_flutter/model/user_model.dart';
import 'package:tugas16_flutter/views/menu_page.dart';

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
  final TextEditingController searchCtrl = TextEditingController();
  GetUserModel? userData;
  bool isLoading = true;

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
        allMenus = menus;
        filteredMenus = menus;
        return menus;
      });
    });
  }

  Future<void> loadUserData() async {
    setState(() => isLoading = true);

    try {
      final data = await AuthenticationAPI.getProfile();
      setState(() {
        userData = data;
      });
    } catch (e) {
      debugPrint("Error load user: $e");
    } finally {
      setState(() => isLoading = false);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // biar bisa scroll semua isi
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header User
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchCtrl,
                  onChanged: filterMenus,
                  decoration: InputDecoration(
                    hintText: "Cari menu favoritmu...",
                    prefixIcon: const Icon(Icons.search, color: Colors.orange),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  aspectRatio: 16 / 9,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
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

              // Custom Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.asMap().entries.map((entry) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == entry.key
                          ? Colors.blueAccent
                          : Colors.grey,
                    ),
                  );
                }).toList(),
              ),

              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Menu",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              /// Panggil MenuPage disini
              const MenuPage(),
            ],
          ),
        ),
      ),
    );
  }
}
