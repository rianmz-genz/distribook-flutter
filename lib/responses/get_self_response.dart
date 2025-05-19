class SelfResponse {
  final SelfData data;
  final String message;

  SelfResponse({
    required this.data,
    required this.message,
  });

  factory SelfResponse.fromJson(Map<String, dynamic> json) {
    return SelfResponse(
      data: SelfData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class SelfData {
  final String company;
  final String name;
  final Employee? employee;

  SelfData({
    required this.company,
    required this.name,
    this.employee,
  });

  factory SelfData.fromJson(Map<String, dynamic> json) {
    return SelfData(
      company: json['company'],
      name: json['name'],
      employee: json['employee'] != null
          ? Employee.fromJson(json['employee'])
          : null,
    );
  }
}

class Employee {
  final String name;
  final String? image;

  Employee({
    required this.name,
    this.image,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'],
      image: json['image'],
    );
  }
}
