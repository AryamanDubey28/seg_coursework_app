class Item {
  String name;
  String illustration;

  Item(name, illustration) {
    this.name = name;
    this.illustration = illustration;
  }

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
