import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/services/firebase_functions.dart';
import 'package:seg_coursework_app/helpers/image_picker_functions.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/add_existing_item.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';
import 'package:seg_coursework_app/widgets/admin_choice_board/pick_image_button.dart';

import '../../../widgets/loading_indicators/loading_indicator.dart';

class AddChoiceBoardItem extends StatefulWidget {
  final String categoryId;
  final bool mock;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  late final File? preSelectedImage;

  AddChoiceBoardItem(
      {super.key,
      required this.categoryId,
      this.mock = false,
      FirebaseAuth? auth,
      FirebaseFirestore? firestore,
      FirebaseStorage? storage,
      this.preSelectedImage}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  @override
  State<AddChoiceBoardItem> createState() => _AddChoiceBoardItem();
}

/// A Popup card to add a new item to a category.
class _AddChoiceBoardItem extends State<AddChoiceBoardItem> {
  // controller to retrieve the user input for item name
  final itemNameController = TextEditingController();
  final imagePickerFunctions = const ImagePickerFunctions();
  File? selectedImage; // hold the currently selected image by the user
  late FirebaseFunctions firestoreFunctions;

  @override
  void initState() {
    super.initState();
    firestoreFunctions = FirebaseFunctions(
        auth: widget.auth,
        firestore: widget.firestore,
        storage: widget.storage);
    if (widget.preSelectedImage != null) {
      selectedImage = widget.preSelectedImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Hero(
          tag: "addItemHero-${widget.categoryId}",
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text("Already have an item in mind?",
                          style: TextStyle(fontSize: 25, color: Colors.black)),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: TextButton.icon(
                          key: const Key("useExistingItemButton"),
                          onPressed: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddExistingItem(
                                  auth: widget.auth,
                                  firestore: widget.firestore,
                                  storage: widget.storage,
                                  categoryId: widget.categoryId,
                                  mock: widget.mock),
                            ))
                          },
                          icon: Icon(Icons.add_to_photos_rounded),
                          label: const Text("Use existing item"),
                        )),
                    const Divider(
                      color: Colors.black38,
                      thickness: 0.2,
                    ),
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
                            : const Icon(
                                Icons.image_search_outlined,
                                size: 160,
                                color: Colors.black87,
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
                      decoration: const InputDecoration(
                          hintText: "Enter a name for the item",
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                      cursorColor: Colors.white,
                    ),
                    const Divider(
                      color: Colors.black38,
                      thickness: 0.2,
                    ),
                    const SizedBox(height: 20),
                    TextButton.icon(
                      key: const Key("createItemButton"),
                      onPressed: () => saveItemToFirestore(
                          image: selectedImage,
                          itemName: itemNameController.text),
                      icon: const Icon(Icons.add),
                      label: const Text("Create new item"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Given an item's image and name,
  /// - upload the image to the cloud storage
  /// - create a new item with the uploaded image's Url in Firestore
  /// - create a new categoryItem entry in the selected category
  /// - Take the user back to the Choice Boards page
  void saveItemToFirestore(
      {required File? image, required String? itemName}) async {
    if (itemName!.isEmpty || image == null) {
      ErrorDialogHelper(context: context)
          .show_alert_dialog("A field or more are missing!");
    } else {
      if (!widget.mock) {
        LoadingIndicatorDialog().show(context);
      }
      String? imageUrl = await firestoreFunctions.uploadImageToCloud(
          image: image, name: itemName);
      if (imageUrl != null) {
        try {
          String itemId = await firestoreFunctions.createItem(
              name: itemName, imageUrl: imageUrl);
          await firestoreFunctions.createCategoryItem(
              name: itemName,
              imageUrl: imageUrl,
              categoryId: widget.categoryId,
              itemId: itemId);

          if (!widget.mock) {
            LoadingIndicatorDialog().dismiss();
          }
          // go back to choice boards page
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
          // update message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$itemName added successfully.")),
          );
        } catch (e) {
          if (!widget.mock) {
            LoadingIndicatorDialog().dismiss();
          }
          ErrorDialogHelper(context: context).show_alert_dialog(
              "An error occurred while communicating with the database. \nPlease make sure you are connected to the internet.");
        }
      }
    }
  }
}
