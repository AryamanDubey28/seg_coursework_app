import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';
import 'package:seg_coursework_app/widgets/item_unavailable.dart';

// Create widget for all the child images
Expanded getMainImages(List<ClickableImage> images) {
  return Expanded(
    child: GridView.builder(
        key: const Key("mainGridOfPictures"),
        padding: const EdgeInsets.all(8.0),
        //physics: const NeverScrollableScrollPhysics(),
        itemCount: images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, childAspectRatio: 4 / 3),
        itemBuilder: (context, index) {
          return getImage(index, images);
        }),
  );
}

// Returns one image that on click blurs the background and is available
Padding getImage(int index, List<ClickableImage> images) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    // Focused menu holder gives the blured background on click
    child: images[index].is_available
        ? getAvailableItem(images, index)
        : getUnavailableItem(images, index),
  );
}

// Prepare the menu holder for available item to blur the background on click
FocusedMenuHolder getAvailableItem(List<ClickableImage> images, int index) {
  return FocusedMenuHolder(
    openWithTap: true,
    onPressed: () {
      final player = AudioPlayer();
      player.play(AssetSource('available.mp3'));
    },
    menuItems: const [],
    blurSize: 5.0,
    menuItemExtent: 45,
    blurBackgroundColor: Colors.black54,
    duration: const Duration(milliseconds: 100),
    // gets image as a container from method below and adds a focused menu holder for effects
    child: simpleItemContainer(images, index),
  );
}

// Get image as a container without any click effects, if not available image is blurred and has unavailable icon
FocusedMenuHolder getUnavailableItem(List<ClickableImage> images, int index) {
  return FocusedMenuHolder(
    onPressed: () {
      final player = AudioPlayer();
      player.play(AssetSource('unavailable.mp3'));
    },
    menuItems: [],
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
      // if item is unavailable blur image and display icon, method imported from item_unavailable widget
      child: images[index].is_available ? null : makeUnavailable(),
    ),
  );
}

Container simpleItemContainer(List<ClickableImage> images, int index) {
    return Container(
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
    );
}
