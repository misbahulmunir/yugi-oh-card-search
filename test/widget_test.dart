// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yugioh_card_search/main.dart';

void main() {
  testWidgets('Yu-Gi-Oh! Card Search App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const YugiohCardSearchApp());

    // Verify that the app title is displayed
    expect(find.text('Yu-Gi-Oh! Card Search'), findsOneWidget);
    
    // Verify that the bottom navigation has both tabs
    expect(find.text('Search Cards'), findsOneWidget);
    expect(find.text('Search Decks'), findsOneWidget);
    
    // Verify that the search field is present
    expect(find.byType(TextField), findsOneWidget);
  });
}
