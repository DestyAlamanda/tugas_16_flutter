// import 'package:flutter/material.dart';
// import 'package:tugas16_flutter/model/menu_model.dart';

// class MenuCard extends StatelessWidget {
//   final MenuModel menu;
//   final VoidCallback onOrder;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;

//   const MenuCard({
//     super.key,
//     required this.menu,
//     required this.onOrder,
//     this.onEdit,
//     this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Gambar atau ikon default
//             if (menu.image != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   menu.image!,
//                   width: 80,
//                   height: 80,
//                   fit: BoxFit.cover,
//                 ),
//               )
//             else
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: Colors.indigo[100],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(Icons.restaurant, size: 40, color: Colors.indigo),
//               ),
//             SizedBox(width: 16),

//             // Info menu
//             // Expanded(
//             //   child: Column(
//             //     crossAxisAlignment: CrossAxisAlignment.start,
//             //     children: [
//             //       Text(
//             //         menu.name,
//             //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             //       ),
//             //       SizedBox(height: 6),
//             //       Text(
//             //         menu.description,
//             //         style: TextStyle(color: Colors.grey[700]),
//             //       ),
//             //       SizedBox(height: 10),
//             //       Text(
//             //         "Rp ${menu.price}",
//             //         style: TextStyle(
//             //           fontSize: 16,
//             //           fontWeight: FontWeight.bold,
//             //           color: Colors.indigo,
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),

//             // Aksi edit/delete
//             // Column(
//             //   children: [
//             //     IconButton(
//             //       icon: Icon(Icons.edit, color: Colors.blue),
//             //       onPressed: onEdit,
//             //     ),
//             //     IconButton(
//             //       icon: Icon(Icons.delete, color: Colors.red),
//             //       onPressed: onDelete,
//             //     ),
//             //     ElevatedButton(onPressed: onOrder, child: Text("Pesan")),
//             //   ],
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
