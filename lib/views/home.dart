import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/model/user_model.dart';
import 'package:tugas16_flutter/views/menu_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String id = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
