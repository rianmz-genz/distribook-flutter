import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String formatCurrency(int number) {
  return 'Rp. ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(number)}';
}

String mapToQueryParameters(Map<String, dynamic> params) {
  final query = params.entries
      .where(
          (entry) => entry.value != null && entry.value.toString().isNotEmpty)
      .map((entry) =>
          '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}')
      .join('&');

  return query.isNotEmpty ? '?$query' : '';
}

void navigateTo(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => screen),
  );
}