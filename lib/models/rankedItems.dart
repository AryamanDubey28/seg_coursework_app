import './item.dart';

class RankedItem {
  Item item;
  int rank;

  RankedItem(String name, String illustration, int rank) {
    item = Item(name, illustration);
    rank = rank;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': item.name,
      'illustration': item.illustration,
      'rank': rank,
    };
  }
}
