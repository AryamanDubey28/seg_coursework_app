class ImageDetails {
  final String name;
  final String imageUrl;

  ImageDetails({required this.name, required this.imageUrl});

  bool equals(ImageDetails other)
  {
    return imageUrl == other.imageUrl;
  }
}