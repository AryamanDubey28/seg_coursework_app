import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// The logic behind the upload/take picture library is made
/// with the help of: https://youtu.be/MSv38jO4EJk
/// and https://youtu.be/u52TWx41oU4

class AddChoiceBoardItem extends StatefulWidget {
  final String categoryId;
  const AddChoiceBoardItem({Key? key, required this.categoryId})
      : super(key: key);

  @override
  State<AddChoiceBoardItem> createState() => _AddChoiceBoardItem();
}

/// A Popup card to add a new item to a category.
class _AddChoiceBoardItem extends State<AddChoiceBoardItem> {
  File? selectedImage; // hold the currently selected image by the user
  // controller to retrieve the user input for item name
  final itemNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "add-item-hero",
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
                            : Icon(
                                Icons.image_search_outlined,
                                size: 160,
                              )),
                    // instructions text
                    Text(
                      "Pick an image",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    // buttons to take/upload images
                    _buildImageButton(
                        label: Text("Choose from Gallery"),
                        icon: Icon(Icons.image),
                        method: () => pickImage(source: ImageSource.gallery)),
                    _buildImageButton(
                        label: Text("Take a Picture"),
                        icon: Icon(Icons.camera_alt),
                        method: () => pickImage(source: ImageSource.camera)),
                    const SizedBox(height: 20),
                    // field to enter the item name
                    TextField(
                      controller: itemNameController,
                      decoration: InputDecoration(
                          hintText: "Item's name",
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
                        key: const Key("createItemButton"),
                        onPressed: () => handleSavingItemToFirestore(
                            image: selectedImage,
                            itemName: itemNameController.text),
                        icon: Icon(Icons.add),
                        label: const Text("Create new item"),
                        style: const ButtonStyle(
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white),
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 105, 187, 123))))
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
  void handleSavingItemToFirestore(
      {required File? image, required String? itemName}) async {
    if (itemName!.isEmpty || image == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("A field or more are missing!"),
            );
          });
    } else {
      String? imageUrl = await uploadImageToCloud(image, itemName);
      if (imageUrl != null) {
        try {
          String itemId = await createItem(name: itemName, imageUrl: imageUrl);
          await createCategoryItem(
              name: itemName,
              imageUrl: imageUrl,
              categoryId: widget.categoryId,
              itemId: itemId);
          // go back to choice boards page
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const AdminChoiceBoards(),
          ));
          // update message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$itemName added successfully.")),
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

  /// Take an image and upload it to the cloud storage with
  /// a unique name. Return the URL of the image from the cloud
  Future<String?> uploadImageToCloud(File image, String itemName) async {
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
      return null;
    }
  }

  /// Add a new entry to the 'items' collection in Firestore with
  /// the given item information. Return the created item's id
  Future<String> createItem(
      {required String name, required String imageUrl}) async {
    CollectionReference items = FirebaseFirestore.instance.collection('items');
    final FirebaseAuth auth = FirebaseAuth.instance;

    return items
        .add({
          'name': name,
          'illustration': imageUrl,
          'is_available': true,
          'userId': auth.currentUser!.uid
        })
        .then((item) => item.id)
        .catchError((error, stackTrace) {
          return throw FirebaseException(plugin: stackTrace.toString());
        });
  }

  /// Add a new entry to the 'categoryItems' collection in Firestore with
  /// the given item and category information.
  /// Note: the categoryItem will have the same id as the item
  Future createCategoryItem(
      {required String name,
      required String imageUrl,
      required String categoryId,
      required String itemId}) async {
    CollectionReference categoryItems = FirebaseFirestore.instance
        .collection('categoryItems/$categoryId/items');
    final FirebaseAuth auth = FirebaseAuth.instance;

    return categoryItems.doc(itemId).set({
      'illustration': imageUrl,
      'is_available': true,
      'name': name,
      'rank': await getNewCategoryItemRank(categoryId: categoryId),
      'userId': auth.currentUser!.uid
    }).onError((error, stackTrace) {
      return throw FirebaseException(plugin: stackTrace.toString());
    });
  }

  /// Return an appropriate rank for a new categoryItem in the
  /// given category (one more than the highest rank or zero if empty)
  Future<int> getNewCategoryItemRank({required String categoryId}) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categoryItems/$categoryId/items')
        .get();
    return querySnapshot.size;
  }

  /// Build a standard button style for the two buttons asking for either
  /// uploading or taking an image
  TextButton _buildImageButton(
      {required Text label, required Icon icon, required VoidCallback method}) {
    return TextButton.icon(
        onPressed: method,
        icon: icon,
        label: label,
        style: const ButtonStyle(
            alignment: Alignment.centerLeft,
            minimumSize: MaterialStatePropertyAll(Size(200, 20)),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStatePropertyAll(Colors.black54)));
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
