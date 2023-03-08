///This model allows for easy handling of the images. It saves a name and a url for each image.
class ImageDetails {
  final String name;
  final String imageUrl;
  final String itemId;

  ImageDetails({required this.name, required this.imageUrl, required this.itemId});

  bool equals(ImageDetails other)
  {
    return imageUrl == other.imageUrl;
  }
}