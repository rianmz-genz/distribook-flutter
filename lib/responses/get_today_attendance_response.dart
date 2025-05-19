class TodayAttendanceResponse {
  int? id = 0;
  String? name = "-";
  String? checkIn = "-";
  String? checkOut = "-";

  TodayAttendanceResponse({this.id, this.name, this.checkIn, this.checkOut});

  TodayAttendanceResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] == false ? 0 : json['id'];
    name = json['name'] == "False" ? '-' : json['name'];
    checkIn = json['check_in'] == "False" ? 'No Check In' : json['check_in'];
    checkOut =
        json['check_out'] == "False" ? 'No Check Out' : json['check_out'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['check_in'] = checkIn;
    data['check_out'] = checkOut;
    return data;
  }
}
