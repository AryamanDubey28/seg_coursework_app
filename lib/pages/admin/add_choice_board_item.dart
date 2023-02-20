import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';

// Save the uploaded image to the database
// Refactor the ScaffoldMessenger into a an external method
// create categoryItems
// add comments

/// The logic behind the upload/take picture library is made
/// with the help of: https://youtu.be/MSv38jO4EJk

class AddChoiceBoardItem extends StatefulWidget {
  const AddChoiceBoardItem({Key? key}) : super(key: key);

  @override
  State<AddChoiceBoardItem> createState() => _AddChoiceBoardItem();
}

/// Popup card to add a new item to a category.
class _AddChoiceBoardItem extends State<AddChoiceBoardItem> {
  File? selectedImage;
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
                  // page contents
                  children: [
                    // shows the selected image
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
                    buildImageButton(
                        label: Text("Choose from Gallery"),
                        icon: Icon(Icons.image),
                        method: () => pickImage(source: ImageSource.gallery)),
                    buildImageButton(
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
                        onPressed: () => createNewItem(
                            itemNameController.text, selectedImage?.path,
                            context: context),
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

  TextButton buildImageButton(
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

  void createNewItem(String? name, String? imageUrl,
      {required BuildContext context}) {
    if (name!.isEmpty || imageUrl == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("A field or more is missing!"),
            );
          });
    } else {
      addItem(name: name, imageUrl: imageUrl, context: context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const AdminChoiceBoards(),
      ));
    }
  }

  Future<void> addItem(
      {required String name,
      required String imageUrl,
      required BuildContext context}) {
    CollectionReference items = FirebaseFirestore.instance.collection('items');
    final FirebaseAuth auth = FirebaseAuth.instance;

    return items
        .add({
          'illustration': imageUrl,
          'is_available': true,
          'name': name,
          'userid': auth.currentUser!.uid
        })
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$name added successfully.")),
            ))
        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text("An error occurred while trying to add $name!")),
            ));
  }
}
