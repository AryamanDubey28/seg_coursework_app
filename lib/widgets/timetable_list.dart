import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';


class TimetableList extends StatelessWidget {
  const TimetableList({super.key, required this.imagesList, required this.popImagesList});

  final List<ImageDetails> imagesList;
  final Function popImagesList;

  List<ImageDetails> getImagesList()
  {
    return imagesList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: imagesList.length,
      itemBuilder: (context, index) {
        //ADD ON TAP HERE
        return GestureDetector(
          onTap: () {
            popImagesList(index);
          },
          child: Row(
            children: <Widget>[
              Tooltip(
                message: imagesList[index].name,
                child: ImageSquare(
                  key: Key('timetableImage$index'),
                  image: imagesList[index],
                ),
              ),
              if (index != imagesList.length - 1)
                const Icon(Icons.arrow_right),
            ],
          ),
        );
      },
    );
  }
}