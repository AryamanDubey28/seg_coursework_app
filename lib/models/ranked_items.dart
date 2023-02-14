import './item.dart';

// This Model class serves to facilitate the interaction with records from the workflowItems and categoryItems
// collections. It extends the Item class with an additional rank field that enables its user to store
// and interact with the rank the stored item should have in the category or workflow it belongs to.

// It allows controlling and interacting with its fields through a special constructor that enables creating
// a Collection object right from a database response. It also allows to easily export all manipulation to the
// database by being easily convertible to a Map object that can then be passed on to Firebase.
class RankedItem extends Item {
  final int rank;

  RankedItem({required name, required illustration, required this.rank})
      : super(name: name, illustration: illustration);

  Map<String, dynamic> toMap() {
    return {'name': name, 'illustration': illustration, 'rank': rank};
  }

  RankedItem.fromMap(Map<String, dynamic> addressMap)
      : rank = addressMap["rank"],
        super(
            name: addressMap["name"], illustration: addressMap["illustration"]);
}
