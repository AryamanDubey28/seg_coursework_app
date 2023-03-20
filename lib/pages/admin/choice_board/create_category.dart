import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/services/firebase_functions/firebase_create_functions.dart';
import 'package:seg_coursework_app/services/firebase_functions/firebase_delete_functions.dart';
import 'package:seg_coursework_app/helpers/image_picker_functions.dart';
import 'package:seg_coursework_app/pages/admin/choice_board/admin_choice_boards.dart';
import 'package:seg_coursework_app/services/firebase_functions/firebase_update_functions.dart';
import 'package:seg_coursework_app/widgets/general/loading_indicator.dart';
import 'package:seg_coursework_app/widgets/general/select_image_widget.dart';

// Enables the interface for the user to create a new category.
class CreateCategory extends StatefulWidget {
  final bool mock;
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  late final File? preSelectedImage;

  CreateCategory(
      {super.key,
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
  State<CreateCategory> createState() => _CreateCategory();
}

/// A Popup card to add a new category.
class _CreateCategory extends State<CreateCategory> {
  // controller to retrieve the user input for category name
  final categoryNameController = TextEditingController();
  final imagePickerFunctions = ImagePickerFunctions();
  File? selectedImage; // hold the currently selected image by the user
  late FirebaseUpdateFunctions firestoreUpdateFunctions;
  late FirebaseCreateFunctions firestoreCreateFunctions;


  @override
  void initState() {
    super.initState();
    firestoreCreateFunctions = FirebaseCreateFunctions(
        auth: widget.auth,
        firestore: widget.firestore,
        storage: widget.storage);
    firestoreUpdateFunctions = FirebaseUpdateFunctions(
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
          tag: "add-category-hero",
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
                            : Icon(
                                Icons.image_search_outlined,
                                size: 160,
                                color: Colors.black87,
                              )),
                    // instructions text
                    Text(
                      "Pick an image",
                      key: Key("instructionsText"),
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    // buttons to take/upload images
                    SelectImageButton(
                        key: Key("pickImageFromGallery"),
                        label: Text("Choose from Gallery"),
                        icon: Icon(Icons.image),
                        onPressed: () async {
                          File? newImage = await imagePickerFunctions.pickImage(
                              source: ImageSource.gallery, context: context);
                          if (newImage != null) {
                            setState(() => selectedImage = newImage);
                          }
                        }),
                    SelectImageButton(
                        key: Key("takeImageWithCamera"),
                        label: Text("Take a Picture"),
                        icon: Icon(Icons.camera_alt),
                        onPressed: () async {
                          File? newImage = await imagePickerFunctions.pickImage(
                              source: ImageSource.camera, context: context);
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
                      decoration: InputDecoration(
                          hintText: "Enter a name for the category",
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
                      key: const Key("createCategoryButton"),
                      onPressed: () => saveCategoryToFirestore(
                          image: selectedImage,
                          categoryName: categoryNameController.text),
                      icon: Icon(Icons.add),
                      label: const Text("Create new category"),
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

  /// Given a category's image and name,
  /// - upload the image to the cloud storage
  /// - create a new category with the uploaded image's Url in Firestore
  /// - Take the user back to the Choice Boards page
  void saveCategoryToFirestore(
      {required File? image, required String? categoryName}) async {
    if (categoryName!.isEmpty || image == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              key: Key("FieldsMissingAlert"),
              content: Text("A field or more are missing!"),
            );
          });
    } else {
      LoadingIndicatorDialog().show(context);
      String? imageUrl = await firestoreUpdateFunctions.uploadImageToCloud(
          image: image, name: categoryName);
      if (imageUrl != null) {
        try {
          await firestoreCreateFunctions.createCategory(
              name: categoryName, imageUrl: imageUrl);

          LoadingIndicatorDialog().dismiss();
          // go back to choice boards page
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              if (widget.mock) {
                return AdminChoiceBoard(
                    mock: true,
                    testCategories: testCategories,
                    auth: widget.auth,
                    firestore: widget.firestore,
                    storage: widget.storage);
              } else {
                return AdminChoiceBoard();
              }
            },
          ));
          // update message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$categoryName added successfully.")),
          );
        } catch (e) {
          print(e);
          LoadingIndicatorDialog().dismiss();
          ErrorDialogHelper(context: context).show_alert_dialog(
              "An error occurred while communicating with the database. \nPlease make sure you are connected to the internet.");
        }
      }
    }
  }
}
