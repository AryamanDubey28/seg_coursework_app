
import 'image_details.dart';

///This model allows for easy handling of saved timetables.
class ListOfListsOfImageDetails {
  List<List<ImageDetails>> listOfLists;

  ListOfListsOfImageDetails({required this.listOfLists});


  ///This method checks if a timetable is already saved in the saved timetables list
  bool existsIn(List<ImageDetails> other)
  {
    for(List<ImageDetails> list in listOfLists)
    {
      if(equals(list, other)) return true;
    }
    return false;
  }

  bool equals(List<ImageDetails> a, List<ImageDetails> b)
  {
    if(a.length != b.length) return false;

    for(int i = 0 ; i < a.length; i++)
    {
      if(!a[i].equals(b[i])) return false;
    }
    return true;
  }

  ///This method attempts to save a timetable in the list of timetables.
  ///Returns false if it's already saved. Saves the timetable and returns true if not.
  bool addList(List<ImageDetails> list)
  {
    if(existsIn(list)) return false;
    listOfLists.add(list);
    return true;
  }

  List<List<ImageDetails>> getListOfLists()
  {
    return listOfLists;
  }

  int length()
  {
    return listOfLists.length;
  }

  List<ImageDetails> operator[](int index)
  {
    return listOfLists[index];
  }

  //Prints the list for debug purposes. Delete later.
  void printList()
  {
    for(int i = 0 ; i < listOfLists.length ; i++)
    {
      print("\n" + i.toString() + " List\n");
      for(ImageDetails j in listOfLists[i])
      {
        print(j.name + " ");
      }
    }
  }

  void removeAt(int index)
  {
    listOfLists.removeAt(index);
  }
}