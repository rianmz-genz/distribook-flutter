class SelfResponse {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  SelfResponse({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SelfResponse.fromJson(Map<String, dynamic> json) {
    return SelfResponse(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
