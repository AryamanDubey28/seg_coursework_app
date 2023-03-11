import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/models/list_of_timetables.dart';
import 'package:seg_coursework_app/models/timetable.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/widgets/loading_indicator.dart';

import '../../helpers/firebase_functions.dart';
  late FirebaseFunctions firestoreFunctions = FirebaseFunctions(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
        storage: FirebaseStorage.instance
        );

  // final String workflowId = "temp";
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  // late final FirebaseStorage storage;
  // late final File? preSelectedImage;
  /// Given an item's image and name,
  /// - upload the image to the cloud storage
  /// - create a new item with the uploaded image's Url in Firestore
  /// - create a new categoryItem entry in the selected category
  /// - Take the user back to the Choice Boards page
  Future saveWorkflowToFirestore(
        {required Timetable timetable}) async {

    String workflowId = await firestoreFunctions.createWorkflow(
      title: timetable.title,
    )
    .onError((error, stackTrace) => throw FirebaseException(plugin: stackTrace.toString()));
    timetable.setID(id: workflowId);

    for(int i = 0 ; i < timetable.length() ; i++)
    {
    
      await firestoreFunctions.createWorkflowItem(
        workflowItem: timetable.get(i),
        workflowId: workflowId,
      )
      .onError((error, stackTrace) => throw FirebaseException(plugin: stackTrace.toString()));
    }
        
  }

  Future deleteWorkflowFromFirestore(
        {required Timetable timetable}) async {
        try {
          await firestoreFunctions.deleteWorkflow(workflowId: timetable.workflowId);
        } catch (e) {
          print(e);
          // LoadingIndicatorDialog().dismiss();
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //           content: Text(
          //               'An error occurred while communicating with the database'));
          //     });
        }
      // }
  }
  Future<ListOfTimetables> fetchWorkflow() async {
        try {
          return await firestoreFunctions.getListOfTimetables();

          
        } catch (e) {
          print(e);
          return ListOfTimetables(listOfLists: []);
        }
  }

  Future<List<ImageDetails>> fetchLibrary() async {
        try {
          return await firestoreFunctions.getLibraryOfImages();

          
        } catch (e) {
          print(e);
          return [];
        }
  }