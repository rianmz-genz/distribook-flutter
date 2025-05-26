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
      "/login",
      loginRequest.toJson(),
    );

    final body = jsonDecode(response.body);

    if (body is Map && body['status'] == 'failed') {
      final message = body['message'] ?? 'Login gagal.';
      showErrorSnackbar(context, "Terjadi kesalahan: $message");
      return false;
    }

    final token = body['data']['token'];
    if (token == null) {
      showErrorSnackbar(context, "Token tidak ditemukan dalam respons.");
      return false;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    await prefs.setBool("isLoggedIn", true);

    return true;
  } catch (error) {
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
