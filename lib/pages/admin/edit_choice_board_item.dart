import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seg_coursework_app/widgets/pick_image_button.dart';

// if statement for both changes
// if statement for only changing name
// if statement for only changing image
// Handle errors well
// Add comments here and in the edit button

class EditChoiceBoardItem extends StatefulWidget {
  final String itemId;
  final String itemName;
  final String itemImageUrl;
  const EditChoiceBoardItem(
      {Key? key,
      required this.itemId,
      required this.itemName,
      required this.itemImageUrl})
      : super(key: key);

  @override
  State<EditChoiceBoardItem> createState() => _EditChoiceBoardItem();
}

/// A Popup card to edit an item (edits all items with the same id).
class _EditChoiceBoardItem extends State<EditChoiceBoardItem> {
  File? selectedImage; // hold the newly selected image by the user
  // controller to retrieve the user input for item name
  final itemNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "edit-item-hero",
          child: Material(
            color: Theme.of(context).canvasColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // page (Hero) contents
                  children: [
                    // shows the currently selected image
                    Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: selectedImage != null
                            ? Image.file(
                                selectedImage!,
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                widget.itemImageUrl,
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                              )),
                    // instructions text
                    Text(
                      "Pick an image",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    // buttons to take/upload images
                    PickImageButton(
                        label: Text("Choose from Gallery"),
                        icon: Icon(Icons.image),
                        onPressed: () =>
                            pickImage(source: ImageSource.gallery)),
                    PickImageButton(
                        label: Text("Take a Picture"),
                        icon: Icon(Icons.camera_alt),
                        onPressed: () => pickImage(source: ImageSource.camera)),
                    const SizedBox(height: 20),
                    // field to enter the item name
                    TextField(
                      controller: itemNameController,
                      decoration: InputDecoration(
                          hintText: widget.itemName,
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                      cursorColor: Colors.white,
                    ),
                    const Divider(
                      color: Colors.black38,
                      thickness: 0.2,
                    ),
                    const SizedBox(height: 20),
                    // submit to database button
                    TextButton.icon(
                        key: const Key("editItemButton"),
                        onPressed: () => handleEditingItemInFirestore(
                            newImage: selectedImage,
                            newItemName: itemNameController.text),
                        icon: Icon(Icons.edit),
                        label: const Text("Edit item"),
                        style: const ButtonStyle(
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white),
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 0, 76, 153))))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleEditingItemInFirestore(
      {required File? newImage, required String? newItemName}) {
    if (newItemName!.isEmpty && newImage == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const AdminChoiceBoards(),
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No edits made")),
      );
    } else {
      try {} catch (e) {
        print(e);
      }
    }
  }

  /// Enable the user to either upload or take an image depending on
  /// the source argument. Update the [selectedImage] with the user
  /// provided image
  Future pickImage({required ImageSource source}) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageFile = File(image.path);
      setState(() => selectedImage = imageFile);
    } on PlatformException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  "Couldn't upload/take a picture, make sure you have given image permissions in your device's settings"),
            );
          });
    }
  }
}
