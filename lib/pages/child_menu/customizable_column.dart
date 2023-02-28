import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/admin/admin_interface.dart';
import 'customizable_row.dart';

// The child menu is formed essentially by creating a column of rows,
// with rowConfigs outlining the category's title and images
// (1st image is category image and those after are the smaller previews
//

class CustomizableColumn extends StatefulWidget {
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
              autofocus: true,
              controller: pin_controller,
            ),
            actions: [
              TextButton(
                  onPressed: () => submit(context), child: Text("SUBMIT"))
            ],
          ));

  void submit(BuildContext context) {
    //verifys password is correct, if so then navigates back. otherwise says incorrect
    if (pin_controller.text.trim() == "0000") {
      print("navigating back to admin home");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminChoiceBoards()),
      );

      //Navigator.popAndPushNamed(context, 'adminScreen');
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Incorrect PIN Provided"),
            );
          });
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
