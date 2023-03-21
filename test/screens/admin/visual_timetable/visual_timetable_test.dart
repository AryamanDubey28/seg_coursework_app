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
import 'package:seg_coursework_app/pages/visual_timetable/visual_timetable.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';
import 'package:seg_coursework_app/widgets/timetable/picture_grid.dart';

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

  setUp(() {
    toastItem = testItems[0];
    mockUser = MockUser(uid: "user1");
    mockAuth = MockFirebaseAuthentication();
    mockFirestore = FakeFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    when(mockAuth.currentUser).thenReturn(mockUser);
  });
  testWidgets('PictureGrid is shown by default', (WidgetTester tester) async {
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
      // Verify that our PictureGrid is shown by default
      expect(find.byType(PictureGrid), findsOneWidget);
    });
  });

  testWidgets('Button to show all timetables is shown.',
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
      expect(find.byKey(const ValueKey("allTimetablesButton")), findsOneWidget);
    });
  });

  testWidgets(
      'PictureGrid is hidden then reshown with the FloatingActionButton',
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
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.byType(PictureGrid), findsNothing);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.byType(PictureGrid), findsOneWidget);
    });
  });

  testWidgets('Timetable images can be tapped to be removed from the timetable',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      _createData();

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
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage0")));
      await tester.pump();

      expect(find.byKey(const ValueKey("timetableImage0")), findsOneWidget);
      expect(find.byKey(const ValueKey("timetableImage1")), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey("timetableImage1")));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("timetableImage0")), findsOneWidget);
      expect(find.byKey(const ValueKey("timetableImage1")), findsNothing);
    });
  });

  testWidgets(
      'PictureGrid is hidden when 5 images are chosen and shown when less are chosen',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      _createData();

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
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage0")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage0")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage0")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage0")));
      await tester.pump();

      expect(find.byType(PictureGrid), findsNothing);

      await tester.tap(find.byKey(const ValueKey("timetableImage0")));
      await tester.pumpAndSettle();

      expect(find.byType(PictureGrid), findsOneWidget);
    });
  });

  testWidgets(
      'Add to list of lists button is shown when 2 or more images are added to the timetable.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      _createData();

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
      expect(
          find.byKey(const ValueKey("addToListOfListsButton")), findsNothing);

      await tester.tap(find.byKey(const ValueKey("gridImage0")));
      await tester.pump();

      expect(
          find.byKey(const ValueKey("addToListOfListsButton")), findsNothing);

      await tester.tap(find.byKey(const ValueKey("gridImage0")));
      await tester.pump();

      expect(
          find.byKey(const ValueKey("addToListOfListsButton")), findsOneWidget);
    });
  });

  testWidgets('Search bar filters picture grid.', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      _createData();

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

      final searchBar = find.byKey(const ValueKey("searchBar"));

      expect(find.byKey(const ValueKey("gridImage0")), findsOneWidget);

      await tester.tap(searchBar);
      await tester.enterText(searchBar, "boo");
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("gridImage0")), findsNothing);

      await tester.enterText(searchBar, "toast");
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("gridImage0")), findsOneWidget);
    });
  });

  testWidgets('Long pressing a timetable item crosses it out.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      _createData();

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
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage0")));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("gridImage0")));
      await tester.pump();

      expect(find.byKey(const ValueKey("cross1")), findsNothing);
      expect(find.byKey(const ValueKey("cross0")), findsNothing);

      await tester.longPress(find.byKey(const ValueKey("timetableImage1")));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("cross1")), findsOneWidget);
      expect(find.byKey(const ValueKey("cross0")), findsNothing);

      await tester.tap(find.byKey(const ValueKey("timetableImage0")),
          warnIfMissed: false);
      await tester.pump();

      expect(find.byKey(const ValueKey("cross1")), findsNothing);
      expect(find.byKey(const ValueKey("cross0")), findsOneWidget);

      await tester.longPress(find.byKey(const ValueKey("timetableImage0")),
          warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("cross1")), findsNothing);
      expect(find.byKey(const ValueKey("cross0")), findsNothing);
    });
  });

  testWidgets('Having no items will show text to the user.',
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

      expect(find.text("No items to show. Add some in the 'Choice Board' page"),
          findsOneWidget);
    });
  });
}
