import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> loggingAxiom(dynamic data) async {
  const axiomDataset = 'spreadhrm';
  const axiomToken = "xaat-fd8c394c-5fb0-4790-b646-7802fb42aa18";

  final ingestUrl = 'https://api.axiom.co/v1/datasets/$axiomDataset/ingest';
  final headers = {
    'Authorization': 'Bearer $axiomToken',
    'Content-Type': 'application/json',
  };
  try {
    final response = await http.post(
      Uri.parse(ingestUrl),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      print('Logging failed: ${response.statusCode} ${response.body}');
    }
  } catch (e) {
    print('Logging error: $e');
  }
}

void logError(Object error, StackTrace stackTrace, {String? context, String? route}) {
  final errorData = {
    'message': error.toString(),
    'stack': stackTrace.toString(),
    'timestamp': DateTime.now().toIso8601String(),
    if (context != null) 'context': context,
    if (route != null) 'route': route,
  };

  loggingAxiom([errorData]);
}