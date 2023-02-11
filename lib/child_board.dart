import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';

class ChildBoards extends StatefulWidget {
  const ChildBoards({Key? key}) : super(key: key);

  @override
  State<ChildBoards> createState() => _ChildBoards();
}

class _ChildBoards extends State<ChildBoards> with TickerProviderStateMixin {
  late List<TransformationController> controllers;
  late List<AnimationController> animationControllers;
  final ClickableImage categoryImage = ClickableImage(
      name: "Toast",
      imageUrl:
          "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg");
  final List<ClickableImage> images = [
    ClickableImage(
        name: "Toast",
        imageUrl:
            "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg"),
    ClickableImage(
        name: "Fruits",
        imageUrl:
            "https://images.unsplash.com/photo-1582979512210-99b6a53386f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80"),
    ClickableImage(
        name: "Football",
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/a/ad/Football_in_Bloomington%2C_Indiana%2C_1996.jpg"),
    ClickableImage(
        name: "Boxing",
        imageUrl:
            "https://e2.365dm.com/23/02/384x216/skysports-liam-wilson-emanuel-navarrete_6045983.jpg?20230204075325"),
    ClickableImage(
        name: "Swimming",
        imageUrl:
            "https://cdn.britannica.com/83/126383-050-38B8BE25/Michael-Phelps-American-Milorad-Cavic-final-Serbia-2008.jpg"),
    ClickableImage(
        name: "Butter chicken",
        imageUrl:
            "https://www.cookingclassy.com/wp-content/uploads/2021/01/butter-chicken-4.jpg"),
    ClickableImage(
        name: "Fish and chips",
        imageUrl:
            "https://forkandtwist.com/wp-content/uploads/2021/04/IMG_0102-500x500.jpg"),
    ClickableImage(
        name: "burgers",
        imageUrl:
            "https://burgerandbeyond.co.uk/wp-content/uploads/2021/04/129119996_199991198289259_8789341653858239668_n-1.jpg")
  ];
  late List<int> onTapIndexes;
  TapDownDetails? tapDownDetails;

  Animation<Matrix4>? animation;
  bool back = false;

  @override
  void initState() {
    super.initState();
    onTapIndexes = List<int>.generate(images.length, (index) => 1);
    controllers = List<TransformationController>.generate(
        images.length, (index) => TransformationController());
    animationControllers = List<AnimationController>.generate(
        images.length, (index) => AnimationController(vsync: this));
    //images.length
    for (var i = 0; i < images.length; i++) {
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
    for (var i = 0; i < images.length; i++) {
      controllers[i].dispose();
      animationControllers[i].dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(8)),
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
                        image: DecorationImage(
                          image: NetworkImage(
                            categoryImage.imageUrl,
                          ),
                          fit: BoxFit.cover,
                        )),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    categoryImage.name,
                    textAlign: TextAlign.right,
                    textScaleFactor: 2,
                  ),
                ],
              ),
            ),
          ),
          mainImages(),
        ]),
      ),
    );
  }

  Expanded mainImages() {
    return Expanded(
      child: Indexer(
        children: [
          GridView.builder(
              padding: const EdgeInsets.all(8.0),
              physics: const NeverScrollableScrollPhysics(),
              //images.length
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTapDown: (details) => tapDownDetails = details,
                    onTap: () {
                      onTapIndexes[index] = 10;
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
                    child: Indexed(
                      index: onTapIndexes[index],
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
                              image: DecorationImage(
                                image: NetworkImage(
                                  images[index].imageUrl,
                                ),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
