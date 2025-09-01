import 'package:flutter/material.dart';
import 'package:tugas16_flutter/model/user_model.dart';
import 'package:tugas16_flutter/services/api_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String id = "/Home";
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GetUserModel? userData;
  bool isLoading = true;
  final TextEditingController _nameController = TextEditingController();
  final int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await AuthenticationAPI.getProfile();
      setState(() {
        userData = data;
        _nameController.text = userData?.data?.name ?? '';
      });
    } catch (e) {
      print("Error load user: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.grey),
                  SizedBox(width: 10),
                  Text(
                    "hi, ${userData?.data?.name ?? ''}",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              height: 210,
              width: 450,
              decoration: const BoxDecoration(
                color: Color(0xFF0C1C3C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 27,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Pilihan Lapangan!",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 1,
                          ),
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C2C4C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: "Cari Lapangan di Jakarta",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              icon: Padding(
                                padding: EdgeInsets.all(20),
                                child: Icon(Icons.search, color: Colors.white),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // body: Padding(
      //   padding: EdgeInsets.all(16),
      //   child: Column(children: [Container(height: 150, color: Colors.blue)]),
      // ),

      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.grey[50],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: const Color(0xFF1A2A80),
      //   unselectedItemColor: Colors.grey,
      //   onTap: (index) => setState(() => _selectedIndex = index),
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Tentang'),
      //   ],
      // ),
    );
  }
}
