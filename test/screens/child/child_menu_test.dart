import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seg_coursework_app/pages/child/child_menu.dart';
import 'package:seg_coursework_app/widgets/child_menu/child_menu_category_display.dart';
import 'package:seg_coursework_app/services/auth.dart';
import 'package:seg_coursework_app/themes/theme_provider.dart';
import 'package:seg_coursework_app/themes/themes.dart';
import 'package:seg_coursework_app/widgets/child_menu/category_cover_picture.dart';
import 'package:seg_coursework_app/widgets/child_menu/category_title.dart';
import 'package:seg_coursework_app/widgets/child_menu/row_of_images.dart';
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
    await tester.pumpWidget(ThemeProvider(
        themeNotifier: CustomTheme(),
        child: MaterialApp(
          home: ChildMenu(
            mock: true,
          ), //mock PIN
        )));

    expect(find.byType(ChildMenu), findsWidgets);
    expect(find.byType(ChildMenuCategoryDisplay), findsWidgets);
    expect(find.byType(CategoryImage), findsWidgets);
    expect(find.byType(CategoryTitle), findsWidgets);
    expect(find.byType(CategoryImageRow), findsWidgets);
  });

  testWidgets('Test tappable row directs to new screen', (tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(ThemeProvider(
          themeNotifier: CustomTheme(),
          child: MaterialApp(
            home: ChildMenuCategoryDisplay(
                categoryTitle: "Title",
                imagePreviews: [
                  Image.asset("test/assets/test_image.png"),
                ]),
          )));

      await tester.tap(find.byType(ChildMenuCategoryDisplay));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey("boardMenu")), findsWidgets);
      expect(find.byKey(const ValueKey("backButton")), findsWidgets);
      expect(find.byKey(const ValueKey("categoryTitle")), findsWidgets);
      expect(find.byKey(const ValueKey("categoryImage")), findsWidgets);
      expect(find.byKey(const ValueKey("mainGridOfPictures")), findsWidgets);
    });
  });
}
