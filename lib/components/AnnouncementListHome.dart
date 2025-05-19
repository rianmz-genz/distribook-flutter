import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:distribook/api/impl/announcement.dart';
import 'package:distribook/responses/get_announcement_response.dart'; // asumsi modelmu di sini

class AnnouncementList extends StatefulWidget {
  final double? height; // opsional, default full screen height
  final int? limit; // opsional, default semua data ditampilkan

  const AnnouncementList({super.key, this.height, this.limit});

  @override
  State<AnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  List<AnnouncementResponse> announcements = [];
  bool isLoading = true; // untuk tanda loading

  @override
  void initState() {
    super.initState();
    getAnnouncement();
  }

  void getAnnouncement() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await fetchAnnouncement(context: context);
      setState(() {
        if (widget.limit != null && widget.limit! < result.length) {
          announcements = result.take(widget.limit!).toList();
        } else {
          announcements = result;
        }
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching announcements: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double defaultHeight = MediaQuery.of(context).size.height * 0.75;

    if (isLoading) {
      return SizedBox(
        height: widget.height ?? defaultHeight,
        child: ListView.builder(
          itemCount: 6, // jumlah skeleton item, bisa disesuaikan
          itemBuilder: (context, index) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SkeletonAnnouncementItem(),
          ),
        ),
      );
    }

    if (announcements.isEmpty) {
      return SizedBox(
        height: widget.height ?? defaultHeight,
        child: const Center(
          child: Text("No announcements available"),
        ),
      );
    }

    return SizedBox(
      height: widget.height ?? defaultHeight,
      child: ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final item = announcements[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Card(
              child: ListTile(
                title: Text(item.authorId),
                subtitle: Text(item.body),
                trailing: Text(
                  formatDate(item.date),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String formatDate(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return "${dateTime.month.toString().padLeft(2, '0')}–${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return "-";
    }
  }
}

// Widget skeleton shimmer untuk list item
class SkeletonAnnouncementItem extends StatelessWidget {
  const SkeletonAnnouncementItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        child: ListTile(
          title: Container(
            width: double.infinity,
            height: 16,
            color: Colors.white,
          ),
          subtitle: Container(
            margin: const EdgeInsets.only(top: 8),
            width: double.infinity,
            height: 14,
            color: Colors.white,
          ),
          trailing: Container(
            width: 40,
            height: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
