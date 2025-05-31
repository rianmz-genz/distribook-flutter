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
                const SizedBox(height: 50),
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
               
              ],
            ),
          ),
          const SizedBox(height: 20),
         
         
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
