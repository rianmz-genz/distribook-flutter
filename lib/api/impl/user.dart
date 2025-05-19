import 'dart:convert';
import 'package:distribook/api/impl/logger.dart';
import 'package:distribook/api/index.dart';
import 'package:distribook/components/Snackbar.dart';
import 'package:flutter/material.dart';
import 'package:distribook/responses/get_self_response.dart';

Future<SelfResponse> fetchSelf({required BuildContext context}) async {
  try {
    await httpClient.loadBaseUrl();
    final response = await httpClient.post("/self", {});
    final decoded = jsonDecode(response.body);

    SelfResponse selfResponse = SelfResponse.fromJson(decoded);
    loggingAxiom([decoded]);
    return selfResponse;
  } on HtmlResponseException catch (e, stackTrace) {
    logError(e.htmlContent, stackTrace, context: 'fetchSelf', route: '/self');
    // Lempar kembali atau bisa juga return dummy jika ingin safe return
    throw Exception('Received HTML instead of JSON');
  } catch (error, stackTrace) {
    logError(error, stackTrace, context: 'fetchSelf', route: '/self');
    showErrorSnackbar(context, "Error fetching self: ${error.toString()}");
    rethrow;
  }
}
