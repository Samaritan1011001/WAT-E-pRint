import 'package:flutter_test/flutter_test.dart';
import 'package:h2o/blocs/foot_print/foot_print_bloc.dart';
//import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  FootPrintBloc footPrintBloc;
  setUp((){
    footPrintBloc = FootPrintBloc(0);
  });

  tearDown((){
    footPrintBloc?.close();
  });

  test('initial state is correct', () {
    expect(footPrintBloc.state, isA<InitialFootPrintState>());
  });

  group('Add consumption', () {
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

}