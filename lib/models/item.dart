// This Model class serves to facilitate the interaction with records from the items collection.

// It allows controlling and interacting with its fields through a special constructor that enables creating
// a Collection object right from a database response. It also allows to easily export all manipulation to the
// database by being easily convertible to a Map object that can then be passed on to Firebase.
class Item {
  final String name;
  final String illustration;

  Item({required this.name, required this.illustration});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'illustration': illustration,
    };
  }

  Item.fromMap(Map<String, dynamic> addressMap)
      : name = addressMap["name"],
        illustration = addressMap["illustration"];
}
