import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:seg_coursework_app/pages/admin/admin_interface.dart';
import 'package:seg_coursework_app/main.dart' as app;
import 'package:seg_coursework_app/pages/child_menu/customizable_column.dart';

void main() {
  //IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigate from child mode to admin page tests', () {
    testWidgets('input correct PIN, verify routes to Admin Page',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(); //waits to see if application is ready

      await Future.delayed(Duration(seconds: 2));
      print("start");

      final ScaffoldState state =
          tester.firstState(find.byKey(Key("admin_boards_scaffold")));
      state.openDrawer();
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      print("---------------> opened drawer by state");

      final Finder childMenu = find.byKey(Key("childMode"));
      await tester.tap(childMenu);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      print("clicked menu, $childMenu");

      final Finder logoutButton = find.byKey(Key("logoutButton"));
      final Finder passwordTextField = find.byKey(Key("logoutTextField"));
      final Finder submitButton = find.byKey(Key("submitButton"));
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      await tester.enterText(passwordTextField, "0000");
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      print("clicked logout");

      expect(find.byType(AdminChoiceBoards), findsOneWidget);
    });

    testWidgets(
        'input incorrect PIN, verify message pops up and stays on Child Page',
        (tester) async {
      app.main();
      await tester.pumpAndSettle(); //waits to see if application is ready

      await Future.delayed(Duration(seconds: 2));
      print("start");

      final ScaffoldState state =
          tester.firstState(find.byKey(Key("admin_boards_scaffold")));
      state.openDrawer();
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      print("---------------> opened drawer by state");

      final Finder childMenu = find.byKey(Key("childMode"));
      await tester.tap(childMenu);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      print("clicked menu, $childMenu");

      final Finder logoutButton = find.byKey(Key("logoutButton"));
      final Finder passwordTextField = find.byKey(Key("logoutTextField"));
      final Finder submitButton = find.byKey(Key("submitButton"));
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      await tester.enterText(passwordTextField, "1111");
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));
      print("clicked logout");

      expect(find.text("Incorrect PIN Provided"), findsOneWidget);
      await tester.tapAt(Offset(200, 200));
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 2));

      expect(find.byType(CustomizableColumn), findsOneWidget);
    });
  });
}
