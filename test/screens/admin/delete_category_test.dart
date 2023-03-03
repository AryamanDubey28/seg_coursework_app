import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:seg_coursework_app/pages/admin/delete_choice_board_category.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class CollectionReferenceMock extends Mock implements CollectionReference {}

class DocumentReferenceMock extends Mock implements DocumentReference {}

void main() {
  late DeleteChoiceBoardCategory deleteChoiceBoardCategory;

  // Mocks
  late MockFirebaseFirestore mockFirestore;

  // Test values
  const categoryId = '1234';

  setUp(() {
    mockFirestore = MockFirebaseFirestore();

    deleteChoiceBoardCategory =
        DeleteChoiceBoardCategory(categoryId: categoryId);
  });

  testWidgets('DeleteChoiceBoardCategory - should show confirmation dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: deleteChoiceBoardCategory));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Warning!'), findsOneWidget);
    expect(find.text('Are you sure you want to delete this category?'),
        findsOneWidget);
    expect(find.text('No'), findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
  });

  testWidgets(
      'DeleteChoiceBoardCategory - should delete category from collections on confirmation',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: deleteChoiceBoardCategory));

    final confirmButton = find.text('Yes');
    expect(confirmButton, findsOneWidget);

    // Mock the Firestore calls
    when(mockFirestore.collection('categories')).thenReturn(
        CollectionReferenceMock() as CollectionReference<Map<String, dynamic>>);
    when(mockFirestore.collection('categories').doc(categoryId)).thenReturn(
        DocumentReferenceMock() as DocumentReference<Map<String, dynamic>>);

    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    verify(mockFirestore.collection('categories').doc(categoryId).delete());
  });
}
