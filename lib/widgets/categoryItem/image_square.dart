import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/image_details.dart';

///This widget returns a 4:3 image surrounded by a border. The default width and height can be adjusted depending on implementation.
class ImageSquare extends StatelessWidget {
  const ImageSquare(
      {super.key, required this.image, this.height = 150, this.width = 200});

  final ImageDetails image;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: CachedNetworkImage(
            key: UniqueKey(),
            imageUrl: image.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return const Center(
                  child: Icon(
                Icons.download,
                color: Colors.blue,
              ));
            },
            errorWidget: (context, url, error) {
              return const Center(
                  child: Icon(
                Icons.network_check_rounded,
                color: Colors.red,
              ));
            },
          )),
    );
  }
}
