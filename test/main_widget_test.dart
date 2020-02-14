import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/main.dart';
import 'package:mobileclient/strings.dart';
import 'package:mobileclient/ui/welcome/welcome_page.dart';

void main() {

  testWidgets('Should construct main widget', (WidgetTester wt) async {
    var app = RotorApp();
    await wt.pumpWidget(app);

    expect(find.byWidgetPredicate((widget) => widget is MaterialApp && widget.title == Strings.APP_TITLE), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is MaterialApp && widget.home is WelcomePage), findsOneWidget);
  });
}