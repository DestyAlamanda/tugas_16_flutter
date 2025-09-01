// import 'package:flutter/material.dart';
// import 'package:tugas16_flutter/model/menu_model.dart';
// import 'package:tugas16_flutter/services/api_service.dart';

// class MenuPage extends StatefulWidget {
//   const MenuPage({super.key});
//   static const String id = "/menu";
//   @override
//   State<MenuPage> createState() => _MenuPageState();
// }

// class _MenuPageState extends State<MenuPage> {
//   late Future<List<MenuModel>> futureMenus;

//   @override
//   void initState() {
//     super.initState();
//     futureMenus = AuthenticationAPI.getMenus();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<MenuModel>>(
//       future: futureMenus,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(color: Colors.indigo),
//           );
//         } else if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}"));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text("Belum ada menu tersedia"));
//         }

//         final menus = snapshot.data!;
//         return ListView.builder(
//           shrinkWrap: true, // biar bisa digabung di Column
//           physics:
//               const NeverScrollableScrollPhysics(), // biar scrollnya ikut parent
//           padding: const EdgeInsets.all(16),
//           itemCount: menus.length,
//           itemBuilder: (context, index) {
//             final menu = menus[index];
//             return Card(
//               margin: const EdgeInsets.only(bottom: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 3,
//               child: ListTile(
//                 leading: const Icon(Icons.fastfood, color: Colors.indigo),
//                 title: Text(menu.name ?? "Tanpa nama"),
//                 subtitle: Text("Harga: Rp${menu.price ?? 0}"),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
