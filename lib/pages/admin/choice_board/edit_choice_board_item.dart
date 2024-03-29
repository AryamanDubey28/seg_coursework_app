import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/services/firebase_functions.dart';
import 'package:seg_coursework_app/helpers/image_picker_functions.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';
import 'package:seg_coursework_app/widgets/admin_choice_board/pick_image_button.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';

import '../../../widgets/loading_indicators/loading_indicator.dart';

class EditChoiceBoardItem extends StatefulWidget {
  final String itemId;
  final String itemName;
  final String itemImageUrl;
  late final File? newPreSelectedImage;
  final bool mock;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  EditChoiceBoardItem(
      {super.key,
      required this.itemId,
      required this.itemName,
      required this.itemImageUrl,
      this.mock = false,
      this.newPreSelectedImage,
      FirebaseAuth? auth,
      FirebaseFirestore? firestore,
      FirebaseStorage? storage}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  @override
  State<EditChoiceBoardItem> createState() => _EditChoiceBoardItem();
}

/// A Popup card to edit an item (edits all categoryItems with the same id).
class _EditChoiceBoardItem extends State<EditChoiceBoardItem> {
  File? selectedImage; // hold the newly selected image by the user
  // controller to retrieve the user input for item name
  final itemNameController = TextEditingController();
  final imagePickerFunctions = const ImagePickerFunctions();
  late FirebaseFunctions firestoreFunctions;

  @override
  void initState() {
    super.initState();
    firestoreFunctions = FirebaseFunctions(
        auth: widget.auth,
        firestore: widget.firestore,
        storage: widget.storage);
    if (widget.newPreSelectedImage != null) {
      selectedImage = widget.newPreSelectedImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Hero(
          tag: "editItemHero-${widget.itemId}",
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
                        key: const Key("itemImageCard"),
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
                            : CachedNetworkImage(
                                key: UniqueKey(),
                                imageUrl: widget.itemImageUrl,
                                fit: BoxFit.cover,
                                width: 160,
                                height: 160,
                                errorWidget: (context, url, error) {
                                  return const Center(
                                      child: Icon(
                                    Icons.network_check_rounded,
                                    color: Colors.red,
                                  ));
                                },
                              )),
                    // instructions text
                    const Text(
                      "Pick an image",
                      key: Key("instructionsText"),
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    // buttons to take/upload images
                    PickImageButton(
                        key: const Key("pickImageFromGallery"),
                        label: const Text("Choose from Gallery"),
                        icon: const Icon(Icons.image),
                        onPressed: () async {
                          File? newImage = await imagePickerFunctions.pickImage(
                              source: ImageSource.gallery, context: context);
                          if (newImage != null) {
                            setState(() => selectedImage = newImage);
                          }
                        }),
                    PickImageButton(
                        key: const Key("takeImageWithCamera"),
                        label: const Text("Take a Picture"),
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () async {
                          File? newImage = await imagePickerFunctions.pickImage(
                              source: ImageSource.camera, context: context);
                          if (newImage != null) {
                            setState(() => selectedImage = newImage);
                          }
                        }),
                    const SizedBox(height: 25),
                    // field to enter the item name
                    TextField(
                      key: const Key("itemNameField"),
                      controller: itemNameController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 25.0),
                      decoration: InputDecoration(
                          hintText: widget.itemName,
                          border: InputBorder.none,
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.bold)),
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
                      onPressed: () => editItemInFirestore(
                          newImage: selectedImage,
                          newName: itemNameController.text),
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit item"),
                    )
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
  void editItemInFirestore(
      {required File? newImage, required String? newName}) async {
    // No changes made
    if (newName!.isEmpty && newImage == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          if (widget.mock) {
            return AdminChoiceBoards(
                mock: true,
                testCategories: testCategories,
                auth: widget.auth,
                firestore: widget.firestore,
                storage: widget.storage);
          } else {
            return AdminChoiceBoards();
          }
        },
      ));
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No edits made")),
        );
      } catch (e) {
        print("No Scaffold to present to!\n${e.toString()}");
      }
    } else {
      try {
        if (!widget.mock) {
          LoadingIndicatorDialog().show(context);
        }

        // Both image and name changed
        if (newName.isNotEmpty && newImage != null) {
          await firestoreFunctions.updateItemName(
              itemId: widget.itemId, newName: newName);
          await firestoreFunctions.updateCategoryItemsName(
              itemId: widget.itemId, newName: newName);
          await firestoreFunctions.deleteImageFromCloud(
              imageUrl: widget.itemImageUrl);
          String? newImageUrl = await firestoreFunctions.uploadImageToCloud(
              image: newImage, name: newName);
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
          await firestoreFunctions.itemExists(itemId: widget.itemId);
          await firestoreFunctions.deleteImageFromCloud(
              imageUrl: widget.itemImageUrl);
          String? newImageUrl = await firestoreFunctions.uploadImageToCloud(
              image: newImage, name: widget.itemName);
          await firestoreFunctions.updateItemImage(
              itemId: widget.itemId, newImageUrl: newImageUrl!);
          await firestoreFunctions.updateCategoryItemsImage(
              itemId: widget.itemId, newImageUrl: newImageUrl);
        }

        if (!widget.mock) {
          LoadingIndicatorDialog().dismiss();
        }
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) {
            if (widget.mock) {
              return AdminChoiceBoards(
                  mock: true,
                  testCategories: testCategories,
                  auth: widget.auth,
                  firestore: widget.firestore,
                  storage: widget.storage);
            } else {
              return AdminChoiceBoards();
            }
          },
        ));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Edits saved successfully!")),
        );
      } catch (e) {
        if (!widget.mock) {
          LoadingIndicatorDialog().dismiss();
        }
        ErrorDialogHelper(context: context).showAlertDialog(
            'An error occurred while communicating with the database. \nPlease make sure you are connected to the internet.');
      }
    }
  }
}
