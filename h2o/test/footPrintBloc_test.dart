import 'package:flutter_test/flutter_test.dart';
import 'package:h2o/blocs/foot_print/foot_print_bloc.dart';

void main() {
  FootPrintBloc footPrintBloc;
  setUp((){
    footPrintBloc = FootPrintBloc();
  });

  tearDown((){
    footPrintBloc?.close();
  });

  test('initial state is correct', () {
    expect(footPrintBloc.initialState, InitialFootPrintState(0));
  });

  group('Add Item', () {
    test('emits [NewItem] for new item', () {
      final expectedResponse = [
        InitialFootPrintState(0),
//        UpdatePrint(0),
        NewItem(),
      ];
      expectLater(
        footPrintBloc,
        emitsInOrder(expectedResponse),
      );

      footPrintBloc.add(ItemAdded(questionAnswers: {
        "Cereal Products": "0.0",
        "Meat products": "0.0",
        "Dairy products": "0.0",
        "Eggs": "0.0",
        "Vegetables": "0.0",
        "Fruits": "0.0",
        "Starchy roots (potatoes, cassava)": "0.0",
        "How many cups of coffee do you take per day?": "0.0",
      }));
    });
  });

}