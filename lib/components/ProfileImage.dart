import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String? base64Image;

  const ProfileImage({super.key, this.base64Image});

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (base64Image != null && base64Image!.isNotEmpty) {
      try {
        imageBytes = base64Decode(base64Image!);
      } catch (e) {
        // Optional: log error decoding
        print('Failed to decode base64 image: $e');
      }
    }

    return CircleAvatar(
      radius: 35,
      backgroundImage: imageBytes != null ? MemoryImage(imageBytes) : null,
      child: imageBytes == null
          ? const Icon(
              Icons.person,
              size: 35,
              color: Colors.white,
            )
          : null,
      backgroundColor: imageBytes == null ? Colors.grey : null,
    );
  }
}
