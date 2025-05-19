import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:distribook/exceptions/error.dart';
import 'package:distribook/exceptions/exceptions.dart';

class HtmlResponseException implements Exception {
  final String htmlContent;

  HtmlResponseException(this.htmlContent);
}

class HttpClient {
  String baseUrl = '';
  final Duration timeoutDuration = const Duration(seconds: 20);

  HttpClient();

  /// Set baseUrl secara dinamis (misalnya setelah login)
  Future<void> setBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    baseUrl = "$url";
    await prefs.setString('base_url', baseUrl);
  }

  /// Load baseUrl dari SharedPreferences saat aplikasi dimulai
  Future<void> loadBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final rawUrl = prefs.getString('base_url') ?? '';

    if (rawUrl.isNotEmpty) {
      baseUrl = "$rawUrl/api";
    } else {
      baseUrl = '';
    }

    print('Loaded baseUrl: $baseUrl');
  }

  Future<http.Response> get(String endpoint,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response =
        await http.get(url, headers: headers).timeout(timeoutDuration);
    _handleResponse(response);
    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> fields,
      {List<http.MultipartFile>? files}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getInitHeaders();
      headers['Content-Type'] = 'application/json';

      final response = await http
          .post(
            url,
            headers: headers,
            body: jsonEncode(fields),
          )
          .timeout(timeoutDuration);

      _handleResponse(response);
      return response;
    } catch (error, stackTrace) {
      _handleError(error, stackTrace, context: 'POST $endpoint');
      rethrow;
    }
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> fields,
      {List<http.MultipartFile>? files}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getInitHeaders();
      headers['Content-Type'] = 'application/json';

      final response = await http
          .put(
            url,
            headers: headers,
            body: jsonEncode(fields),
          )
          .timeout(timeoutDuration);

      _handleResponse(response);
      return response;
    } catch (error, stackTrace) {
      _handleError(error, stackTrace, context: 'PUT $endpoint');
      rethrow;
    }
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http
        .delete(url, headers: await _getInitHeaders())
        .timeout(timeoutDuration);
    _handleResponse(response);
    return response;
  }

  Future<http.Response> postMultipart(
      String endpoint, Map<String, dynamic> fields,
      {List<http.MultipartFile>? files}) async {
    return execMultipart("POST", endpoint, fields, files: files);
  }

  Future<http.Response> putMultipart(
      String endpoint, Map<String, dynamic> fields,
      {List<http.MultipartFile>? files}) async {
    return execMultipart("PUT", endpoint, fields, files: files);
  }

  Future<http.Response> execMultipart(
      String method, String endpoint, Map<String, dynamic> fields,
      {List<http.MultipartFile>? files}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest(method, url);

      request.headers.addAll(await _getInitHeaders());
      request.headers['Content-Type'] = 'multipart/form-data';

      fields.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (files != null && files.isNotEmpty) {
        request.files.addAll(files);
      }

      final streamedResponse = await request.send().timeout(timeoutDuration);
      final response = await http.Response.fromStream(streamedResponse);

      _handleResponse(response);
      return response;
    } catch (error, stackTrace) {
      _handleError(error, stackTrace, context: '$method Multipart $endpoint');
      rethrow;
    }
  }

  void _handleError(dynamic error, StackTrace stackTrace, {String? context}) {
    String errorMessage = ErrorHandler.handleError(error);
    ErrorHandler.logError(error, stackTrace, context: context);
    if (error is HtmlResponseException) {
      throw error;
    }
    throw Exception(errorMessage);
  }

  void _handleResponse(http.Response response) {
    print("Status Code: ${response.statusCode}");
    print("Headers: ${response.headers}");

    final contentType = response.headers['content-type'] ?? '';
    final isHtml = contentType.contains('text/html') ||
        response.body.startsWith('<!DOCTYPE html') ||
        response.body.startsWith('<html');

    if (isHtml) {
      final html = utf8.decode(response.bodyBytes);
      throw HtmlResponseException(html);
    }

    print("Response Body: ${response.body}");

    if (response.statusCode >= 400 && response.statusCode < 500) {
      throw UnauthorizedException("Unauthorized request");
    } else if (response.statusCode >= 500) {
      throw ServerException("Server error");
    }
  }

  Future<Map<String, String>> _getInitHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString("session_id");
    String? token = prefs.getString("token");
    print('session_id=$sessionId');
    Map<String, String> headers = {};
    if (sessionId != null) {
      headers['Cookie'] = 'session_id=$sessionId';
    }
    if (token != null) {
      headers['Authorization'] = "Bearer $token";
    }
    return headers;
  }
}

// Gunakan instance ini
final httpClient = HttpClient();

class Prefs {
  static Future<int> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    int uid = prefs.getInt("uid")!;
    return uid;
  }
}
