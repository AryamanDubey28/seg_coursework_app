import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/models/clickable_image.dart';
import 'package:seg_coursework_app/pages/child_menu/customizable_column.dart';
import 'package:seg_coursework_app/pages/child_menu/customizable_row.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';
import 'package:seg_coursework_app/widgets/category_image.dart';
import 'package:seg_coursework_app/widgets/category_row.dart';
import 'package:seg_coursework_app/widgets/category_title.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

// Test ensures that column of rows (categories) is displayed on screen
void main() {
  late Auth auth;
  const _email = 'ilyas@yopmail.com';
  const _uid = 'sampleUid';
  const _displayName = 'ilyas';
  const _password = 'Test@123';
  final _mockUser = MockUser(
    uid: _uid,
    email: _email,
    displayName: _displayName,
  );

  setUpAll(() async {
    final MockFirebaseAuth _mockAuth = MockFirebaseAuth();
    auth = Auth(auth: _mockAuth);
  });
  testWidgets('Test column (with rows) is present', (tester) async {
<<<<<<< HEAD
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: CustomizableColumn(
              mock: true,
            ),
          )));
=======
    await tester.pumpWidget(ThemeProvider(
        themeNotifier: CustomTheme(),
        child: MaterialApp(
          home: CustomizableColumn(
            mock: true,
          ), //mock PIN
        )));
>>>>>>> master

      expect(find.byType(CustomizableColumn), findsWidgets);
      expect(find.byType(CustomizableRow), findsWidgets);
      expect(find.byType(CategoryImage), findsWidgets);
      expect(find.byType(CategoryTitle), findsWidgets);
      expect(find.byType(CategoryImageRow), findsWidgets);
    });
  });

  testWidgets('Test tappable row directs to new screen', (tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
<<<<<<< HEAD
            home: CustomizableRow(
                categoryTitle: "Title",
                imagePreviews: test_list_clickable_images),
=======
            home: CustomizableRow(categoryTitle: "Title", imagePreviews: [
              Image.asset("test/assets/test_image.png"),
            ]),
>>>>>>> master
          )));

      await tester.tap(find.byType(CustomizableRow));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("boardMenu")), findsWidgets);
      expect(find.byKey(const ValueKey("backButton")), findsWidgets);
      expect(find.byKey(const ValueKey("categoryTitle")), findsWidgets);
      expect(find.byKey(const ValueKey("categoryImage")), findsWidgets);
      expect(find.byKey(const ValueKey("mainGridOfPictures")), findsWidgets);
    });
  });
}
