class Book {
  final int id;
  final String title;
  final String author;
  final String publisher;
  final String yearPublished;
  final int totalStock;
  final int availableStock;
  final String coverImage;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publisher,
    required this.yearPublished,
    required this.totalStock,
    required this.availableStock,
    required this.coverImage,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      publisher: json['publisher'],
      yearPublished: json['year_published'],
      totalStock: json['total_stock'],
      availableStock: json['available_stock'],
      coverImage: json['cover_image'],
    );
  }
}
