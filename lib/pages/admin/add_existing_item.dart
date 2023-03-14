import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../data/choice_boards_data.dart';
import '../../helpers/firebase_functions.dart';
import 'admin_choice_boards.dart';
import 'admin_side_menu.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class AddExistingItem extends StatefulWidget {
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  late final String categoryId;

  AddExistingItem({super.key, FirebaseAuth? auth, FirebaseFirestore? firestore, FirebaseStorage? storage, required this.categoryId}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  @override
  State<AddExistingItem> createState() => _AddExistingItem();
}

/// The page for admins to edit choice boards
class _AddExistingItem extends State<AddExistingItem> {
  late List<DragAndDropList> categories;

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
        ),
        drawer: const AdminSideMenu(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: ItemsGrid(auth: widget.auth, firestore: widget.firestore, storage: widget.storage, categoryId: widget.categoryId));
  }
}

class ItemsGrid extends StatelessWidget {
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  late final FirebaseFunctions firestoreFunctions;
  late final String categoryId;

  ItemsGrid({super.key, FirebaseAuth? auth, FirebaseFirestore? firestore, FirebaseStorage? storage, required this.categoryId}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
    firestoreFunctions = FirebaseFunctions(auth: this.auth, firestore: this.firestore, storage: this.storage);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('items').where("userId", isEqualTo: auth.currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final items = snapshot.data!.docs;
        return Padding(
          padding: const EdgeInsets.all(30),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final imageUrl = item['illustration'];
              return GestureDetector(
                onTap: () async {
                  // To do: check categoryItem doesn't exist already
                  DocumentSnapshot categoryItem = await firestore.collection('categoryItems/$categoryId/items').doc(item.id).get();
                  if (!categoryItem.exists) {
                    await firestoreFunctions.createCategoryItem(name: item['name'], imageUrl: item['illustration'], categoryId: categoryId, itemId: item.id);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => AdminChoiceBoards(draggableCategories: devCategories, auth: auth, firestore: firestore, storage: storage),
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${item['name']} added to category!")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${item['name']} already exists in this category!")),
                    );
                  }
                },
                child: GridTile(
                  key: ValueKey(item.id),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
