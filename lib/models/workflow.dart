// This Model class serves to facilitate the interaction with records from the workflows collection.

// It allows controlling and interacting with its fields through a special constructor that enables creating
// a Collection object right from a database response. It also allows to easily export all manipulation to the
// database by being easily convertible to a Map object that can then be passed on to Firebase.
class Workflow {
  final String title;
  final String illustration;
  final int page_rank;

  Workflow(
      {required this.title,
      required this.illustration,
      required this.page_rank});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'illustration': illustration,
      'rank': page_rank,
    };
  }

  Workflow.fromMap(Map<String, dynamic> addressMap)
      : title = addressMap["title"],
        illustration = addressMap["illustration"],
        page_rank = addressMap["rank"];
}
