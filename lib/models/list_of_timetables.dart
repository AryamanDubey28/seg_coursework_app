import 'image_details.dart';
import 'timetable.dart';

///This model allows for easy handling of saved timetables.
class ListOfTimetables {
  List<Timetable> listOfLists;

  ListOfTimetables({required this.listOfLists});


  ///This method checks if a timetable is already saved in the saved timetables list
  bool existsIn(Timetable other)
  {
    for(int i = 0 ; i < listOfLists.length ; i++)
    {
      if(equals(listOfLists[i], other)) return true;
    }
    return false;
  }

  bool equals(Timetable a, Timetable b)
  {
    if(a.length() != b.length()) return false;

    for(int i = 0 ; i < a.length(); i++)
    {
      if(!a.get(i).equals(b.get(i))) return false;
    }
    return true;
  }

  ///This method attempts to save a timetable in the list of timetables.
  ///Returns false if it's already saved. Saves the timetable and returns true if not.
  void addList(Timetable list)
  {
    listOfLists.add(list);
  }

  List<Timetable> getListOfLists()
  {
    return listOfLists;
  }

  int length()
  {
    return listOfLists.length;
  }

  Timetable operator[](int index)
  {
    return listOfLists[index];
  }

  bool isEmpty() => listOfLists.isEmpty;
  void removeAt(int index)
  {
    listOfLists.removeAt(index);
  }

  factory ListOfTimetables.fromJson(Map<String, dynamic> json) {
    final list = json['listOfLists'] as List<dynamic>;
    final listOfLists = list
        .map((item) => Timetable.fromJson(item as Map<String, dynamic>))
        .toList();
    return ListOfTimetables(listOfLists: listOfLists);
  }

  Map<String, dynamic> toJson() {
    final jsonListOfLists =
        listOfLists.map((item) => item.toJson()).toList();
    return {'listOfLists': jsonListOfLists};
  }
}