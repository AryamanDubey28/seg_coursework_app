import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:seg_coursework_app/helpers/firebase_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_functions_test.mocks.dart';

class FirebaseFunctionsTest extends Mock implements FirebaseFunctions {}

@GenerateMocks([FirebaseFunctionsTest])
Future<void> main() async {
  late MockFirebaseFunctionsTest firebaseFunctions;
  setUpAll(() {
    firebaseFunctions = MockFirebaseFunctionsTest();
  });

  test("create item successfully", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    when(
      firebaseFunctions.createItem(name: name, imageUrl: imageUrl),
    ).thenAnswer((realInvocation) async {
      return Future(() => "0");
    });

    expect(await firebaseFunctions.createItem(name: name, imageUrl: imageUrl),
        "0");
  });

  test("create item throws exception", () async {
    const String name = "Water";
    const String imageUrl = "Nova-water.jpeg";

    when(firebaseFunctions.createItem(name: name, imageUrl: imageUrl))
        .thenThrow(FirebaseException(
            plugin: "exception due to server connection issue"));

    expect(
        () async =>
            await firebaseFunctions.createItem(name: name, imageUrl: imageUrl),
        throwsA(isA<FirebaseException>()));
  });

  test("create categoryItem throws exception", () async {
    const String itemName = "Water";
    const String itemId = "0";
    const String categoryId = "1";
    const String imageUrl = "Nova-water.jpeg";

    when(firebaseFunctions.createCategoryItem(
            name: itemName,
            imageUrl: imageUrl,
            itemId: itemId,
            categoryId: categoryId))
        .thenThrow(FirebaseException(
            plugin: "exception due to server connection issue"));

    expect(
        () async => await firebaseFunctions.createCategoryItem(
            name: itemName,
            imageUrl: imageUrl,
            itemId: itemId,
            categoryId: categoryId),
        throwsA(isA<FirebaseException>()));
  });
}
