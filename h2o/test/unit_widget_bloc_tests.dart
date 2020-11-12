import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:h2o/blocs/foot_print/foot_print_bloc.dart';
//import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:h2o/blocs/theme/theme_bloc.dart';
import 'package:h2o/main.dart';
import 'package:h2o/themes/app_themes.dart';

void main() {
  FootPrintBloc footPrintBloc;
  ThemeBloc themeBloc;
  setUp((){
    footPrintBloc = FootPrintBloc(0);
    themeBloc = ThemeBloc();
  });

  tearDown((){
    footPrintBloc?.close();
    themeBloc?.close();
  });

  group('THEME BLOC TESTS: ', () {
    test('initial state is correct', () {
      expect(footPrintBloc.state, isA<InitialFootPrintState>());
      expect(themeBloc.initialState.themeData.brightness, Brightness.light);
    });

    test('has white canvas color', () {
      expect(themeBloc.initialState.themeData.canvasColor, Colors.white);
    });

    test('has white primary color', () {
      expect(themeBloc.initialState.themeData.primaryColor, Colors.white);
    });

    blocTest(
      'adding an event to switch the theme',
      build: () => themeBloc,
      act: (bloc) => bloc.add(ThemeChanged(switchVal:false, theme: AppTheme.DarkTheme)),
      expect: [isA<ThemeState>()],
    );

//    testWidgets('Fallback theme', (WidgetTester tester) async {
//      BuildContext capturedContext;
//      await tester.pumpWidget(
//          Builder(
//              builder: (BuildContext context) {
//                capturedContext = context;
//                return Container();
//              }
//          )
//      );
//      expectLater(Theme.of(capturedContext).brightness, Brightness.dark);
//    });

  });


  group('FOOTPRINT BLOC TESTS: ', () {
    blocTest(
      'Emits Updated Water Foot Print',
      build: () => footPrintBloc,
      act: (bloc) => bloc.add(UpdateFootPrint(questionAnswers: {
        "Cereal Products": "0.0",
        "Meat products": "0.0",
        "Dairy products": "0.0",
        "Eggs": "0.0",
        "Vegetables": "0.0",
        "Fruits": "0.0",
        "Starchy roots (potatoes, cassava)": "0.0",
        "How many cups of coffee do you take per day?": "0.0",
      })),
      expect: [isA<UpdatedFootPrint>()],
    );
  });
  group('WIDGET TESTS:', () {
    testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      final titleFinder = find.text('Daily Water Use');
      final submitFinder = find.text('Goals');
      expect(titleFinder, findsOneWidget);
      expect(submitFinder, findsOneWidget);
    });
  });


}