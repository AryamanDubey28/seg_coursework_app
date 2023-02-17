import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';

Expanded getMainImages(List<ClickableImage> images) {
  return Expanded(
    child: GridView.builder(
        key: const Key("mainGridOfPictures"),
        padding: const EdgeInsets.all(8.0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, childAspectRatio: 4 / 3),
        itemBuilder: (context, index) {
          return getClickableImage(index, images);
        }),
  );
}

// Returns one image that on click blurs the background
Padding getClickableImage(int index, List<ClickableImage> images) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    // Focused menu holder gives the blured background on click
    child: FocusedMenuHolder(
      openWithTap: true,
      onPressed: () {},
      menuItems: const [],
      blurSize: 5.0,
      menuItemExtent: 45,
      blurBackgroundColor: Colors.black54,
      duration: const Duration(milliseconds: 100),
      child: Container(
        margin: const EdgeInsets.all(5.0),
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            border: Border.all(width: 3),
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(
                images[index].imageUrl,
              ),
              fit: BoxFit.cover,
            )),
      ),
    ),
  );
}
