import 'package:flutter/material.dart';
import 'package:distribook/components/AnnouncementListHome.dart';
import 'package:distribook/components/Navbar.dart';

class AllAnnouncementScreen extends StatefulWidget {
  const AllAnnouncementScreen({super.key});

  @override
  State<AllAnnouncementScreen> createState() => _AllAnnouncementScreenState();
}

class _AllAnnouncementScreenState extends State<AllAnnouncementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.green),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Navbar()),
                    );
                  },
                ),
              ),
              Text(
                'Semua Pengumuman',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8,
              ),
              AnnouncementList()
            ],
          ),
        ),
      ),
    );
  }
}
