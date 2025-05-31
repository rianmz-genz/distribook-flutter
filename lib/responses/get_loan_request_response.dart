import 'package:distribook/responses/get_books_response.dart';

class LoanRequest {
  final int id;
  final String requestDate;
  final String status;
  final Book book;
  final Loan? loan;

  LoanRequest({
    required this.id,
    required this.requestDate,
    required this.status,
    required this.book,
    this.loan,
  });

  factory LoanRequest.fromJson(Map<String, dynamic> json) {
    return LoanRequest(
      id: json['id'],
      requestDate: json['request_date'],
      status: json['status'],
      book: Book.fromJson(json['book']),
      loan: json['loan'] != null ? Loan.fromJson(json['loan']) : null,
    );
  }
}
class LoanReturn {
  final String returnDate;
  final bool isDamaged;
  final bool isLost;
  final bool isLate;
  final String? damageDescription;
  final String fineAmount;
  final String fineType;
  final String? replacementInstructions;

  LoanReturn({
    required this.returnDate,
    required this.isDamaged,
    required this.isLost,
    required this.isLate,
    this.damageDescription,
    required this.fineAmount,
    required this.fineType,
    this.replacementInstructions,
  });

  factory LoanReturn.fromJson(Map<String, dynamic> json) {
    return LoanReturn(
      returnDate: json['return_date'],
      isDamaged: json['is_damaged'],
      isLost: json['is_lost'],
      isLate: json['is_late'],
      damageDescription: json['damage_description'],
      fineAmount: json['fine_amount'],
      fineType: json['fine_type'],
      replacementInstructions: json['replacement_instructions'],
    );
  }
}



class Loan {
  final String loanDate;
  final String dueDate;
  final String? returnDate;
  final bool isReturned;
  final LoanReturn? returnInfo;

  Loan({
    required this.loanDate,
    required this.dueDate,
    this.returnDate,
    required this.isReturned,
    this.returnInfo,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      loanDate: json['loan_date'],
      dueDate: json['due_date'],
      returnDate: json['return_date'],
      isReturned: json['is_returned'],
      returnInfo: json['return'] != null
          ? LoanReturn.fromJson(json['return'])
          : null,
    );
  }
}
