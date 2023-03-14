/// A datatype model which mimics a 'CategoryItems' entry in Firestore
class CategoryItem {
  final bool availability;
  final String name;
  final String imageUrl;
  final String id;
  final int rank;

  CategoryItem(
      {required this.availability,
      required this.name,
      required this.rank,
      required this.imageUrl,
      required this.id});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryItem &&
          runtimeType == other.runtimeType &&
          availability == other.availability &&
          name == other.name &&
          imageUrl == other.imageUrl &&
          id == other.id &&
          rank == other.rank;

  @override
  int get hashCode =>
      availability.hashCode ^
      name.hashCode ^
      imageUrl.hashCode ^
      id.hashCode ^
      rank.hashCode;

  /// Convert a CategoryItem back from json data
  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      availability: json['availability'] as bool,
      name: json['name'] as String,
      rank: json['rank'] as int,
      imageUrl: json['imageUrl'] as String,
      id: json['id'] as String,
    );
  }

  /// Convert the current CategoryItem to json data
  Map<String, dynamic> toJson() {
    return {
      'availability': availability,
      'name': name,
      'rank': rank,
      'imageUrl': imageUrl,
      'id': id,
    };
  }
}
