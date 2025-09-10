// import 'package:flutter/material.dart';
// import 'package:tugas16_flutter/model/menu_model.dart';
// import 'package:tugas16_flutter/views/menu/add_menu.dart';
// import 'package:tugas16_flutter/views/menu/detail_menu.dart';
// import 'package:tugas16_flutter/views/menu/menu_page.dart';

// class FullMenu extends StatefulWidget {
//   final List<MenuModel> allMenus;
//   final VoidCallback onRefresh;

//   const FullMenu({super.key, required this.allMenus, required this.onRefresh});

//   @override
//   State<FullMenu> createState() => _FullMenuState();
// }

// class _FullMenuState extends State<FullMenu> {
//   List<MenuModel> filteredMenus = [];
//   final TextEditingController searchController = TextEditingController();

//   String selectedFilter = "A-Z"; // default filter

//   @override
//   void initState() {
//     super.initState();
//     filteredMenus = List.from(widget.allMenus);
//     applyFilter();
//   }

//   void filterMenus(String keyword) {
//     List<MenuModel> temp = widget.allMenus.where((menu) {
//       return menu.name.toLowerCase().contains(keyword.toLowerCase()) ||
//           menu.description.toLowerCase().contains(keyword.toLowerCase());
//     }).toList();

//     setState(() {
//       filteredMenus = temp;
//       applyFilter(); // tetap terurut sesuai filter
//     });
//   }

//   void applyFilter() {
//     setState(() {
//       if (selectedFilter == "A-Z") {
//         filteredMenus.sort(
//           (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
//         );
//       } else if (selectedFilter == "Harga Termurah") {
//         filteredMenus.sort((a, b) => a.price.compareTo(b.price));
//       } else if (selectedFilter == "Harga Tertinggi") {
//         filteredMenus.sort((a, b) => b.price.compareTo(a.price));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Semua Menu"),
//         backgroundColor: Colors.orange,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               widget.onRefresh();
//               setState(() {
//                 filteredMenus = List.from(widget.allMenus);
//                 applyFilter();
//               });
//             },
//           ),
//         ],
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 // Search bar
//                 Expanded(
//                   child: TextField(
//                     controller: searchController,
//                     onChanged: filterMenus,
//                     decoration: InputDecoration(
//                       hintText: "Cari menu...",
//                       prefixIcon: const Icon(
//                         Icons.search,
//                         color: Colors.orange,
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),

//                 // Filter icon (popup menu)
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.orange[50],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: PopupMenuButton<String>(
//                     icon: const Icon(Icons.tune_rounded, color: Colors.orange),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     onSelected: (value) {
//                       setState(() {
//                         selectedFilter = value;
//                         applyFilter();
//                       });
//                     },
//                     itemBuilder: (context) => const [
//                       PopupMenuItem(value: "A-Z", child: Text("A-Z")),
//                       PopupMenuItem(
//                         value: "Harga Termurah",
//                         child: Text("Harga Termurah"),
//                       ),
//                       PopupMenuItem(
//                         value: "Harga Tertinggi",
//                         child: Text("Harga Tertinggi"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 12),

//           MenuPage(
//             menus: filteredMenus,
//             onTapMenu: (menu) async {
//               final result = await Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => DetailMenu(menu: menu)),
//               );
//               if (result == true) widget.onRefresh();
//             },
//           ),
//         ],
//       ),

//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.orange,
//         onPressed: () async {
//           await AddMenuDialog.show(context);
//           widget.onRefresh();
//           setState(() {
//             filteredMenus = List.from(widget.allMenus);
//             applyFilter();
//           });
//         },
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }
