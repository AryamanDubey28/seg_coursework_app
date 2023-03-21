///This model allows for easy handling of the images. It saves a name and a url for each image.
class ImageDetails {
  final String name;
  final String imageUrl;
  final String itemId;

  ImageDetails({this.name = "", required this.imageUrl, this.itemId = ""});

  bool equals(ImageDetails other) {
    return imageUrl == other.imageUrl &&
        name == other.name &&
        itemId == other.itemId;
  }

  /// Convert an ImageDetails back from json data
  factory ImageDetails.fromJson(Map<String, dynamic> json) {
    return ImageDetails(
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      itemId: json['itemId'] as String,
    );
  }

  /// Convert the current ImageDetails to json data
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'itemId': itemId,
    };
  }
}
