import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seg_coursework_app/widgets/pick_image_button.dart';

// Refactor firestore methods into a separate file
// ask Anton to add read permission to "match /categoryItems"
// Handle errors well

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
          await updateItemName(itemId: widget.itemId, newName: newName);
          await updateCategoryItemsName(
              itemId: widget.itemId, newName: newName);
          await deleteImageFromCloud(imageUrl: widget.itemImageUrl);
          String? newImageUrl =
              await uploadImageToCloud(image: newImage, itemName: newName);
          await updateItemImage(
              itemId: widget.itemId, newImageUrl: newImageUrl!);
          await updateCategoryItemsImage(
              itemId: widget.itemId, newImageUrl: newImageUrl);
        }
        // Only name changed
        else if (newName.isNotEmpty && newImage == null) {
          await updateItemName(itemId: widget.itemId, newName: newName);
          await updateCategoryItemsName(
              itemId: widget.itemId, newName: newName);
        }
        // Only image changed
        else if (newName.isEmpty && newImage != null) {
          await deleteImageFromCloud(imageUrl: widget.itemImageUrl);
          String? newImageUrl =
              await uploadImageToCloud(image: newImage, itemName: newName);
          await updateItemImage(
              itemId: widget.itemId, newImageUrl: newImageUrl!);
          await updateCategoryItemsImage(
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

  /// Update only the "item" collection
  Future updateItemName({required String itemId, required String newName}) {
    CollectionReference items = FirebaseFirestore.instance.collection('items');

    return items
        .doc(itemId)
        .update({'name': newName}).catchError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Update all categoryItems with the same itemId
  Future updateCategoryItemsName(
      {required String itemId, required String newName}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final QuerySnapshot categoriesSnapshot =
        await firestore.collection('categoryItems').get();

    for (final DocumentSnapshot category in categoriesSnapshot.docs) {
      final QuerySnapshot categoryItemsSnapshot = await firestore
          .collection('categoryItems/${category.id}/items')
          .where(FieldPath.documentId, isEqualTo: itemId)
          .get();

      for (final DocumentSnapshot categoryItem in categoryItemsSnapshot.docs) {
        final DocumentReference categoryItemReference = firestore
            .collection('categoryItems/${category.id}/items')
            .doc(categoryItem.id);

        await categoryItemReference.update({'name': newName});
      }
    }
  }

  Future deleteImageFromCloud({required String imageUrl}) {
    return FirebaseStorage.instance.refFromURL(imageUrl).delete();
  }

  /// Take an image and upload it to the cloud storage with
  /// a unique name. Return the URL of the image from the cloud
  Future<String?> uploadImageToCloud(
      {required File image, required String itemName}) async {
    String uniqueName =
        itemName + DateTime.now().millisecondsSinceEpoch.toString();
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
      rethrow;
    }
  }

  /// Update only the "item" collection
  Future updateItemImage(
      {required String itemId, required String newImageUrl}) {
    CollectionReference items = FirebaseFirestore.instance.collection('items');

    return items
        .doc(itemId)
        .update({'illustration': newImageUrl}).catchError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Update all categoryItems with the same itemId
  Future updateCategoryItemsImage(
      {required String itemId, required String newImageUrl}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final QuerySnapshot categoriesSnapshot =
        await firestore.collection('categoryItems').get();

    for (final DocumentSnapshot category in categoriesSnapshot.docs) {
      final QuerySnapshot categoryItemsSnapshot = await firestore
          .collection('categoryItems/${category.id}/items')
          .where(FieldPath.documentId, isEqualTo: itemId)
          .get();

      for (final DocumentSnapshot categoryItem in categoryItemsSnapshot.docs) {
        final DocumentReference categoryItemReference = firestore
            .collection('categoryItems/${category.id}/items')
            .doc(categoryItem.id);

        await categoryItemReference.update({'illustration': newImageUrl});
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
