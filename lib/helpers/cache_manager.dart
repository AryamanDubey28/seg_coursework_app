import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/image_details.dart';
import '../models/list_of_timetables.dart';
class CacheManager
{
  /// Store the given items in the cache under the name
  /// "<userId>-items"
  static Future storeUserItemsInCache({required List<ImageDetails> userItems}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Convert the list of ImageDetails to a list of JSON maps
      final List<Map<String, dynamic>> jsonList = userItems.map((item) => item.toJson()).toList();

      // Encode the list of JSON maps as a String
      final String itemsJsonString = jsonEncode(jsonList);

      final FirebaseAuth auth = FirebaseAuth.instance;
      await prefs.setString(
          '${auth.currentUser!.uid}-items', itemsJsonString);
    } on Exception catch (e) {
      rethrow;
    }
  }

  /// Fetch the items from the cache under the name
  /// "<userId>-items"
  static Future<List<ImageDetails>> getUserItemsFromCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final FirebaseAuth auth = FirebaseAuth.instance;
    // Get the encoded string from cache
    final String? jsonString = prefs.getString('${auth.currentUser!.uid}-items');

    if (jsonString == null) {
      return [];
    }

    // Decode the string to a list of JSON maps
    final List<dynamic> jsonList = jsonDecode(jsonString);

    // Convert each JSON map to an ImageDetails object
    final List<ImageDetails> itemList = jsonList.map((json) => ImageDetails.fromJson(json)).toList();

    return itemList;
  }

  static Future<void> storeSavedTimetablesInCache({required ListOfTimetables listOfTimetables}) async {
    final prefs = await SharedPreferences.getInstance();
    final String listJson = json.encode(listOfTimetables.toJson());
    final FirebaseAuth auth = FirebaseAuth.instance;
    await prefs.setString('${auth.currentUser!.uid}-timetables', listJson);
  }

  static Future<ListOfTimetables> getSavedTimetablesFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final listJson = prefs.getString('${auth.currentUser!.uid}-timetables');

    if (listJson == null) {
      return ListOfTimetables(listOfLists: []);
    }
    
    return ListOfTimetables.fromJson(json.decode(listJson));
  }

}