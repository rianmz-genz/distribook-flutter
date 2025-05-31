import 'dart:convert';
import 'package:distribook/api/impl/logger.dart';
import 'package:distribook/api/index.dart';
import 'package:distribook/components/Snackbar.dart';
import 'package:distribook/requests/create_loan_request_request.dart';
import 'package:distribook/responses/get_books_response.dart';
import 'package:flutter/material.dart';
import 'package:distribook/responses/get_self_response.dart';
import 'package:distribook/responses/get_loan_request_response.dart';

Future<bool> processCreateLoanRequest(
    {required BuildContext context,
    required CreateLoanRequestRequest createLoanRequestRequest}) async {
  try {
    await httpClient.loadBaseUrl();
    final response = await httpClient.post(
        "/loanrequests", createLoanRequestRequest.toJson());
    final decoded = jsonDecode(response.body);
    print(decoded);
    return true;
  } on HtmlResponseException catch (e, stackTrace) {
    logError(e.htmlContent, stackTrace, context: 'fetchBook', route: '/loanrequests');
    throw Exception('Received HTML instead of JSON');
  } catch (error, stackTrace) {
    logError(error, stackTrace, context: 'fetchBook', route: '/loanrequests');
    showErrorSnackbar(context, "Error fetching loanrequests: ${error.toString()}");
    rethrow;
  }
}


Future<SelfResponse> fetchSelf({required BuildContext context}) async {
  try {
    await httpClient.loadBaseUrl();
    final response = await httpClient.get("/user");
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

Future<List<Book>> fetchBook({required BuildContext context}) async {
  try {
    await httpClient.loadBaseUrl();
    final response = await httpClient.get("/books");
    final decoded = jsonDecode(response.body);

    if (decoded['status'] == 'success') {
      final List data = decoded['data'];
      return data.map((item) => Book.fromJson(item)).toList();
    } else {
      showErrorSnackbar(context, "Gagal mengambil buku: ${decoded['message']}");
      return [];
    }
  } on HtmlResponseException catch (e, stackTrace) {
    logError(e.htmlContent, stackTrace, context: 'fetchBook', route: '/books');
    throw Exception('Received HTML instead of JSON');
  } catch (error, stackTrace) {
    logError(error, stackTrace, context: 'fetchBook', route: '/books');
    showErrorSnackbar(context, "Error fetching books: ${error.toString()}");
    rethrow;
  }
}


Future<List<LoanRequest>> fetchLoanRequests({required BuildContext context}) async {
  try {
    await httpClient.loadBaseUrl();
    final response = await httpClient.get("/loanrequests");
    final decoded = jsonDecode(response.body);

    if (decoded['status'] == 'success') {
      final List data = decoded['data'];
      return data.map((item) => LoanRequest.fromJson(item)).toList();
    } else {
      showErrorSnackbar(context, "Gagal mengambil data peminjaman: ${decoded['message']}");
      return [];
    }
  } catch (error, stackTrace) {
    logError(error, stackTrace, context: 'fetchLoanRequests', route: '/loan-requests');
    showErrorSnackbar(context, "Error fetching loan requests: ${error.toString()}");
    rethrow;
  }
}
