import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:distribook/api/impl/user.dart';
import 'package:distribook/components/ProfileImage.dart';
import 'package:distribook/helpers/index.dart';
import 'package:distribook/responses/get_self_response.dart';
import 'package:distribook/screens/LoginScreen.dart';
import 'package:distribook/screens/NextVersionFeatureScreen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SelfResponse? selfResponse;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final result = await fetchSelf(context: context);
    setState(() {
      selfResponse = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = selfResponse;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Account'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                // user == null
                //     ? Shimmer.fromColors(
                //         baseColor: Colors.grey[300]!,
                //         highlightColor: Colors.grey[100]!,
                //         child: const CircleAvatar(
                //           radius: 40,
                //           backgroundColor: Colors.white,
                //         ),
                //       )
                //     : ProfileImage(
                //         base64Image: user.employee?.image ?? '',
                //       ),
                const SizedBox(height: 8),
                user == null
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 80,
                          height: 16,
                          color: Colors.grey[100]!,
                        ),
                      )
                    : Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                TextButton(
                  onPressed: () {
                    navigateTo(context, NextVersionFeatureScreen());
                  },
                  child: const Text(
                    'Change Profile Image',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'User Settings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              navigateTo(context, NextVersionFeatureScreen());
            },
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: const Text(
                'Data Profil',
                style: TextStyle(color: Colors.black),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black,
              ),
            ),
          ),
          const Divider(),
          InkWell(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();

              // Simpan base_url dan db sebelum clear
              final savedBaseUrl = prefs.getString('base_url');
              final savedDbName = prefs.getString('db');

              // Hapus semua
              await prefs.clear();

              // Restore base_url dan db
              if (savedBaseUrl != null) {
                await prefs.setString('base_url', savedBaseUrl);
              }
              if (savedDbName != null) {
                await prefs.setString('db', savedDbName);
              }

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.logout, color: Colors.white),
              ),
              title: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.black),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
