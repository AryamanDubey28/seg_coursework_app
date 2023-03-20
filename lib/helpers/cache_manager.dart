import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seg_coursework_app/models/categories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/image_details.dart';
import '../models/list_of_timetables.dart';

///This class handles all cache operations including storing and fetching.
class CacheManager {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  /// Store the given items in the cache under the name
  /// "<userId>-items"
  static Future storeUserItemsInCache(
      {required List<ImageDetails> userItems}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Convert the list of ImageDetails to a list of JSON maps
      final List<Map<String, dynamic>> jsonList =
          userItems.map((item) => item.toJson()).toList();

      // Encode the list of JSON maps as a String
      final String itemsJsonString = jsonEncode(jsonList);

      await prefs.setString('${auth.currentUser!.uid}-items', itemsJsonString);
    } on Exception catch (e) {
      rethrow;
    }
  }

  /// Fetch the items from the cache under the name
  /// "<userId>-items"
  static Future<List<ImageDetails>> getUserItemsFromCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the encoded string from cache
    final String? jsonString =
        prefs.getString('${auth.currentUser!.uid}-items');

    if (jsonString == null) {
      return [];
    }

    // Decode the string to a list of JSON maps
    final List<dynamic> jsonList = jsonDecode(jsonString);

    // Convert each JSON map to an ImageDetails object
    final List<ImageDetails> itemList =
        jsonList.map((json) => ImageDetails.fromJson(json)).toList();

    return itemList;
  }

  /// Store the given timetables in the cache under the name
  /// "<userId>-timetables"
  static Future<void> storeSavedTimetablesInCache(
      {required ListOfTimetables listOfTimetables}) async {
    final prefs = await SharedPreferences.getInstance();
    final String listJson = json.encode(listOfTimetables.toJson());

    await prefs.setString('${auth.currentUser!.uid}-timetables', listJson);
  }

  /// Fetch the timetables from the cache under the name
  /// "<userId>-timetables"
  static Future<ListOfTimetables> getSavedTimetablesFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final listJson = prefs.getString('${auth.currentUser!.uid}-timetables');

    if (listJson == null) {
      return ListOfTimetables(listOfLists: []);
    }

    return ListOfTimetables.fromJson(json.decode(listJson));
  }

  /// Store the given Categories in the cache under the name
  /// "<userId>-categories"
  static Future storeCategoriesInCache(
      {required Categories userCategories}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String categoriesJson = userCategories.toJsonString(userCategories);
      await prefs.setString(
          '${auth.currentUser!.uid}-categories', categoriesJson);
    } on Exception catch (e) {
      rethrow;
    }
  }

  /// Return the user's choice boards data that's in the cache.
  /// Throw an exception if the cache is empty
  static Future<Categories> getUserCategoriesFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? categoriesJson =
        prefs.getString('${auth.currentUser!.uid}-categories');
    if (categoriesJson != null) {
      return Categories(categories: []).fromJsonString(categoriesJson);
    } else {
      throw Exception("No data in the cache!");
    }
  }
}
