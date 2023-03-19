import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/image_square.dart';
import 'package:seg_coursework_app/widgets/search_bar.dart';

import '../data/choice_boards_data.dart';
import '../helpers/firebase_functions.dart';
import '../pages/admin/admin_choice_boards.dart';

/// Shows a grid of all existing item images and names
class ExistingItemsGrid extends StatefulWidget {
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  late final String categoryId;
  late final bool mock;
  late final FirebaseFunctions firestoreFunctions;
    
  ExistingItemsGrid({super.key, FirebaseAuth? auth, FirebaseFirestore? firestore, FirebaseStorage? storage, required this.categoryId, this.mock = false, required this.imagesList}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
    firestoreFunctions = FirebaseFunctions(auth: this.auth, firestore: this.firestore, storage: this.storage);
  }

  final List<ImageDetails> imagesList;

  @override
  State<ExistingItemsGrid> createState() => _ExistingItemsGridState();
}

class _ExistingItemsGridState extends State<ExistingItemsGrid> {
  String _searchText = '';

  ///This function gets the items filtered by the searchbar.
  List<ImageDetails> _getFilteredItems() {
    if (_searchText.isEmpty) {
      return widget
          .imagesList; // the list of all items to be displayed in the grid view
    } else {
      return widget.imagesList
          .where((item) =>
              item.name.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagesList.isEmpty) {
      return Text("No items to show. Add some in the 'Choice Board' page");
    } else {
      return LayoutBuilder(builder: (context, constraints) {
        return Container(
          margin: EdgeInsets.fromLTRB(7, 0, 7, 7),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 60,
                child: Padding(padding: EdgeInsets.only(top: 15), child: SearchBar(onTextChanged: (text) {
                  setState(() {
                    _searchText = text;
                  });
                }),)
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                //the height of the column minus height of the search bar, the sized box, and the margin.
                height: constraints.maxHeight - 75 - 7,
                child: GridView.builder(
                    itemCount: _getFilteredItems().length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 4 / 3,
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 7,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          addItemAsCategoryItem(context: context, itemId: widget.imagesList[index].itemId, imageUrl: widget.imagesList[index].imageUrl, name: widget.imagesList[index].name);
                        },
                        child: Tooltip(
                          message: _getFilteredItems()[index].name,
                          child: Column(children: [
                            Expanded(child: ImageSquare(
                              key: Key('gridImage$index'),
                              image: _getFilteredItems()[index],
                          )),
                          Padding(padding: EdgeInsets.only(top: 10), child: Text(_getFilteredItems()[index].name, style: TextStyle(fontSize: 20),),)
                          ],)
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      });
    }
  }

  void addItemAsCategoryItem({required String itemId, required String imageUrl, required String name, required BuildContext context}) async {
    DocumentSnapshot categoryItem = await widget.firestore.collection('categoryItems/${widget.categoryId}/items').doc(itemId).get();
    // Only create new categoryItem for item if it doens't already exist
    if (!categoryItem.exists) {
      await widget.firestoreFunctions.createCategoryItem(name: name, imageUrl: imageUrl, categoryId: widget.categoryId, itemId: itemId);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          if (widget.mock) {
            return AdminChoiceBoards(mock: true, testCategories: testCategories, auth: widget.auth, firestore: widget.firestore, storage: widget.storage);
          } else {
            return AdminChoiceBoards();
          }
        },
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$name added to category!")),
      );
    } else {
      // If categoryItem already exists for this item, don't add as duplicate
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$name already exists in this category!")),
      );
    }
  }
}