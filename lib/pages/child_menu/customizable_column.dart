import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customizable_row.dart';

// The child menu is formed essentially by creating a column of rows,
// with rowConfigs outlining the category's title and images
// (1st image is category image and those after are the smaller previews
//

class CustomizableColumn extends StatefulWidget {
  final bool mock;

  const CustomizableColumn({this.mock = false});
  @override
  State<CustomizableColumn> createState() => _CustomizableColumnState();
}

class _CustomizableColumnState extends State<CustomizableColumn> {
  // List of categories, their titles, and images within them
  late TextEditingController pin_controller;

  @override
  void initState() {
    super.initState();
    pin_controller = TextEditingController();
  }

  @override
  void dispose() {
    pin_controller.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> rowConfigs = [
    {
      'categoryTitle': 'Category 1',
      'images': [
        Image.asset("test/assets/test_image.png"),
        Image.asset("test/assets/test_image.png"),
        Image.asset("test/assets/test_image.png"),
        Image.asset("test/assets/test_image.png"),
      ],
    },
    {
      'categoryTitle': 'Category 2',
      'images': [
        Image.asset("test/assets/test_image.png"),
        Image.asset("test/assets/test_image.png"),
        Image.asset("test/assets/test_image.png"),
        Image.asset("test/assets/test_image.png"),
        Image.asset("test/assets/test_image.png"),
      ],
    },
    {
      'categoryTitle': 'Category 3',
      'images': [
        Image.asset("test/assets/test_image.png"),
        Image.asset("test/assets/test_image.png"),
      ],
    },
  ];

  Future openLogoutDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Enter your PIN to go back to the Admin Home"),
            content: TextField(
              key: Key("logoutTextField"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly
              ],
              autofocus: true,
              controller: pin_controller,
            ),
            actions: [
              TextButton(
                  key: Key("submitButton"),
                  onPressed: () => submit(context),
                  child: Text("SUBMIT"))
            ],
          ));

  Future<void> submit(BuildContext context) async {
    //verifys password is correct, if so then navigates back. otherwise says incorrect
    if (!widget.mock) {
      final auth = Auth(auth: FirebaseAuth.instance);
      String currentPin = await auth.getCurrentUserPIN();
      if (pin_controller.text.trim() == currentPin) {
        final pref = await SharedPreferences.getInstance();
        pref.setBool("isInChildMode",
            false); //isInChildMode boolean set to false as we are leaving
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AdminChoiceBoards(
                    draggableCategories: devCategories,
                  )),
        );
      } else {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  "Incorrect PIN Provided",
                  textAlign: TextAlign.center,
                ),
              );
            });
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AdminChoiceBoards(
                  draggableCategories: devCategories,
                )),
      );
    }
    pin_controller.clear();
  }

  // Construct a column of rows using category title and images
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Child Mode"),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
                key: Key("logoutButton"),
                //only triggers when its pressed for some time and swiped up
                onLongPressUp: () {
                  openLogoutDialog(context);
                },
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return CustomizableRow(
            key: Key("row$index"),
            categoryTitle: rowConfigs[index]['categoryTitle'],
            imagePreviews: rowConfigs[index]['images'],
          );
        },
        itemCount: rowConfigs.length,
        separatorBuilder: (context, index) {
          return Divider(height: 2);
        },
      ),
    );
  }
}
