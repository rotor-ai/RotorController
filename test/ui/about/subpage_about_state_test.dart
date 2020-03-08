import 'package:flutter_test/flutter_test.dart';
import 'package:mobileclient/ui/about/subpage_about.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info/package_info.dart';

void main() {

  MockPackageInfo mockPackageInfo;

  setUp(() {
    mockPackageInfo = new MockPackageInfo();
  });

  test('Should retrieve app version and update state', () async {
    var changeStateWasCalled = false;
    when(mockPackageInfo.version).thenReturn("1.2.3");
    var packageInfoFuture = Future.value(mockPackageInfo);
    var testObj = SubpageAboutState(packageInfoFuture);
    testObj.changeState = (SubpageAboutState state, Function f) {
      changeStateWasCalled = state == testObj;
      f();
    };

    testObj.initState();
    await packageInfoFuture;//await for our future to complete

    expect(testObj.packageInfo.version, "1.2.3");
    expect(changeStateWasCalled, true, reason:"Change state should have been called, but was not.");
  });

}

class MockPackageInfo extends Mock implements PackageInfo {}