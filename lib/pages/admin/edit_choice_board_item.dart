import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seg_coursework_app/helpers/firestore_functions.dart';
import 'package:seg_coursework_app/helpers/image_picker_functions.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/widgets/pick_image_button.dart';

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

/// A Popup card to edit an item (edits all categoryItems with the same id).
class _EditChoiceBoardItem extends State<EditChoiceBoardItem> {
  File? selectedImage; // hold the newly selected image by the user
  // controller to retrieve the user input for item name
  final itemNameController = TextEditingController();
  final firestoreFunctions = FirestoreFunctions();
  final imagePickerFunctions = ImagePickerFunctions();

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
                        onPressed: () async {
                          File? newImage = await imagePickerFunctions.pickImage(
                              source: ImageSource.gallery, context: context);
                          if (newImage != null) {
                            setState(() => selectedImage = newImage);
                          }
                        }),
                    PickImageButton(
                        label: Text("Take a Picture"),
                        icon: Icon(Icons.camera_alt),
                        onPressed: () async {
                          File? newImage = await imagePickerFunctions.pickImage(
                              source: ImageSource.camera, context: context);
                          if (newImage != null) {
                            setState(() => selectedImage = newImage);
                          }
                        }),
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
                            newName: itemNameController.text),
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

  /// Handle running the edit functions depending on if
  /// - Both the name and image changed
  /// - Only the name changed
  /// - Only the image changed
  void handleEditingItemInFirestore(
      {required File? newImage, required String? newName}) async {
    // No changes made
    if (newName!.isEmpty && newImage == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const AdminChoiceBoards(),
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No edits made")),
      );
    } else {
      try {
        // Both image and name changed
        if (newName.isNotEmpty && newImage != null) {
          await firestoreFunctions.updateItemName(
              itemId: widget.itemId, newName: newName);
          await firestoreFunctions.updateCategoryItemsName(
              itemId: widget.itemId, newName: newName);
          await firestoreFunctions.deleteImageFromCloud(
              imageUrl: widget.itemImageUrl);
          String? newImageUrl = await firestoreFunctions.uploadImageToCloud(
              image: newImage, itemName: newName);
          await firestoreFunctions.updateItemImage(
              itemId: widget.itemId, newImageUrl: newImageUrl!);
          await firestoreFunctions.updateCategoryItemsImage(
              itemId: widget.itemId, newImageUrl: newImageUrl);
        }
        // Only name changed
        else if (newName.isNotEmpty && newImage == null) {
          await firestoreFunctions.updateItemName(
              itemId: widget.itemId, newName: newName);
          await firestoreFunctions.updateCategoryItemsName(
              itemId: widget.itemId, newName: newName);
        }
        // Only image changed
        else if (newName.isEmpty && newImage != null) {
          await firestoreFunctions.deleteImageFromCloud(
              imageUrl: widget.itemImageUrl);
          String? newImageUrl = await firestoreFunctions.uploadImageToCloud(
              image: newImage, itemName: widget.itemName);
          await firestoreFunctions.updateItemImage(
              itemId: widget.itemId, newImageUrl: newImageUrl!);
          await firestoreFunctions.updateCategoryItemsImage(
              itemId: widget.itemId, newImageUrl: newImageUrl);
        }

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const AdminChoiceBoards(),
        ));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Edits saved successfully!")),
        );
      } catch (e) {
        print(e);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  content: Text(
                      'An error occurred while communicating with the database'));
            });
      }
    }
  }
}
