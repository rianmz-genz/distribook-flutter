import 'package:distribook/api/impl/user.dart';
import 'package:distribook/constants/index.dart';
import 'package:distribook/responses/get_books_response.dart';
import 'package:flutter/material.dart';
import 'package:distribook/components/CardHomePage.dart';
import 'package:distribook/components/CustomTextField.dart'; // pastikan import komponen ini

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
    searchController.addListener(_filterBooks);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void initData() async {
    try {
      final result = await fetchBook(context: context);
      setState(() {
        books = result;
        filteredBooks = result;
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  void _filterBooks() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredBooks = books.where((book) {
        final titleLower = book.title.toLowerCase();
        final authorLower = (book.author ?? '').toLowerCase();
        return titleLower.contains(query) || authorLower.contains(query);
      }).toList();
    });
  }

  Future<void> refreshData() async {
    try {
      final result = await fetchBook(context: context);
      setState(() {
        books = result;
        filteredBooks = result;
      });
      _filterBooks(); // re-filter setelah refresh
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data buku')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: BACKGROUND,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            CardHomePage(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Daftar Buku",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomTextField(
                controller: searchController,
                labelText: 'Cari berdasarkan judul atau pengarang',
                keyboardType: TextInputType.text,
                validator: null,
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RefreshIndicator(
                        onRefresh: refreshData,
                        child: GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 600 ? 4 : 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: filteredBooks.length,
                          itemBuilder: (context, index) {
                            final book = filteredBooks[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.grey[100],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 3 / 4,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                      child: Image.network(
                                        book.coverImage,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (ctx, _, __) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              book.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
