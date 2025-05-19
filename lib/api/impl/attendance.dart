import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:distribook/api/index.dart';
import 'package:distribook/components/Snackbar.dart';
import 'package:distribook/responses/get_today_attendance_response.dart';
import 'package:http/http.dart' as http;

Future<TodayAttendanceResponse> fetchTodayAttendance(
    {required BuildContext context}) async {
  try {
    await httpClient.loadBaseUrl();
    final response = await httpClient.post("/attendance/today/", {});

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData.isEmpty)
        return TodayAttendanceResponse(
            id: 0, checkIn: "-", checkOut: "-", name: "-");
      TodayAttendanceResponse todayAttendanceResponse =
          TodayAttendanceResponse.fromJson(responseData[0]);
      return todayAttendanceResponse;
    } else {
      throw Exception("Failed to fetch");
    }
  } catch (error) {
    showErrorSnackbar(context, "Error: $error");
    rethrow;
  }
}

Future<bool> processAttendance({
  required BuildContext context,
  required Map<String, dynamic> fields,
  required List<http.MultipartFile> files,
}) async {
  try {
    await httpClient.loadBaseUrl();
    final response = await httpClient.postMultipart(
      "/attendance",
      fields,
      files: files,
    );
    final body = jsonDecode(response.body);

    // Tangani jika login gagal berdasarkan isi respons
    if (body is Map && body['status'] == 'failed') {
      final message = body['message'] ?? 'Login gagal.';
      // Tampilkan pesan error (optional)
      showErrorSnackbar(context, "$message");

      return false;
    }
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // Ubah logika sesuai respons dari server
      print(responseData);
      return true;
    } else {
      showErrorSnackbar(context, "Gagal mengirim kehadiran");

      return false;
    }
  } catch (error) {
    showErrorSnackbar(context, "$error");
    return false;
  }
}
