import 'dart:async';
import 'package:flutter/material.dart';
import 'package:distribook/components/Navbar.dart';

class AttendanceSuccessScreen extends StatefulWidget {
  final String status; // Contoh: 'Clock In' atau 'Clock Out'

  const AttendanceSuccessScreen({Key? key, required this.status})
      : super(key: key);

  @override
  State<AttendanceSuccessScreen> createState() =>
      _AttendanceSuccessScreenState();
}

class _AttendanceSuccessScreenState extends State<AttendanceSuccessScreen> {
  @override
  void initState() {
    super.initState();

    // Auto-redirect ke HomeScreen setelah 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Navbar()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Full-width image
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/icons/doneAbsensi.png', // Pastikan gambar ini tersedia
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              'Berhasil ${widget.status}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Data kehadiran kamu telah dicatat. Terima kasih!',
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
