class AnnouncementResponse {
  String subject;
  String body;
  String date;
  String authorId;

  AnnouncementResponse({
    this.subject = "-",
    this.body = "-",
    this.date = "-",
    this.authorId = "-",
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementResponse(
      subject: json['subject'] ?? "-",
      body: json['body'] ?? "-",
      date: json['date'] ?? "-",
      authorId: json['author_id'] ?? "-",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'body': body,
      'date': date,
      'author_id': authorId,
    };
  }
}

List<AnnouncementResponse> announcementListFromJson(List<dynamic> jsonList) {
  return jsonList.map((e) => AnnouncementResponse.fromJson(e)).toList();
}
