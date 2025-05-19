import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:distribook/api/impl/attendance.dart';
import 'package:http/http.dart' as http;
import 'package:distribook/components/Navbar.dart';
import 'package:distribook/screens/AttendanceSuccessScreen.dart';

class TakeAttendanceScreen extends StatefulWidget {
  final String title;
  final String address;

  const TakeAttendanceScreen({
    super.key,
    required this.title,
    required this.address,
  });

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  String? imageBase64;
  XFile? imageFile; // <-- Tambahkan ini

  final Color primaryColor = const Color(0xFF388E3C); // Hijau tua
  final Color secondaryColor = const Color(0xFFC8E6C9); // Hijau muda
  bool isSubmitting = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        imageBase64 = base64Encode(bytes);
        imageFile = image; // <-- Simpan file asli juga
      });
    }
  }

  void onSubmit() async {
    if (isSubmitting) return;

    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan ambil foto terlebih dahulu.")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final latitude = prefs.getString('lat');
    final longitude = prefs.getString('long');

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lokasi tidak ditemukan.")),
      );
      return;
    }

    setState(() => isSubmitting = true); // 🔄 Mulai loading

    final fields = {
      'latitude': latitude,
      'longitude': longitude,
    };

    final multipartFile = await http.MultipartFile.fromPath(
      'photo',
      imageFile!.path,
      filename: imageFile!.name,
    );

    final success = await processAttendance(
      context: context,
      fields: fields,
      files: [multipartFile],
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => AttendanceSuccessScreen(
                  status: widget.title,
                )),
      );
    }
      setState(() => isSubmitting = false); // ✅ Stop loading
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: primaryColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Navbar()),
                        );
                      },
                    ),
                    SectionTitle(title: widget.title),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/icons/absensiillustration.png', // Pastikan gambar ini tersedia
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: "Alamat"),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.address,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: "Foto Kehadiran"),
              const SizedBox(height: 10),
              Container(
                width: width,
                height: width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                clipBehavior: Clip.antiAlias,
                child: imageBase64 != null
                    ? Image.memory(
                        base64Decode(imageBase64!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                              child: Text("Gagal memuat gambar"));
                        },
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 64, color: Colors.grey),
                      ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label:
                      Text(imageBase64 != null ? "Ubah Foto" : "Ambil Foto"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF64748B), // slate-600
                    foregroundColor: Colors.white, // teks/icon putih
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: onSubmit,
                    icon: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.check_circle_outline),
                    label: Text(isSubmitting ? "Mengirim..." : widget.title),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
