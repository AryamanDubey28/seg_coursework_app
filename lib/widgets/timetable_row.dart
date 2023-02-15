import 'package:flutter/material.dart';

import '../models/image_details.dart';
import 'image_square.dart';

class TimetableRow extends StatelessWidget {
  const TimetableRow({
    super.key,
    required this.listOfImages,
  });

  final List<ImageDetails> listOfImages;

  IconButton buildDeleteIconButton()
  {
    return IconButton(
      onPressed: (){}, 
      icon: const Icon(
        Icons.delete, 
        color: Colors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      // color: Colors.amber,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listOfImages.length,
              itemBuilder: (context, subIndex) {
                return Row(
                  children: [
                    ImageSquare(
                      image: listOfImages[subIndex], 
                      width: MediaQuery.of(context).size.width/6,
                    ),
                    const SizedBox(width: 5,)
                  ],
                );
              },  
            ),
          ),
          buildDeleteIconButton(),
          const SizedBox(width: 15,)
        ],
      ),
    );
  }
}