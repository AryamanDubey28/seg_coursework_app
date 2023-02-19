import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';

// Figure out how to connect the upload/take picture api
// Refactor the ScaffoldMessenger into a an external method
// create categoryItems
// add comments

/// Popup card to add a new item to a category.
class AddChoiceBoardItem extends StatelessWidget {
  AddChoiceBoardItem({Key? key}) : super(key: key);

  // controllers to retrieve the user input
  final itemNameController = TextEditingController();
  final itemImageUrlController = TextEditingController();

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
                  children: [
                    TextField(
                      controller: itemNameController,
                      decoration: InputDecoration(
                        hintText: "item's name",
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                    ),
                    const Divider(
                      color: Colors.black38,
                      thickness: 0.2,
                    ),
                    TextField(
                      controller: itemImageUrlController,
                      decoration: InputDecoration(
                        hintText: 'Image URL',
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                    ),
                    const Divider(
                      color: Colors.black38,
                      thickness: 0.2,
                    ),
                    TextButton.icon(
                        key: const Key("createItemButton"),
                        onPressed: () => createNewItem(itemNameController.text,
                            itemImageUrlController.text, context: context),
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

  void createNewItem(String? name, String? imageUrl,
      {required BuildContext context}) {
    if (name!.isEmpty || imageUrl!.isEmpty) {
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
