import 'package:distribook/api/index.dart';
import 'package:distribook/exceptions/exceptions.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static String handleError(dynamic error) {
    String errorMessage;

    if (error is NetworkException) {
      errorMessage = error.message;
    } else if (error is HtmlResponseException) {
      errorMessage = "Html";
    } else if (error is TimeoutException) {
      errorMessage = error.message;
    } else if (error is ServerException) {
      errorMessage = error.message;
    } else if (error is UnauthorizedException) {
      errorMessage = error.message;
    } else if (error is FormatException) {
      errorMessage = "Data format error";
    } else if (error is Exception) {
      errorMessage = "An unexpected error occurred: ${error.toString()}";
    } else {
      errorMessage = "Unknown error occurred";
    }

    return errorMessage;
  }

  static void logError(dynamic error, StackTrace stackTrace,
      {String? context}) {
    debugPrint("Error occurred in context: $context");
    debugPrint("Error: $error");
    debugPrint("Stack Trace: $stackTrace");
  }
}
