
import 'image_details.dart';

class ListOfListsOfImageDetails {
  List<List<ImageDetails>> listOfLists;

  ListOfListsOfImageDetails({required this.listOfLists});


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