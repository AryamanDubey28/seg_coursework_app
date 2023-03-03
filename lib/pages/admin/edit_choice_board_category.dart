import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seg_coursework_app/widgets/pick_image_button.dart';

/// Edit details of category
class EditChoiceBoardCategory extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImageUrl;
  const EditChoiceBoardCategory(
      {Key? key,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImageUrl})
      : super(key: key);

  @override
  State<EditChoiceBoardCategory> createState() => _EditChoiceBoardCategory();
}

/// A Popup card to edit a category
class _EditChoiceBoardCategory extends State<EditChoiceBoardCategory> {
  File? selectedImage; // hold the newly selected image by the user
  // controller to retrieve the user input for category name
  final categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "edit-category-hero",
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
                                widget.categoryImageUrl,
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                              )),
                    // instructions text
                    Text(
                      "Pick the main category image",
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
                    // field to enter the category name
                    TextField(
                      controller: categoryNameController,
                      decoration: InputDecoration(
                          hintText: widget.categoryName,
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
                        key: const Key("editCategoryButton"),
                        onPressed: () => editCategory(
                            newImage: selectedImage,
                            newCategoryName: categoryNameController.text),
                        icon: Icon(Icons.edit),
                        label: const Text("Edit category"),
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

  // Update category image and/or title
  Future<void> editCategory(
      {required File? newImage, required String? newCategoryName}) async {
    String? imageUrl;
    if (newCategoryName!.isEmpty && newImage == null) {
      // If user hasn't changed either
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No edits made")),
      );
    } else if (newCategoryName.isNotEmpty && newImage != null) {
      // If user is changing both image and title
      deleteImage(imageUrl: widget.categoryImageUrl);
      imageUrl = await replaceImage(newImage, newCategoryName);
      FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryId)
          .update({'illustration': imageUrl, 'title': newCategoryName});
    } else if (newCategoryName.isNotEmpty && newImage == null) {
      // If user is changing title but not image
      FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryId)
          .update({'title': newCategoryName});
    } else if (newCategoryName.isEmpty && newImage != null) {
      // If user is changing image but not title
      deleteImage(imageUrl: widget.categoryImageUrl);
      imageUrl = await replaceImage(newImage, newCategoryName);
      FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryId)
          .update({'illustration': imageUrl});
    } else {
      // Else, some error occurred
      try {} catch (e) {
        print(e);
      }
    }

    // Return to choice board screen
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const AdminChoiceBoards(),
    ));
  }

  // Delete image from firebase storage
  Future deleteImage({required String imageUrl}) {
    return FirebaseStorage.instance.refFromURL(imageUrl).delete();
  }

  /// Take an image and upload it to the cloud storage with
  /// a unique name. Return the URL of the image from the cloud
  Future<String?> replaceImage(File image, String categoryName) async {
    String uniqueName =
        categoryName + DateTime.now().millisecondsSinceEpoch.toString();
    // A reference to the image from the cloud's root directory
    Reference imageRef =
        FirebaseStorage.instance.ref().child('images').child(uniqueName);
    try {
      await imageRef.putFile(image);
      return await imageRef.getDownloadURL();
    } on FirebaseException catch (error) {
      print(error);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  "An error occurred while uploading the image to the cloud"),
            );
          });
      return null;
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
