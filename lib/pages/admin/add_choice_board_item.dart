import 'package:flutter/material.dart';

// Add an item to the database
// Figure out how to connect the upload/take picture api

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
    late Text shownText;

    if (name!.isEmpty || imageUrl!.isEmpty) {
      shownText = Text("A field or more is missing!");
    } else {
      shownText = Text("Name: $name \nImage: $imageUrl");
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: shownText,
          );
        });
  }
}
