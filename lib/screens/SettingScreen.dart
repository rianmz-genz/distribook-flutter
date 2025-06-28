import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:distribook/api/impl/user.dart';
import 'package:distribook/components/ProfileImage.dart';
import 'package:distribook/responses/get_self_response.dart';
import 'package:distribook/screens/LoginScreen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SelfResponse? selfResponse;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final result = await fetchSelf(context: context);
    setState(() {
      selfResponse = result;
      nameCtrl.text = result?.name ?? '';
      emailCtrl.text = result?.email ?? '';
    });
  }

  void _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedName = nameCtrl.text.trim();
    final updatedEmail = emailCtrl.text.trim();
    final updatedPassword = passwordCtrl.text.trim();

    // Lakukan update ke API sesuai implementasi kamu
    final success = await updateSelfProfile(
      name: updatedName,
      email: updatedEmail,
      password: updatedPassword.isNotEmpty ? updatedPassword : null,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Profil berhasil diperbarui' : 'Gagal memperbarui profil'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      _loadProfile();
      passwordCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = selfResponse;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // user == null
            //     ? Shimmer.fromColors(
            //         baseColor: Colors.grey[300]!,
            //         highlightColor: Colors.grey[100]!,
            //         child: const CircleAvatar(radius: 40, backgroundColor: Colors.white),
            //       )
            //     : ProfileImage(base64Image: user.employee?.image ?? ''),
            const SizedBox(height: 20),
            user == null
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(width: 80, height: 16, color: Colors.grey[100]!),
                  )
                : Text(
                    user.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            const SizedBox(height: 20),
            const Divider(),

            /// Sign Out Section
            InkWell(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                final savedBaseUrl = prefs.getString('base_url');
                final savedDbName = prefs.getString('db');
                await prefs.clear();
                if (savedBaseUrl != null) await prefs.setString('base_url', savedBaseUrl);
                if (savedDbName != null) await prefs.setString('db', savedDbName);

                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.logout, color: Colors.white),
                ),
                title: const Text('Sign Out', style: TextStyle(color: Colors.black)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black),
              ),
            ),

            /// Edit Profile Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Edit Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Nama'),
                      validator: (val) => val == null || val.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (val) =>
                          val == null || !val.contains('@') ? 'Masukkan email yang valid' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password (biarkan kosong jika tidak ingin mengubah)',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _updateProfile,
                      icon: const Icon(Icons.save),
                      label: const Text("Simpan Perubahan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simulasi fungsi update profile, ganti dengan API asli kamu
Future<bool> updateSelfProfile({
  required String name,
  required String email,
  String? password,
}) async {
  await Future.delayed(const Duration(seconds: 1)); // simulasi delay
  return true; // anggap berhasil
}
