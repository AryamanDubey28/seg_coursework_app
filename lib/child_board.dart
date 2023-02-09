// ignore: unused_import
import 'package:flutter/material.dart';

class ChildBoards extends StatefulWidget {
  const ChildBoards({Key? key}) : super(key: key);

  @override
  State<ChildBoards> createState() => _ChildBoards();
}

class _ChildBoards extends State<ChildBoards> with TickerProviderStateMixin {
  late List<TransformationController> controllers;
  late List<AnimationController> animationControllers;
  late List<Image> images;
  TapDownDetails? tapDownDetails;

  Animation<Matrix4>? animation;
  bool back = false;
  String categoryName = "Category Name";

  @override
  void initState() {
    super.initState();
    controllers = List<TransformationController>.generate(
        5, (index) => TransformationController());
    animationControllers = List<AnimationController>.generate(
        5, (index) => AnimationController(vsync: this));
    //images.length
    for (var i = 0; i < 5; i++) {
      animationControllers[i] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      )..addListener(() {
          controllers[i].value = animation!.value;
        });
    }
  }

  @override
  void dispose() {
    //images.length
    for (var i = 0; i < 5; i++) {
      controllers[i].dispose();
      animationControllers[i].dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        widthFactor: MediaQuery.of(context).size.width,
        heightFactor: MediaQuery.of(context).size.height,
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    height: 80,
                    width: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(width: 3),
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100)),
                    child: IconButton(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(8.0),
                        iconSize: 50,
                        splashColor: Colors.blue.shade900,
                        hoverColor: Colors.transparent,
                        onPressed: () {
                          back = !back;
                        },
                        icon: const Icon(Icons.arrow_back_rounded)),
                  ),
                  const SizedBox(
                    width: 470,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      border: Border.all(width: 3),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    categoryName,
                    textAlign: TextAlign.right,
                    textScaleFactor: 2,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                physics: const NeverScrollableScrollPhysics(),
                //images.length
                itemCount: 5,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
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

                        final end = controllers[index].value.isIdentity()
                            ? zoomed
                            : Matrix4.identity();

                        animation = Matrix4Tween(
                                begin: controllers[index].value, end: end)
                            .animate(CurveTween(curve: Curves.easeOut)
                                .animate(animationControllers[index]));

                        animationControllers[index].forward(from: 0);
                      },
                      child: InteractiveViewer(
                        clipBehavior: Clip.none,
                        transformationController: controllers[index],
                        scaleEnabled: false,
                        panEnabled: false,
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            border: Border.all(width: 3),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ]),
      ),
    );
  }
}
