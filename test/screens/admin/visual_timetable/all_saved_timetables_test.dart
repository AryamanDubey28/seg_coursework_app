import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/data/visual_timetable_data.dart';
import 'package:seg_coursework_app/services/firebase_functions.dart';
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/models/image_details.dart';
import 'package:seg_coursework_app/models/timetable.dart';
import 'package:seg_coursework_app/pages/admin/visual_timetable/all_saved_timetables.dart';
import 'package:seg_coursework_app/pages/admin/visual_timetable/visual_timetable.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';
import 'package:seg_coursework_app/widgets/timetable/timetable_list_dialog.dart';

void main() {
  late FirebaseAuth mockAuth;
  late FirebaseFirestore mockFirestore;
  late FirebaseStorage mockStorage;
  late MockUser mockUser;
  late ImageDetails toastItem;

  Future<void> _createData() async {
    FirebaseFunctions firebaseFunctions = FirebaseFunctions(
        auth: mockAuth, firestore: mockFirestore, storage: mockStorage);

    await firebaseFunctions.createItem(
      name: toastItem.name,
      imageUrl: toastItem.imageUrl,
    );
  }

  Future<void> _createTimetable() async {
    FirebaseFunctions firebaseFunctions = FirebaseFunctions(
        auth: mockAuth, firestore: mockFirestore, storage: mockStorage);

    await firebaseFunctions.saveWorkflowToFirestore(
        timetable: Timetable(listOfImages: [toastItem, testItems[1]]));
  }

  setUp(() {
    toastItem = testItems[0];
    mockUser = MockUser(uid: "user1");
    mockAuth = MockFirebaseAuthentication();
    mockFirestore = FakeFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    when(mockAuth.currentUser).thenReturn(mockUser);
  });

  testWidgets('All timetables shows nothing saved by default',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: VisualTimeTable(
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage,
              isMock: true,
            ),
          )));

      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey("allTimetablesButton")));
      await tester.pumpAndSettle();

      expect(find.byType(AllSavedTimetables), findsOneWidget);

      expect(find.byKey(const ValueKey("timetableRow0")), findsNothing);

      await tester.tap(find.byKey(const ValueKey("backButton")));
      await tester.pumpAndSettle();

      expect(find.byType(VisualTimeTable), findsOneWidget);
    });
  });

  testWidgets('A timetable is saved when the add button is tapped.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await _createData();

      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: VisualTimeTable(
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage,
              isMock: true,
            ),
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("gridImage0")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("gridImage0")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("addToListOfListsButton")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("hideShowButton")),
          warnIfMissed: false);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("addToListOfListsButton")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("cancelButton")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("addToListOfListsButton")));
      await tester.pumpAndSettle();

      final textFieldFinder = find.byKey(const ValueKey("titleField"));

      await tester.tap(textFieldFinder);
      await tester.pump();
      await tester.enterText(textFieldFinder, "My Timetable");
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("saveButton")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("allTimetablesButton")));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("timetableRow0")), findsOneWidget);
    });
  });

  testWidgets('A timetable is deleted when the delete button is tapped.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await _createTimetable();

      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: VisualTimeTable(
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage,
              isMock: true,
            ),
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("allTimetablesButton")));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("deleteButton0")), findsOneWidget);

      expect(find.byKey(const ValueKey("timetableRow0")), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey("deleteButton0")));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("deleteButton0")), findsNothing);

      expect(find.byKey(const ValueKey("timetableRow0")), findsNothing);
    });
  });

  testWidgets(
      'A dialog that contains the timetable is shown when the timetable is tapped.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await _createTimetable();

      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: VisualTimeTable(
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage,
              isMock: true,
            ),
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("allTimetablesButton")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("timetableRow0")));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(TimetableListDialog), findsOneWidget);
    });
  });

  testWidgets('Tapping a timetable item crosses it out.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await _createTimetable();

      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: VisualTimeTable(
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage,
              isMock: true,
            ),
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("allTimetablesButton")));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("timetableRow0")));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("cross0")), findsNothing);

      await tester.tap(find.byKey(const ValueKey("timetableDialogImage0")));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("cross0")), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey("timetableDialogImage0")),
          warnIfMissed: false);
      await tester.pump();

      expect(find.byKey(const ValueKey("cross0")), findsNothing);
    });
  });

  testWidgets('Having no timetables will show text to the user.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: VisualTimeTable(
              auth: mockAuth,
              firestore: mockFirestore,
              storage: mockStorage,
              isMock: true,
            ),
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey("allTimetablesButton")));
      await tester.pumpAndSettle();

      expect(
          find.text(
              "No saved timetables. Save one in the 'Visual Timetable' page."),
          findsOneWidget);
    });
  });
}
