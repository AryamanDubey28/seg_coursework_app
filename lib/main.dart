import 'package:flutter/material.dart';
import 'package:seg_coursework_app/models/image_details.dart';

import 'widgets/picture_grid.dart';
import 'widgets/visual_timetable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter UNDEMO',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MyHomePage(title: 'Flutter Demo UnHome Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 300;
  bool isGridVisible = true;
  List<ImageDetails> imagesList = [];
  List<ImageDetails> filledImagesList = [
    ImageDetails(name: "Toast", imageUrl: "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg"),
    ImageDetails(name: "Orange", imageUrl: "https://images.unsplash.com/photo-1582979512210-99b6a53386f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80"),
    ImageDetails(name: "Footy", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/a/ad/Football_in_Bloomington%2C_Indiana%2C_1996.jpg"),
    ImageDetails(name: "Boxing", imageUrl: "https://e2.365dm.com/23/02/384x216/skysports-liam-wilson-emanuel-navarrete_6045983.jpg?20230204075325"),
    ImageDetails(name: "Swimming", imageUrl: "https://cdn.britannica.com/83/126383-050-38B8BE25/Michael-Phelps-American-Milorad-Cavic-final-Serbia-2008.jpg"),
    ImageDetails(name: "Burger", imageUrl: "https://burgerandbeyond.co.uk/wp-content/uploads/2021/04/129119996_199991198289259_8789341653858239668_n-1.jpg"),
  ];

  void updateImagesList(ImageDetails image) {
    setState(() {
      if (imagesList.length < 5) {
        imagesList.add(image);
      }
      if (imagesList.length >= 5)
      {
        isGridVisible = false;
      }
    });
  }

  void popImagesList(int index) {
    setState(() {
      imagesList.removeAt(index);
      if (imagesList.length < 5) {
        isGridVisible = true;
      }
    });
  }

  void _toggleGrid() {
    setState(() {
      isGridVisible = !isGridVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              width: 1100,
              height: 200,
              alignment: Alignment.center,
              child: TimetableList(
                imagesList: imagesList,
                popImagesList: popImagesList
              ),
            )
          ),
          const Divider(height: 50,),
          Expanded(
            flex: 5,
            child: Visibility(
              visible: isGridVisible,
              child: PictureGrid(
                imagesList: filledImagesList, 
                updateImagesList: updateImagesList
              ),
            ),
          ),
          // const Text(
          //   'You have pushed the button this many times:',
          // ),
          // Text(
          //   '$_counter',
          //   style: Theme.of(context).textTheme.headlineMedium,
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isGridVisible ? Colors.red : Colors.white,
        onPressed: _toggleGrid,
        tooltip: 'Show/Hide',
        child: Icon(
          isGridVisible ? Icons.hide_image_outlined : Icons.image,
          color: isGridVisible ? Colors.white : Colors.red, 
          ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
