import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  final String itemId;
  final String categoryItemId;

  const SwitchButton(
      {super.key, required this.itemId, required this.categoryItemId});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool light1 = true;

  Future<List<String>> getPaths(String key) async {
    List<String> paths = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categoryItems')
        .where('`your_field_name`', isEqualTo: key)
        .get();

    for (var doc in querySnapshot.docs) {
      paths.add(doc.reference.path);
    }

    return paths;
  }

  Future<void> switchBooleanValue(
    String itemKey,
    String categoryItemKey,
  ) async {
    final DocumentReference itemRef =
        FirebaseFirestore.instance.collection("items").doc(itemKey);

    final DocumentReference categoryItemRef = FirebaseFirestore.instance
        .collection("categoryItems")
        .doc(categoryItemKey)
        .collection("items")
        .doc(itemKey);

    final DocumentSnapshot documentSnapshot = await itemRef.get();
    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;

    final bool? currentValue = data["is_available"];

    if (currentValue != null) {
      // Items collection update
      FirebaseFirestore.instance
          .collection("items")
          .doc(itemKey)
          .update({"is_available": !currentValue});
      // Multi path update in categoryItems collection
      FirebaseFirestore.instance.collection("categoryItems").get().then(
        (querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            FirebaseFirestore.instance
                .collection("categoryItems")
                .doc(doc.id)
                .collection("items")
                .where(FieldPath.documentId, isEqualTo: itemKey)
                .limit(1)
                .get()
                .then((query) {
              if (query.docs.isNotEmpty) {
                query.docs.first.reference
                    .update({"is_available": !currentValue});
              }
            });
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: light1,
      onChanged: (bool value) async {
        switchBooleanValue(widget.itemId, widget.categoryItemId);
        setState(() {
          light1 = value;
        });
      },
    );
  }
}
