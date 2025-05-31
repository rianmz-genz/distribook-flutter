import 'package:distribook/components/CustomTextField.dart';
import 'package:distribook/constants/index.dart';
import 'package:distribook/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:distribook/api/impl/user.dart';
import 'package:distribook/responses/get_loan_request_response.dart';

class LoanRequestScreen extends StatefulWidget {
  const LoanRequestScreen({super.key});

  @override
  State<LoanRequestScreen> createState() => _LoanRequestScreenState();
}

class _LoanRequestScreenState extends State<LoanRequestScreen> {
  List<LoanRequest> allLoanRequests = [];
  List<LoanRequest> filteredLoanRequests = [];
  bool isLoading = true;
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadLoanRequests();
    dateController.addListener(_filterRequests);
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  Future<void> loadLoanRequests() async {
    try {
      final result = await fetchLoanRequests(context: context);
      setState(() {
        allLoanRequests = result;
        filteredLoanRequests = result;
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  void _filterRequests() {
    final query = dateController.text.toLowerCase();
    setState(() {
      filteredLoanRequests = allLoanRequests.where((request) {
        final date = request.requestDate.toLowerCase();
        return date.contains(query);
      }).toList();
    });
  }

  Future<void> refreshData() async {
    await loadLoanRequests();
    _filterRequests();
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'approved':
        color = Colors.green;
        label = 'Diterima';
        break;
      case 'rejected':
        color = Colors.red;
        label = 'Ditolak';
        break;
      case 'pending':
      default:
        color = Colors.orange;
        label = 'Menunggu';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildFineTypeBadge(String fineType) {
    String label;
    Color color;

    switch (fineType) {
      case 'damage':
        label = 'Kerusakan';
        color = Colors.red;
        break;
      case 'loss':
        label = 'Kehilangan';
        color = Colors.red;
        break;
      case 'late':
        label = 'Terlambat';
        color = Colors.red;
        break;
      case 'none':
      default:
        label = 'Tidak Ada Denda';
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: BACKGROUND,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: CustomTextField(
            //     controller: dateController,
            //   labelText: 'Filter Tanggal',
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Daftar Peminjaman",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredLoanRequests.isEmpty
                      ? const Center(child: Text('Tidak ada pengajuan.'))
                      : RefreshIndicator(
                          onRefresh: refreshData,
                          child: ListView.builder(
                            itemCount: filteredLoanRequests.length,
                            itemBuilder: (context, index) {
                              final request = filteredLoanRequests[index];
                              return Card(
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  // leading: ClipRRect(
                                  //   borderRadius: BorderRadius.circular(8),
                                  //   child: Image.network(
                                  //     request.book.coverImage,
                                  //     width: 50,
                                  //     height: 70,
                                  //     fit: BoxFit.cover,
                                  //     errorBuilder: (_, __, ___) =>
                                  //         const Icon(Icons.broken_image,color: Colors.black,),
                                  //   ),
                                  // ),
                                  title: Text(
                                    request.book.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Pengarang: ${request.book.author}",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      Text(
                                          "Tanggal Pengajuan: ${request.requestDate}",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      const SizedBox(height: 4),
                                      _buildStatusBadge(request.status),
                                      const SizedBox(height: 8),
                                      if (request.loan != null &&
                                          request.loan!.returnInfo != null) ...[
                                        const Divider(),
                                        Text("📦 Info Pengembalian",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        Text(
                                            "📅 Tanggal Kembali: ${request.loan!.returnInfo!.returnDate}",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        Text(
                                            "📌 Status: ${request.loan!.returnInfo!.isDamaged ? 'Rusak' : request.loan!.returnInfo!.isLost ? 'Hilang' : 'Normal'}",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        Text(
                                            "💰 Denda: Rp ${formatCurrency(double.parse(request.loan!.returnInfo!.fineAmount).toInt())}",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        const SizedBox(height: 4),
                                        _buildFineTypeBadge(
                                            request.loan!.returnInfo!.fineType),
                                        if (request.loan!.returnInfo!
                                                .replacementInstructions !=
                                            null)
                                          Text(
                                              "📄 Instruksi Penggantian: ${request.loan!.returnInfo!.replacementInstructions}",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
