import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lvlup/main.dart' as app; //import our main.dart in lib as 'app'

void main() {

  group('authentication test', () {
    //Creates and intializes the binding to the flutter driver
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Attempting to log in with an account that is not created yet', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle(); //Check if any animations are running and no entering of data is being done

      //Create finders for textform field
      //1, search by type, by widget or by key(need specify in code)
      final emailFormField = find.byType(TextField).first;
      final passwordFormField = find.byType(TextField).last;
      final loginButton = find.byType(ElevatedButton).first;

      //Enter text for email address
      await widgetTester.enterText(emailFormField, 'e0958452@u.nus.edu'); //My email
      await widgetTester.enterText(passwordFormField, '123'); //my password
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(loginButton);
      await widgetTester.pumpAndSettle();
    });

    testWidgets('Wrong email logging in', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle(); //Check if any animations are running and no entering of data is being done

      //Create finders for textform field
      //1, search by type, by widget or by key(need specify in code)
      final emailFormField = find.byType(TextField).first;
      final passwordFormField = find.byType(TextField).last;
      final loginButton = find.byType(ElevatedButton).first;

      //Enter text for email address
      await widgetTester.enterText(emailFormField, '123'); //My email
      await widgetTester.enterText(passwordFormField, '123'); //my password
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(loginButton);
      await widgetTester.pumpAndSettle();
    });

    testWidgets('Wrong credentials logging in', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle(); //Check if any animations are running and no entering of data is being done

      //Create finders for textform field
      //1, search by type, by widget or by key(need specify in code)
      final emailFormField = find.byType(TextField).first;
      final passwordFormField = find.byType(TextField).last;
      final loginButton = find.byType(ElevatedButton).first;

      //Enter text for email address
      await widgetTester.enterText(emailFormField, 'taysebastian95@gmail.com'); //My email
      await widgetTester.enterText(passwordFormField, 'test'); //my password
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(loginButton);
      await widgetTester.pumpAndSettle();
    });

    testWidgets('Logging in with right credentials', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle(); //Check if any animations are running and no entering of data is being done

      //Create finders for textform field
      //1, search by type, by widget or by key(need specify in code)
      final emailFormField = find.byType(TextField).first;
      final passwordFormField = find.byType(TextField).last;
      final loginButton = find.byType(ElevatedButton).first;

      //Enter text for email address
      await widgetTester.enterText(emailFormField, 'taysebastian95@gmail.com'); //My email
      await widgetTester.enterText(passwordFormField, 'pwd123'); //my password
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(loginButton);
      await widgetTester.pumpAndSettle();

      //Now logged in to my account
    });

    
  });

  
}