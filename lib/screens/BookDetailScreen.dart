import 'package:distribook/components/Navbar.dart';
import 'package:distribook/components/Snackbar.dart';
import 'package:distribook/helpers/index.dart';
import 'package:distribook/requests/create_loan_request_request.dart';
import 'package:distribook/screens/LoanRequestScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../responses/get_books_response.dart';
import 'package:distribook/api/impl/user.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  void _showPinjamDialog(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (selectedDate != null) {
      final formatted = DateFormat('yyyy-MM-dd ').format(selectedDate);

      bool success = await processCreateLoanRequest(
          context: context,
          createLoanRequestRequest: CreateLoanRequestRequest(
              bookId: book.id, requestDate: formatted));

      if (success) {
        showSuccessSnackbar(context, 'Berhasil mengajukan meminjam buku pada: $formatted');
        navigateTo(context, Navbar(initialIndex: 1,));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                book.coverImage,
                height: 250,
                errorBuilder: (ctx, _, __) =>
                    Icon(Icons.broken_image, size: 100),
              ),
            ),
            const SizedBox(height: 16),
            Text(book.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Pengarang: ${book.author}"),
            Text("Penerbit: ${book.publisher}"),
            Text("Tahun Terbit: ${book.yearPublished}"),
            Text("Stok Total: ${book.totalStock}"),
            Text("Stok Tersedia: ${book.availableStock}"),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showPinjamDialog(context),
                icon: Icon(Icons.date_range),
                label: Text("Pinjam Buku"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
