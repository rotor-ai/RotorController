
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {

  test('should click button', () async {
    FlutterDriver driver = await FlutterDriver.connect();
    await driver.tap(find.byValueKey("connect-to-vehicle-btn"));
    driver.close();
  });

}