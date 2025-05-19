import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:distribook/api/impl/user.dart';
import 'package:distribook/components/ProfileImage.dart';
import 'package:distribook/responses/get_self_response.dart'; // Import model SelfResponse

class CardHomePage extends StatefulWidget {
  const CardHomePage({super.key});

  @override
  State<CardHomePage> createState() => _CardHomePageState();
}

class _CardHomePageState extends State<CardHomePage> {
  SelfResponse? selfResponse;

  @override
  void initState() {
    super.initState();
    performGetSelf();
  }

  void performGetSelf() async {
    final result =
        await fetchSelf(context: context); // pastikan return SelfResponse
    setState(() {
      selfResponse = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = selfResponse?.data;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF36454F), Color(0xFF014D4E)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: data == null
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 150,
                            height: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.company,
                            style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(data.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
            ),
            Column(children: [
              ProfileImage(
                base64Image: selfResponse?.data.employee?.image ?? "",
              )
            ])
          ],
        ),
      ),
    );
  }
}
