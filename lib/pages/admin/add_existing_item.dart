import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/widgets/custom_loading_indicator.dart';
import 'package:seg_coursework_app/widgets/existing_items_grid.dart';
import '../../helpers/firebase_functions.dart';
import 'admin_side_menu.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';

/// Creates a page that presents all existing items created by user and allows
/// adding them to a specific category
class AddExistingItem extends StatefulWidget {
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  late final String categoryId;
  late final bool mock;
  late final FirebaseFunctions firestoreFunctions;

  AddExistingItem({super.key, FirebaseAuth? auth, FirebaseFirestore? firestore, FirebaseStorage? storage, required this.categoryId, this.mock = false}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
    firestoreFunctions = FirebaseFunctions(auth: this.auth, firestore: this.firestore, storage: this.storage);
  }

  @override
  State<AddExistingItem> createState() => _AddExistingItem();
}

class _AddExistingItem extends State<AddExistingItem> {
  late List<DragAndDropList> categories;
  late Stream<QuerySnapshot<Map<String, dynamic>>> items;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          key: Key('app_bar'),
          title: const Text('Add an Existing Item'),
          leading: IconButton(
            key: const Key("createItemButton"),
            // iconSize: 40,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: FutureBuilder<List<ImageDetails>>(
      future: widget.firestoreFunctions.getLibraryOfImages(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ExistingItemsGrid(imagesList: snapshot.data!, categoryId: widget.categoryId, mock: widget.mock, auth: widget.auth, firestore: widget.firestore, storage: widget.storage,);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CustomLoadingIndicator();
        }
      },
    ),
      );
  }
}