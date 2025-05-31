class CreateLoanRequestRequest {
  final int bookId;
  final String requestDate;

  CreateLoanRequestRequest({
    required this.bookId,
    required this.requestDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'book_id': bookId,
      'request_date': requestDate,
    };
  }
}
