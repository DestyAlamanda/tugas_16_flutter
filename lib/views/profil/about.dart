import 'package:flutter/material.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/auth/logout.dart';
import 'package:tugas16_flutter/model/user_model.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  GetUserModel? userData;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final data = await AuthenticationAPI.getProfile();
      setState(() => userData = data);
    } catch (e) {
      debugPrint("Error load user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section with Profile
              SizedBox(
                width: double.infinity,
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter,
                //     colors: [Colors.orange.shade600, Colors.orange.shade500],
                //   ),
                // ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Profile Avatar
                    Container(
                      // decoration: BoxDecoration(
                      //   shape: BoxShape.circle,
                      //   border: Border.all(color: Colors.white, width: 4),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.black.withOpacity(0.1),
                      //       blurRadius: 20,
                      //       offset: const Offset(0, 8),
                      //     ),
                      //   ],
                      // ),
                      child: CircleAvatar(
                        radius: 60,
                        // backgroundColor: Colors.white,
                        child: Container(
                          width: 96,
                          height: 96,
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
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // User Info
                    Text(
                      userData?.data?.name ?? 'Loading...',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.orange,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        userData?.data?.email ?? '',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // Settings Section
              Container(
                padding: const EdgeInsets.all(24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSetting(
                        Icons.person_outline_rounded,
                        'Profile Settings',
                        'Manage your account',
                        Colors.orange.shade600,
                        true,
                      ),
                      _divider(),
                      _buildSetting(
                        Icons.info_outline_rounded,
                        'App Information',
                        'Version and about',
                        Colors.blue.shade600,
                        false,
                      ),
                      _divider(),
                      _buildSetting(
                        Icons.logout_rounded,
                        'Sign Out',
                        'Sign out from account',
                        Colors.red.shade600,
                        false,
                        onTap: () => LogOutButton.handleLogout(context),
                      ),
                    ],
                  ),
                ),
              ),

              // App Info Footer
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      "Restaurant App",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.grey.shade200,
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildSetting(
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
    bool isFirst, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(20) : Radius.zero,
          bottom: title == 'Sign Out' ? const Radius.circular(20) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: iconColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
