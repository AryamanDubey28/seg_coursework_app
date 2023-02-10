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
