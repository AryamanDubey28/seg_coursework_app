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

  // Future saveWorkflowToDatabase(Timetable timetable) async
  // {
  //   await saveWorkflowToFirestore(timetable: timetable);
  // }

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

  //Prints the list for debug purposes. Delete later.
  // void printList()
  // {
  //   for(int i = 0 ; i < listOfLists.length ; i++)
  //   {
  //     print("\n" + i.toString() + " List\n");
  //     for(ImageDetails j in listOfLists[i])
  //     {
  //       print(j.name + " ");
  //     }
  //   }
  // }
  bool isEmpty() => listOfLists.isEmpty;
  void removeAt(int index)
  {
    listOfLists.removeAt(index);
  }
}