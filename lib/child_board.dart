// ignore: unused_import
import 'package:flutter/material.dart';

class ChildBoards extends StatefulWidget {
  const ChildBoards({Key? key}) : super(key: key);

  @override
  State<ChildBoards> createState() => _ChildBoards();
}

class _ChildBoards extends State<ChildBoards>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        controller.value = animation!.value;
      });
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();

    super.dispose();
  }

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
              child: GestureDetector(
                onTapDown: (details) => tapDownDetails = details,
                onTap: () {
                  final position = tapDownDetails!.localPosition;

                  const double scale = 1.5;
                  final x = -position.dx * (scale - 1);
                  final y = -position.dy * (scale - 1);
                  final zoomed = Matrix4.identity()
                    ..translate(x, y)
                    ..scale(scale);

                  final end = controller.value.isIdentity()
                      ? zoomed
                      : Matrix4.identity();

                  animation = Matrix4Tween(begin: controller.value, end: end)
                      .animate(CurveTween(curve: Curves.easeOut)
                          .animate(animationController));

                  animationController.forward(from: 0);
                },
                child: InteractiveViewer(
                  clipBehavior: Clip.none,
                  transformationController: controller,
                  scaleEnabled: false,
                  panEnabled: false,
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.blue,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
