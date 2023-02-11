import 'package:flutter/material.dart';
import 'timetable_block.dart';

import 'image_square.dart';

Column VisualTimetable2() {
    return Column(
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget> [
          TimetableBlock(height: 200, width: 200, imageURL: "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg"
          ),
          TimetableBlock(height: 200, width: 200, imageURL: "https://images.unsplash.com/photo-1582979512210-99b6a53386f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80"
          ),
          TimetableBlock(height: 200, width: 200, imageURL: "https://upload.wikimedia.org/wikipedia/commons/a/ad/Football_in_Bloomington%2C_Indiana%2C_1996.jpg"
          ),
        ],
      ),
      const SizedBox.square(dimension: 20.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          TimetableBlock(height: 200, width: 200, imageURL: "https://e2.365dm.com/23/02/384x216/skysports-liam-wilson-emanuel-navarrete_6045983.jpg?20230204075325"
          ),
          ImageSquare(height: 200, width: 200, imageURL: "https://cdn.britannica.com/83/126383-050-38B8BE25/Michael-Phelps-American-Milorad-Cavic-final-Serbia-2008.jpg"
          ),
        ],
      )
    ],
  );
}

Wrap VisualTimetable3() {
  return Wrap(
    children: const <Widget> [
      ImageSquare(height: 150, width: 150, imageURL: "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg"
      ),
      Icon(
        Icons.arrow_right_alt_sharp,
        size: 150,
      ),
      ImageSquare(height: 150, width: 150, imageURL: "https://images.unsplash.com/photo-1582979512210-99b6a53386f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80"
      ),
      Icon(
        Icons.arrow_right_alt_sharp,
        size: 150,
      ),
      ImageSquare(height: 150, width: 150, imageURL: "https://upload.wikimedia.org/wikipedia/commons/a/ad/Football_in_Bloomington%2C_Indiana%2C_1996.jpg"
      ),
      Icon(
        Icons.arrow_right_alt_sharp,
        size: 150,
      ),
      ImageSquare(height: 150, width: 150, imageURL: "https://e2.365dm.com/23/02/384x216/skysports-liam-wilson-emanuel-navarrete_6045983.jpg?20230204075325"
      ),
      Icon(
        Icons.arrow_right_alt_sharp,
        size: 150,
      ),
      ImageSquare(height: 150, width: 150, imageURL: "https://cdn.britannica.com/83/126383-050-38B8BE25/Michael-Phelps-American-Milorad-Cavic-final-Serbia-2008.jpg"
      )
    ],
  );
}

SingleChildScrollView VisualTimetable4() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: const <Widget> [
        ImageSquare(height: 150, width: 150, imageURL: "https://www.simplyrecipes.com/thmb/20YogL0tqZKPaNft0xfsrldDj6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2010__01__cinnamon-toast-horiz-a-1800-5cb4bf76bb254da796a137885af8cb09.jpg"
        ),
        Icon(
          Icons.arrow_right_alt_sharp,
          size: 150,
        ),
        ImageSquare(height: 150, width: 150, imageURL: "https://images.unsplash.com/photo-1582979512210-99b6a53386f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80"
        ),
        Icon(
          Icons.arrow_right_alt_sharp,
          size: 150,
        ),
        ImageSquare(height: 150, width: 150, imageURL: "https://upload.wikimedia.org/wikipedia/commons/a/ad/Football_in_Bloomington%2C_Indiana%2C_1996.jpg"
        ),
        Icon(
          Icons.arrow_right_alt_sharp,
          size: 150,
        ),
        ImageSquare(height: 150, width: 150, imageURL: "https://e2.365dm.com/23/02/384x216/skysports-liam-wilson-emanuel-navarrete_6045983.jpg?20230204075325"
        ),
        Icon(
          Icons.arrow_right_alt_sharp,
          size: 150,
        ),
        ImageSquare(height: 150, width: 150, imageURL: "https://cdn.britannica.com/83/126383-050-38B8BE25/Michael-Phelps-American-Milorad-Cavic-final-Serbia-2008.jpg"
        )
      ],
    ),
  );
}
