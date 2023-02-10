class Category {
  final String title;
  final String illustration;
  final int page_rank;

  Category(
      {required this.title,
      required this.illustration,
      required this.page_rank});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'illustration': illustration,
      'page_rank': page_rank,
    };
  }

  Category.fromMap(Map<String, dynamic> addressMap)
      : title = addressMap["title"],
        illustration = addressMap["illustration"],
        page_rank = addressMap["page_rank"];
}
