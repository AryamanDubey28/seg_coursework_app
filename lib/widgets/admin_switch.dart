import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: slash_for_doc_comments
/**
 * This widget is a switch that the admin can use in order to define 
 * the availability status of a particular item in the admin choice 
 * board.
 */
class SwitchButton extends StatefulWidget {
  final String itemId;

  const SwitchButton({super.key, required this.itemId});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool light1 = true;

  Future<void> multiPathUpdate(String itemKey, bool currentValue) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    final QuerySnapshot categoriesSnapshot = await firestore
        .collection('categories')
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .get();

    for (final DocumentSnapshot category in categoriesSnapshot.docs) {
      final QuerySnapshot categoryItemsSnapshot = await firestore
          .collection('categoryItems/${category.id}/items')
          .where(FieldPath.documentId, isEqualTo: itemKey)
          .get();

      for (final DocumentSnapshot item in categoryItemsSnapshot.docs) {
        final DocumentReference itemReference = firestore
            .collection('categoryItems/${category.id}/items')
            .doc(item.id);

        await itemReference.update({"is_available": !currentValue});
      }
    }
  }

  Future<void> switchBooleanValue(String itemKey) async {
    final DocumentReference itemRef =
        await FirebaseFirestore.instance.collection("items").doc(itemKey);
    final DocumentSnapshot documentSnapshot = await itemRef.get();
    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
    final bool? currentValue = data["is_available"];

    // Items collection update
    FirebaseFirestore.instance
        .collection("items")
        .doc(itemKey)
        .update({"is_available": !currentValue!}).then(
      (_) => multiPathUpdate(itemKey, currentValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      key: const Key("adminSwitch"),
      value: light1,
      onChanged: (bool value) async {
        switchBooleanValue(widget.itemId);
        setState(() {
          light1 = value;
        });
      },
    );
  }
}
