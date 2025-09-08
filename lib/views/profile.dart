// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tugas16_flutter/api/api_service.dart';
// import 'package:tugas16_flutter/auth/login.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   String? userName;
//   String? userEmail;
//   File? localImage;
//   bool loading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }

//   Future<void> loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final name = prefs.getString('user_name');
//     final email = prefs.getString('user_email');

//     if (!mounted) return;
//     setState(() {
//       userName = name;
//       userEmail = email;
//       loading = false;
//     });
//   }

//   void confirmLogout() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text("Konfirmasi Logout"),
//         content: Text("Apakah Anda yakin ingin keluar?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Batal"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await AuthenticationAPI.clearToken();

//               final prefs = await SharedPreferences.getInstance();
//               await prefs.remove('user_name');
//               await prefs.remove('user_email');

//               if (!mounted) return;
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => LoginScreen()),
//               );
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: Text("Logout"),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> pickLocalImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       if (!mounted) return;
//       setState(() {
//         localImage = File(picked.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profil & Tentang"),
//         actions: [
//           IconButton(onPressed: confirmLogout, icon: Icon(Icons.logout)),
//         ],
//       ),
//       body: loading
//           ? Center(child: CircularProgressIndicator())
//           : ListView(
//               padding: EdgeInsets.all(24),
//               children: [
//                 // Foto profil
//                 Center(
//                   child: GestureDetector(
//                     onTap: pickLocalImage,
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundImage: localImage != null
//                           ? FileImage(localImage!)
//                           : null,
//                       child: localImage == null
//                           ? Icon(Icons.person, size: 50, color: Colors.white)
//                           : null,
//                       backgroundColor: Colors.indigo,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),

//                 // Nama
//                 Center(
//                   child: Text(
//                     userName ?? "-",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),

//                 // Email
//                 Center(
//                   child: Text(
//                     userEmail ?? "-",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 32),

//                 // Tentang Aplikasi
//                 Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 3,
//                   child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Tentang Aplikasi",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           "Aplikasi Reservasi Tempat Makan\n\n"
//                           "Versi: 1.0.0\n"
//                           "Dibuat dengan Flutter.",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
