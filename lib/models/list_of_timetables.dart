import 'timetable.dart';

///This model allows for easy handling of saved timetables.
class ListOfTimetables {
  List<Timetable> listOfLists;

  ListOfTimetables({required this.listOfLists});

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

  bool equals(ListOfTimetables other)
  {
    if(listOfLists.length != other.listOfLists.length) return false;

    for(int i = 0 ; i < listOfLists.length; i++)
    {
      if(!listOfLists[i].equals(other[i])) return false;
    }
    return true;
  }

  ///Converts a json map (from the cache) to an object.
  factory ListOfTimetables.fromJson(Map<String, dynamic> json) {
    final list = json['listOfLists'] as List<dynamic>;
    final listOfLists = list
        .map((item) => Timetable.fromJson(item as Map<String, dynamic>))
        .toList();
    return ListOfTimetables(listOfLists: listOfLists);
  }

  ///Converts an object to a json map (to be stored in the cache.)
  Map<String, dynamic> toJson() {
    final jsonListOfLists =
        listOfLists.map((item) => item.toJson()).toList();
    return {'listOfLists': jsonListOfLists};
  }
}