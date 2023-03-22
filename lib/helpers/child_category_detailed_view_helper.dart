import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:seg_coursework_app/models/category_item.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/general/image_square.dart';
import 'package:seg_coursework_app/widgets/child_view/item_unavailable.dart';

// Returns the grid of images, clickable and unavailable
Expanded getMainImages(List<CategoryItem> images) {
  return Expanded(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final imageSize = isLandscape? constraints.maxHeight : constraints.maxWidth;

        return GridView.builder(
            key: const Key("mainGridOfPictures"),
            padding: const EdgeInsets.all(8.0),
            itemCount: images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isLandscape? 5 : 3, childAspectRatio: 4 / 3),
            itemBuilder: (context, index) {
              return getImage(images[index], imageSize);
            });
      }
    ),
  );
}

//Method for the Text-To-Speech package Flutter TTS to speak a given text
Future speak(String text) async {
  final FlutterTts flutterTts = FlutterTts();
  await flutterTts.setSharedInstance(true);

  await flutterTts.setLanguage("en-US");

  await flutterTts.setSpeechRate(0.5);

  await flutterTts.setVolume(1.0);

  await flutterTts.setPitch(0.7);

  await flutterTts.isLanguageAvailable("en-US");

  await flutterTts.speak(text);
}

// Returns one image that on click blurs the background and is available
Padding getImage(CategoryItem image, double imageSize) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    // Focused menu holder gives the blured background on click
    child: image.availability
        ? getAvailableItem(image: image, imageSize: imageSize)
        : getUnavailableItem(image),
  );
}

// Prepare the menu holder for available item to blur the background on click
class getAvailableItem extends StatelessWidget {
  const getAvailableItem({
    super.key,
    required this.image, required this.imageSize
  });

  final CategoryItem image;
  final double imageSize;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          speak(image.name);
          showDialog(context: context, useSafeArea: false ,builder: (context)
          {
            return AlertDialog(
              content: ImageSquare(
                height: imageSize,
                width: imageSize,
                image: ImageDetails(
                  name: image.name, 
                  imageUrl: image.imageUrl
                )
              ),
            );
          });
        },
        // gets image ImageSquare and adds a focused menu holder for effects
        child: ImageSquare(
            image: ImageDetails(
                name: image.name, imageUrl: image.imageUrl)));
  }
}

// Get image as an ImageSquare without any click effects,
// if not available image is blurred and has unavailable icon
FocusedMenuHolder getUnavailableItem(CategoryItem image) {
  return FocusedMenuHolder(
    onPressed: () {
      final player = AudioPlayer();
      player.play(AssetSource('unavailable.mp3'));
    },
    menuItems: const [],
    child: Stack(
      children: [
        ImageSquare(
            height: 200,
            width: 250,
            image: ImageDetails(
                name: image.name, imageUrl: image.imageUrl)),
        Container(
          // if item is unavailable blur image and display icon, method imported from item_unavailable widget
          child: image.availability ? null : makeUnavailable(),
        ),
      ],
    ),
  );
}
