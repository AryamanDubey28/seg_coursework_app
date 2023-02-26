import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seg_coursework_app/widgets/pick_image_button.dart';

class AddChoiceBoardCategory extends StatefulWidget {
  const AddChoiceBoardCategory({Key? key}) : super(key: key);

  @override
  State<AddChoiceBoardCategory> createState() => _AddChoiceBoardCategory();
}

/// A popup card to add a new category.
class _AddChoiceBoardCategory extends State<AddChoiceBoardCategory> {
  File? selectedImage; // hold the currently selected image by the user
  // controller to retrieve the user input for item name
  final categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "add-category-hero",
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
                      "Pick the main category image",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    // buttons to take/upload images
                    PickImageButton(label: Text("Choose from Gallery"), icon: Icon(Icons.image), onPressed: () => pickImage(source: ImageSource.gallery)),
                    PickImageButton(label: Text("Take a Picture"), icon: Icon(Icons.camera_alt), onPressed: () => pickImage(source: ImageSource.camera)),
                    const SizedBox(height: 20),
                    // field to enter the item name
                    TextField(
                      controller: categoryNameController,
                      decoration: InputDecoration(hintText: "Category's name", border: InputBorder.none, hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                      cursorColor: Colors.white,
                    ),
                    const Divider(
                      color: Colors.black38,
                      thickness: 0.2,
                    ),
                    const SizedBox(height: 20),
                    // submit to database button
                    TextButton.icon(key: const Key("createCategoryButton"), onPressed: () => saveCategory(image: selectedImage, categoryName: categoryNameController.text), icon: Icon(Icons.add), label: const Text("Create new category"), style: const ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 105, 187, 123))))
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
  void saveCategory({required File? image, required String? categoryName}) async {
    if (categoryName!.isEmpty || image == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("A field or more are missing!"),
            );
          });
    } else {
      String? imageUrl = await uploadImage(image, categoryName);
      if (imageUrl != null) {
        try {
          await createCategory(title: categoryName, imageUrl: imageUrl);
          // go back to choice boards page
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const AdminChoiceBoards(),
          ));
          // update message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$categoryName added successfully.")),
          );
        } catch (e) {
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

  /// Take an image and upload it to the cloud storage with
  /// a unique name. Return the URL of the image from the cloud
  Future<String?> uploadImage(File image, String categoryName) async {
    String uniqueName = categoryName + DateTime.now().millisecondsSinceEpoch.toString();
    // A reference to the image from the cloud's root directory
    Reference imageRef = FirebaseStorage.instance.ref().child('images').child(uniqueName);
    try {
      await imageRef.putFile(image);
      return await imageRef.getDownloadURL();
    } on FirebaseException catch (error) {
      print(error);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("An error occurred while uploading the image to the cloud"),
            );
          });
      return null;
    }
  }

  /// Add a new entry to the 'categories' collection in Firestore with
  /// the given item information. Return the created category's id
  Future<String> createCategory({required String title, required String imageUrl}) async {
    CollectionReference categories = FirebaseFirestore.instance.collection('categories');
    final FirebaseAuth auth = FirebaseAuth.instance;

    return categories.add({'userId': auth.currentUser!.uid, 'title': title, 'illustration': imageUrl, 'rank': await getNewCategoryRank(uid: auth.currentUser!.uid)}).then((category) => category.id).catchError((error, stackTrace) {
          return throw FirebaseException(plugin: stackTrace.toString());
        });
  }

  /// Return an appropriate rank for a new category
  /// (one more than the highest rank or zero if empty)
  Future<int> getNewCategoryRank({required String uid}) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').where("userId", isEqualTo: uid).get();
    return querySnapshot.size;
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
              content: Text("Couldn't upload/take a picture, make sure you have given image permissions in your device's settings"),
            );
          });
    }
  }
}
