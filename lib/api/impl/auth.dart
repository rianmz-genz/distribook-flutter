import 'dart:convert';

import 'package:distribook/api/index.dart';
import 'package:distribook/components/Snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:distribook/requests/login_request.dart';

Future<bool> processLogin(
    BuildContext context, LoginRequest loginRequest) async {
  try {
    await httpClient.loadBaseUrl();

    final response = await httpClient.postMultipart(
      "/auth/login",
      loginRequest.toJson(),
    );

    final body = jsonDecode(response.body);

    // Tangani jika login gagal berdasarkan isi respons
    if (body is Map && body['status'] == 'failed') {
      final message = body['message'] ?? 'Login gagal.';
      // Tampilkan pesan error (optional)
      showErrorSnackbar(context, "Terjadi kesalahan: $message");

      return false;
    }

    final setCookie = response.headers['set-cookie'];
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (setCookie != null) {
      final sessionIdMatch =
          RegExp(r'session_id=([^;]+)').firstMatch(setCookie);
      if (sessionIdMatch != null) {
        final sessionId = sessionIdMatch.group(1);
        await prefs.setString("session_id", sessionId!);
      }
    }

    prefs.setBool("isLoggedIn", true);
    prefs.setString("db", loginRequest.database);

    return true;
  } catch (error) {
    // Tangani error jaringan/parsing
    showErrorSnackbar(context, "Terjadi kesalahan: $error");
    return false;
  }
}

Future<bool> processLogout(BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response =
        await httpClient.get("/auth/logout/${prefs.getString("session_id")}");
    if (response.statusCode == 200) {
      return true;
    } else {
      showErrorSnackbar(context, "Update Profile failed: ${response.body}");
      throw Exception("Gagal mengambil data");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error during Update Profile: $e");
    rethrow;
  }
}
