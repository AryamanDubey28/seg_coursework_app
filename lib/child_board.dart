// ignore: unused_import
import 'package:flutter/material.dart';

class ChildBoards extends StatefulWidget {
  const ChildBoards({Key? key}) : super(key: key);

  @override
  State<ChildBoards> createState() => _ChildBoards();
}

class _ChildBoards extends State<ChildBoards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.blue,
                ),
                onTap: () {},
              ),
            );
          }),
    );
  }
}
