import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seg_coursework_app/helpers/firebase_functions.dart';
import 'package:seg_coursework_app/helpers/image_picker_functions.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/widgets/loading_indicator.dart';
import 'package:seg_coursework_app/widgets/pick_image_button.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';

class EditChoiceBoardCategory extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImageUrl;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  EditChoiceBoardCategory({super.key, required this.categoryId, required this.categoryName, required this.categoryImageUrl, FirebaseAuth? auth, FirebaseFirestore? firestore, FirebaseStorage? storage}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  @override
  State<EditChoiceBoardCategory> createState() => _EditChoiceBoardCategory();
}

/// A Popup card to edit a category
class _EditChoiceBoardCategory extends State<EditChoiceBoardCategory> {
  File? selectedImage; // hold the newly selected image by the user
  // controller to retrieve the user input for category name
  final categoryNameController = TextEditingController();
  final imagePickerFunctions = ImagePickerFunctions();
  late FirebaseFunctions firestoreFunctions;

  @override
  void initState() {
    super.initState();
    firestoreFunctions = FirebaseFunctions(auth: widget.auth, firestore: widget.firestore, storage: widget.storage);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Hero(
          tag: "editCategoryHero-${widget.categoryId}",
          child: Material(
            color: Theme.of(context).canvasColor,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // page (Hero) contents
                  children: [
                    // shows the currently selected image
                    Card(
                        key: Key("categoryImageCard"),
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
                                widget.categoryImageUrl,
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                              )),
                    // instructions text
                    Text(
                      "Pick an image",
                      key: Key("instructionsText"),
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    // buttons to take/upload images
                    PickImageButton(
                        key: Key("pickImageFromGallery"),
                        label: Text("Choose from Gallery"),
                        icon: Icon(Icons.image),
                        onPressed: () async {
                          File? newImage = await imagePickerFunctions.pickImage(source: ImageSource.gallery, context: context);
                          if (newImage != null) {
                            setState(() => selectedImage = newImage);
                          }
                        }),
                    PickImageButton(
                        key: Key("takeImageWithCamera"),
                        label: Text("Take a Picture"),
                        icon: Icon(Icons.camera_alt),
                        onPressed: () async {
                          File? newImage = await imagePickerFunctions.pickImage(source: ImageSource.camera, context: context);
                          if (newImage != null) {
                            setState(() => selectedImage = newImage);
                          }
                        }),
                    const SizedBox(height: 25),
                    // field to enter the category name
                    TextField(
                      key: Key("categoryNameField"),
                      controller: categoryNameController,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25.0),
                      decoration: InputDecoration(hintText: widget.categoryName, border: InputBorder.none, hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                      cursorColor: Colors.white,
                    ),
                    const Divider(
                      color: Colors.black38,
                      thickness: 0.2,
                    ),
                    const SizedBox(height: 20),
                    // submit to database button
                    TextButton.icon(
                      key: const Key("editCategoryButton"),
                      onPressed: () => editCategoryInFirestore(newImage: selectedImage, newName: categoryNameController.text),
                      icon: Icon(Icons.edit),
                      label: const Text("Edit category"),
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
  void editCategoryInFirestore({required File? newImage, required String? newName}) async {
    // No changes made
    if (newName!.isEmpty && newImage == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => AdminChoiceBoards(draggableCategories: devCategories, auth: widget.auth, firestore: widget.firestore, storage: widget.storage),
      ));
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No edits made")),
        );
      } catch (e) {
        print("No Scaffold to present to!\n${e.toString()}");
      }
    } else {
      try {
        if (widget.firestore is! FakeFirebaseFirestore) {
          LoadingIndicatorDialog().show(context);
        }

        // Both image and name changed
        if (newName.isNotEmpty && newImage != null) {
          await firestoreFunctions.updateCategoryName(categoryId: widget.categoryId, newName: newName);
          await firestoreFunctions.deleteImageFromCloud(imageUrl: widget.categoryImageUrl);
          String? newImageUrl = await firestoreFunctions.uploadImageToCloud(image: newImage, categoryName: newName);
          await firestoreFunctions.updateCategoryImage(categoryId: widget.categoryId, newImageUrl: newImageUrl!);
        }
        // Only name changed
        else if (newName.isNotEmpty && newImage == null) {
          await firestoreFunctions.updateCategoryName(categoryId: widget.categoryId, newName: newName);
        }
        // Only image changed
        else if (newName.isEmpty && newImage != null) {
          await firestoreFunctions.deleteImageFromCloud(imageUrl: widget.categoryImageUrl);
          String? newImageUrl = await firestoreFunctions.uploadImageToCloud(image: newImage, categoryName: widget.categoryName);
          await firestoreFunctions.updateCategoryImage(categoryId: widget.categoryId, newImageUrl: newImageUrl!);
        }

        LoadingIndicatorDialog().dismiss();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AdminChoiceBoards(draggableCategories: devCategories, auth: widget.auth, firestore: widget.firestore, storage: widget.storage),
        ));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Edits saved successfully!")),
        );
      } catch (e) {
        LoadingIndicatorDialog().dismiss();
        print(e);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text('An error occurred while communicating with the database'));
            });
      }
    }
  }
}
