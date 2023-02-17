///This model allows for easy handling of the images. It saves a name and a url for each image.
class ImageDetails {
  final String name;
  final String imageUrl;

  ImageDetails({required this.name, required this.imageUrl});

  bool equals(ImageDetails other)
  {
    return imageUrl == other.imageUrl;
  }
}