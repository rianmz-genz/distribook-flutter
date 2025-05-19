import 'dart:convert';
import 'package:distribook/api/impl/logger.dart';
import 'package:distribook/api/index.dart';
import 'package:distribook/components/Snackbar.dart';
import 'package:flutter/material.dart';
import 'package:distribook/responses/get_announcement_response.dart';

Future<List<AnnouncementResponse>> fetchAnnouncement(
    {required BuildContext context}) async {
  try {
    await httpClient.loadBaseUrl();
    final response = await httpClient.post("/pengumuman", {});
    final List<dynamic> jsonList = jsonDecode(response.body);
    final announcements = announcementListFromJson(jsonList);
    return announcements;
  } on HtmlResponseException catch (e, stackTrace) {
    logError(e.htmlContent, stackTrace,
        context: 'fetchAnnouncement', route: '/pengumuman');
    throw Exception('Received HTML instead of JSON');
  } catch (error, stackTrace) {
    logError(error, stackTrace,
        context: 'fetchAnnouncement', route: '/pengumuman');
    showErrorSnackbar(context, "Error fetching self: ${error.toString()}");
    rethrow;
  }
}
