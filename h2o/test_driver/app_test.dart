// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('H2o App', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('tap on info tab', () async {
      await driver.runUnsynchronized(() async {
        // Test the default text when no input entered
        await driver.waitFor(find.byValueKey('bottom'));
        expect(await driver.getText(find.byValueKey("empty_stats")), "Add your consumption to view stats");

        // Navigate to add screen and input data
        await driver.tap(find.text("Add"));
        await driver.tap(find.byValueKey('Food'));
        await driver.tap(find.byValueKey('Cereal Products')); // acquire focus
        await driver.enterText('100');
        await driver.waitFor(find.text('100')); // verify text appears on UI
        await driver.tap(find.byValueKey('Submit'));
        await driver.tap(find.text("Stats"));
        // Test the added data updated the stats screen
        expect(await driver.getText(find.byValueKey("daily-chart")), "Daily Chart");

        // Test if the theme switcher is working
        await driver.tap(find.text("Settings"));
        await driver.tap(find.byValueKey('dark-mode'));

        //    var a = await driver.getWidgetDiagnostics(find.byValueKey("text-container"));
//        print("here -> ${a['properties']}");

        await driver.tap(find.text("Info"));

//        await driver.tap(find.text("Goals"));
//        await driver.tap(find.text("Stats"));
      });
    });
  });
}
