import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

//Reference get firebaseStorage => FirebaseStorage.instance.ref('images/');

class StorageService extends GetxService {
  final storage = FirebaseStorage.instance;

  Future<String?> getImage(String? imgName) async {
    if (imgName == null) {
      return null;
    }
    try {
      var urlRef = storage.ref('images/$imgName').getDownloadURL();
      return urlRef;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
