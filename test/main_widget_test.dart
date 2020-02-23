import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/main.dart';
import 'package:mobileclient/strings.dart';
import 'package:mobileclient/ui/welcome/page_welcome.dart';

void main() {

  testWidgets('Should construct main widget', (WidgetTester wt) async {
    var app = RotorApp();
    await wt.pumpWidget(app);

    MaterialApp materialApp = wt.widget(find.byType(MaterialApp));

    expect(materialApp.title, Strings.APP_TITLE);
    expect(materialApp.home is WelcomePage, true);
  });

  testWidgets('Should setup named routes', (WidgetTester wt) async {

    var app = RotorApp();
    await wt.pumpWidget(app);

    MaterialApp materialApp = wt.widget(find.byType(MaterialApp));
    expect(materialApp.routes.containsKey('VehicleMonitor'), true);
  });

  test('testing cirrusci badge', () {
    expect(true, false);
  });

}